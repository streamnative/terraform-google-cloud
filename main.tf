#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  name    = var.cluster_name
  version = "16.1.0"

  add_cluster_firewall_rules        = var.add_cluster_firewall_rules
  add_master_webhook_firewall_rules = var.add_master_webhook_firewall_rules
  add_shadow_firewall_rules         = var.add_shadow_firewall_rules
  cluster_autoscaling               = var.cluster_autoscaling_config
  http_load_balancing               = var.cluster_http_load_balancing
  ip_range_pods                     = var.secondary_ip_range_pods
  ip_range_services                 = var.secondary_ip_range_services
  kubernetes_version                = var.kubernetes_version
  logging_service                   = var.logging_service
  maintenance_exclusions            = var.maintenance_exclusions
  maintenance_start_time            = var.maintenance_window
  master_authorized_networks        = var.master_authorized_networks
  network                           = var.vpc_network
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
}

resource "kubernetes_namespace" "sn_system" {
  count = var.create_sn_system_namespace ? 1 : 0
  metadata {
    name = "sn-system"
  }
  depends_on = [
    module.gke
  ]
}
