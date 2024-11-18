# Copyright 2023 StreamNative, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

data "google_compute_zones" "available" {
  project = var.project_id
}

# Declared to infer the project number
data "google_project" "project" {
  project_id = var.project_id
}

resource "google_kms_key_ring" "keyring" {
  count    = var.enable_database_encryption && var.database_encryption_key_name == "" ? 1 : 0 # Only create if the feature is enabled and the customer didn't provide a key
  name     = "sn-keyring-${var.cluster_name}"
  location = var.region
}

resource "google_kms_crypto_key" "gke_encryption_key" {
  count           = var.enable_database_encryption && var.database_encryption_key_name == "" ? 1 : 0 # Only create if the feature is enabled and the customer didn't provide a key
  name            = "sn-gke-key-${var.cluster_name}"
  key_ring        = google_kms_key_ring.keyring[0].id
  rotation_period = "12960000s" #150 days
}

# Required for GKE to use the encryption key
resource "google_project_iam_member" "kms_iam_binding" {
  count = var.enable_database_encryption ? 1 : 0 # Only create if the feature is enabled
  project = var.project_id
  role    = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member  = "serviceAccount:service-${data.google_project.project.number}@container-engine-robot.iam.gserviceaccount.com"
}

locals {

  ### Node Pools
  default_node_pool_config = {
    auto_repair        = var.node_pool_auto_repair
    auto_upgrade       = var.node_pool_auto_upgrade
    autoscaling        = var.node_pool_autoscaling
    disk_size_gb       = var.node_pool_disk_size
    disk_type          = var.node_pool_disk_type
    enable_secure_boot = var.node_pool_secure_boot
    image_type         = var.node_pool_image_type
    initial_node_count = var.node_pool_autoscaling_initial_count
    local_ssd_count    = var.node_pool_ssd_count
    machine_type       = var.node_pool_machine_type
    max_pods_per_node  = var.node_pool_max_pods_per_node
    max_count          = var.node_pool_autoscaling_max_size
    min_count          = var.node_pool_autoscaling_min_size
    name               = var.node_pool_name
    node_count         = var.node_pool_autoscaling ? null : var.node_pool_count
    node_locations     = var.node_pool_locations != "" ? var.node_pool_locations : ""
    service_account    = var.create_service_account ? "" : var.node_pool_service_account
    version            = var.node_pool_auto_upgrade ? null : var.node_pool_version
  }
  func_pool_config = {
    auto_repair        = var.func_pool_auto_repair
    auto_upgrade       = var.func_pool_auto_upgrade
    autoscaling        = var.func_pool_autoscaling
    disk_size_gb       = var.func_pool_disk_size
    disk_type          = var.func_pool_disk_type
    enable_secure_boot = var.node_pool_secure_boot
    image_type         = var.func_pool_image_type
    initial_node_count = var.func_pool_autoscaling_initial_count
    local_ssd_count    = var.func_pool_ssd_count
    machine_type       = var.func_pool_machine_type
    max_pods_per_node  = var.func_pool_max_pods_per_node
    max_count          = var.func_pool_autoscaling_max_size
    min_count          = var.func_pool_autoscaling_min_size
    name               = var.func_pool_name
    node_count         = var.func_pool_autoscaling ? null : var.func_pool_count
    node_locations     = var.func_pool_locations != "" ? var.func_pool_locations : var.node_pool_locations
    service_account    = var.create_service_account ? "" : var.func_pool_service_account
    version            = var.func_pool_auto_upgrade ? null : var.func_pool_version
  }
  node_pools = var.enable_func_pool ? [local.default_node_pool_config, local.func_pool_config] : [local.default_node_pool_config]
  node_pools_labels = {
    all = {
      cluster_name = var.cluster_name
      managed_by   = "terraform"
    }
  }
  node_pools_metadata = {
    all = {}
  }
  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/ndev.clouddns.readwrite",
    ]
  }

  node_pools_taints = {
    all = [
      for each in [
        {
          key    = "node.cilium.io/agent-not-ready"
          value  = true
          effect = "NO_EXECUTE"
        }
      ] : each if var.enable_cilium
    ]

    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]

    func-pool = [
      {
        key    = "func-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  #Ensure database_encryption_key_name is of the format <KEYRING_NAME>/cryptoKeys/<KEY_NAME>
  database_encryption = var.enable_database_encryption ? (var.database_encryption_key_name != "" ? [{ "key_name" : "projects/${var.project_id}/locations/${var.region}/keyRings/${var.database_encryption_key_name}", "state" : "ENCRYPTED" }] : [{ "key_name" : google_kms_crypto_key.gke_encryption_key[0].id, "state" : "ENCRYPTED" }]) : [{ "key_name" : "", "state" : "DECRYPTED" }]
}

module "gke" {
  count   = var.enable_private_gke ? 0 : 1
  source  = "terraform-google-modules/kubernetes-engine/google"
  name    = var.cluster_name
  version = "32.0.0"

  add_cluster_firewall_rules        = var.add_cluster_firewall_rules
  add_master_webhook_firewall_rules = var.add_master_webhook_firewall_rules
  add_shadow_firewall_rules         = var.add_shadow_firewall_rules
  authenticator_security_group      = var.authenticator_security_group
  cluster_autoscaling               = var.cluster_autoscaling_config
  default_max_pods_per_node         = var.default_max_pods_per_node
  datapath_provider                 = var.datapath_provider
  http_load_balancing               = var.cluster_http_load_balancing
  ip_range_pods                     = var.secondary_ip_range_pods
  ip_range_services                 = var.secondary_ip_range_services
  firewall_inbound_ports            = var.firewall_inbound_ports
  kubernetes_version                = var.kubernetes_version
  logging_service                   = var.logging_service
  logging_enabled_components        = var.logging_enabled_components
  monitoring_enabled_components     = var.monitoring_enabled_components
  maintenance_exclusions            = var.maintenance_exclusions
  maintenance_start_time            = var.maintenance_window
  master_authorized_networks        = var.master_authorized_networks
  network                           = var.vpc_network
  network_project_id                = var.network_project_id
  network_policy                    = var.cluster_network_policy
  node_pools                        = local.node_pools
  node_pools_labels                 = local.node_pools_labels
  node_pools_metadata               = local.node_pools_metadata
  node_pools_oauth_scopes           = local.node_pools_oauth_scopes
  node_pools_taints                 = local.node_pools_taints
  project_id                        = var.project_id
  region                            = var.region
  remove_default_node_pool          = true
  release_channel                   = var.release_channel
  subnetwork                        = var.vpc_subnet
  database_encryption               = local.database_encryption
  deletion_protection               = var.deletion_protection

  enable_cilium_clusterwide_network_policy = var.enable_cilium_clusterwide_network_policy
  enable_multi_networking                  = var.enable_multi_networking
}

module "gke_private" {
  count  = var.enable_private_gke ? 1 : 0
  source = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"

  name    = var.cluster_name
  version = "32.0.0"

  add_cluster_firewall_rules        = var.add_cluster_firewall_rules
  add_master_webhook_firewall_rules = var.add_master_webhook_firewall_rules
  add_shadow_firewall_rules         = var.add_shadow_firewall_rules
  authenticator_security_group      = var.authenticator_security_group
  cluster_autoscaling               = var.cluster_autoscaling_config
  default_max_pods_per_node         = var.default_max_pods_per_node
  datapath_provider                 = var.datapath_provider
  http_load_balancing               = var.cluster_http_load_balancing
  ip_range_pods                     = var.secondary_ip_range_pods
  ip_range_services                 = var.secondary_ip_range_services
  firewall_inbound_ports            = var.firewall_inbound_ports
  kubernetes_version                = var.kubernetes_version
  logging_service                   = var.logging_service
  logging_enabled_components        = var.logging_enabled_components
  monitoring_enabled_components     = var.monitoring_enabled_components
  maintenance_exclusions            = var.maintenance_exclusions
  maintenance_start_time            = var.maintenance_window
  master_authorized_networks        = var.master_authorized_networks
  network                           = var.vpc_network
  network_project_id                = var.network_project_id
  network_policy                    = var.cluster_network_policy
  node_pools                        = local.node_pools
  node_pools_labels                 = local.node_pools_labels
  node_pools_metadata               = local.node_pools_metadata
  node_pools_oauth_scopes           = local.node_pools_oauth_scopes
  node_pools_taints                 = local.node_pools_taints
  project_id                        = var.project_id
  region                            = var.region
  remove_default_node_pool          = true
  release_channel                   = var.release_channel
  subnetwork                        = var.vpc_subnet
  enable_private_nodes              = var.enable_private_nodes
  master_ipv4_cidr_block            = var.master_ipv4_cidr_block
  database_encryption               = local.database_encryption
  deletion_protection               = var.deletion_protection

  enable_cilium_clusterwide_network_policy = var.enable_cilium_clusterwide_network_policy
  enable_multi_networking                  = var.enable_multi_networking
}

moved {
  from = module.gke
  to   = module.gke[0]
}

locals {
  cluster_name = try(module.gke[0].name, module.gke_private[0].name)
}

resource "kubernetes_namespace" "sn_system" {
  count = var.enable_resource_creation ? 1 : 0
  metadata {
    name = "sn-system"

    labels = {
      "istio.io/rev"               = "sn-stable"
      "cloud.streamnative.io/role" = "sn-system"
    }
  }
  depends_on = [
    module.gke[0],
    module.gke_private[0]
  ]
}

moved {
  from = kubernetes_namespace.sn_system
  to   = kubernetes_namespace.sn_system[0]
}

resource "kubernetes_storage_class" "sn_default" {
  count = var.enable_resource_creation ? 1 : 0
  metadata {
    name = "sn-default"
    labels = {
      "addonmanager.kubernetes.io/mode" = "EnsureExists"
    }
  }
  storage_provisioner = "pd.csi.storage.gke.io"
  parameters = {
    type = var.storage_class_default_ssd ? "pd-ssd" : "pd-standard"
  }
  reclaim_policy         = "Delete"
  allow_volume_expansion = true
  volume_binding_mode    = "WaitForFirstConsumer"

  depends_on = [
    module.gke[0],
    module.gke_private[0]
  ]
}

moved {
  from = kubernetes_storage_class.sn_default
  to   = kubernetes_storage_class.sn_default[0]
}

resource "kubernetes_storage_class" "sn_ssd" {
  count = var.enable_resource_creation ? 1 : 0
  metadata {
    name = "sn-ssd"
    labels = {
      "addonmanager.kubernetes.io/mode" = "EnsureExists"
    }
  }
  storage_provisioner = "pd.csi.storage.gke.io"
  parameters = {
    type = "pd-ssd"
  }
  reclaim_policy         = "Delete"
  allow_volume_expansion = true
  volume_binding_mode    = "WaitForFirstConsumer"

  depends_on = [
    module.gke[0],
    module.gke_private[0]
  ]
}

moved {
  from = kubernetes_storage_class.sn_ssd
  to   = kubernetes_storage_class.sn_ssd[0]
}
