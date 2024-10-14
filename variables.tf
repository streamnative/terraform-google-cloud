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

variable "add_cluster_firewall_rules" {
  default     = false
  description = "Creates additional firewall rules on the cluster."
  type        = bool
}

variable "add_master_webhook_firewall_rules" {
  default     = false
  description = "Create master_webhook firewall rules for ports defined in firewall_inbound_ports."
  type        = bool
}

variable "add_shadow_firewall_rules" {
  default     = false
  description = "Create GKE shadow firewall (the same as default firewall rules with firewall logs enabled)."
  type        = bool
}

variable "authenticator_security_group" {
  default     = null
  description = "The name of the RBAC security group for use with Google security groups in Kubernetes RBAC. Group name must be in format gke-security-groups@yourdomain.com"
  type        = string
}

variable "cert_manager_helm_chart_repository" {
  default     = "https://charts.bitnami.com/bitnami"
  description = "The location of the helm chart to use for Cert Manager."
  type        = string
}

variable "cert_manager_helm_chart_name" {
  default     = "cert-manager"
  description = "The name of the Cert Manager Helm chart to be used."
  type        = string
}

variable "cert_manager_helm_chart_version" {
  default     = "0.7.8"
  description = "The version of the Cert Manager helm chart to install. Defaults to \"0.7.8\"."
  type        = string
}

variable "cert_manager_settings" {
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values. See https://github.com/bitnami/charts/tree/master/bitnami/cert-manager for detailed options."
  type        = map(any)
}

variable "cert_issuer_support_email" {
  default     = "certs-support@streamnative.io"
  description = "The email address to receive notifications from the cert issuer."
  type        = string
}


variable "cluster_autoscaling_config" {
  default = {
    enabled             = false
    max_cpu_cores       = null
    min_cpu_cores       = null
    max_memory_gb       = null
    min_memory_gb       = null
    gpu_resources       = []
    auto_repair         = true
    auto_upgrade        = false
    autoscaling_profile = "BALANCED"
  }
  description = "Cluster autoscaling configuration for node auto-provisioning. This is disabled for our configuration, since we typically want to scale existing node pools rather than add new ones to the cluster"
  type = object({
    enabled             = bool
    min_cpu_cores       = number
    max_cpu_cores       = number
    min_memory_gb       = number
    max_memory_gb       = number
    gpu_resources       = list(object({ resource_type = string, minimum = number, maximum = number }))
    auto_repair         = bool
    auto_upgrade        = bool
    autoscaling_profile = string
  })
}

variable "cluster_http_load_balancing" {
  default     = true
  description = "Enable the HTTP load balancing addon for the cluster. Defaults to \"true\""
  type        = bool
}

variable "cluster_name" {
  description = "The name of your GKE cluster."
  type        = string
}

variable "cluster_network_policy" {
  default     = true
  description = "Enable the network policy addon for the cluster. Defaults to \"true\", and uses CALICO as the provider"
  type        = bool
}

variable "create_service_account" {
  default     = true
  description = "Creates a service account for the cluster. Defaults to \"true\"."
  type        = bool
}

variable "database_encryption_key_name" {
  default     = ""
  description = "Name of the KMS key to encrypt Kubernetes secrets at rest in etcd"
  type        = string
}

variable "datapath_provider" {
  default     = "DATAPATH_PROVIDER_UNSPECIFIED"
  description = "the datapath provider to use, in the future, the default of this should be ADVANCED_DATAPATH"
  type        = string

}
variable "default_max_pods_per_node" {
  description = "the number of pods per node, defaults to GKE default of 110, but in smaller CIDRs we want to tune this"
  type        = number
  default     = 110
}

variable "enable_cert_manager" {
  default     = true
  description = "Enables the Cert-Manager addon service on the cluster. Defaults to \"true\", and in most situations is required by StreamNative Cloud."
  type        = bool
}

variable "enable_database_encryption" {
  default     = false
  description = "Enables etcd encryption via Google KMS."
  type        = bool
}

variable "enable_external_dns" {
  default     = true
  description = "Enables the External DNS addon service on the cluster. Defaults to \"true\", and in most situations is required by StreamNative Cloud."
  type        = bool
}

variable "enable_external_secrets" {
  default     = true
  description = "Enables kubernetes-external-secrets on the cluster, which uses GCP Secret Manager as the secrets backend"
  type        = bool
}

variable "enable_func_pool" {
  default     = true
  description = "Enable an additional dedicated pool for Pulsar Functions. Enabled by default."
  type        = bool
}

variable "enable_istio" {
  default     = false
  description = "Enables Istio on the cluster. Set to \"false\" by default."
  type        = bool
}


variable "enable_private_gke" {
  default     = false
  description = "Enables private GKE cluster, where nodes are not publicly accessible. Defaults to \"false\"."
  type        = bool
}
variable "enable_resource_creation" {
  default     = true
  description = "When enabled, all dependencies, like service accounts, buckets, etc will be created. When disabled, they will note. Use in combination with `enable_<app>` to manage these outside this module"
  type        = bool
}

variable "external_dns_helm_chart_name" {
  default     = "external-dns"
  description = "The name of the Helm chart in the repository for ExternalDNS."
  type        = string
}

variable "external_dns_helm_chart_repository" {
  default     = "https://charts.bitnami.com/bitnami"
  description = "The repository containing the ExternalDNS helm chart."
  type        = string
}

variable "external_dns_helm_chart_version" {
  default     = "6.15.0"
  description = "Helm chart version for ExternalDNS. See https://github.com/bitnami/charts/tree/master/bitnami/external-dns for updates."
  type        = string
}

variable "external_dns_policy" {
  default     = "upsert-only"
  description = "Sets how DNS records are managed by ExternalDNS. Options are \"sync\", which allows ExternalDNS to create and delete records, or \"upsert_only\", which only allows for the creation of records"
  type        = string
}

variable "external_dns_settings" {
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values, see https://github.com/bitnami/charts/tree/master/bitnami/external-dns for detailed options."
  type        = map(any)
}

variable "external_dns_version" {
  default     = "5.2.2"
  description = "The version of the ExternalDNS helm chart to install. Defaults to \"5.2.2\"."
  type        = string
}

variable "external_secrets_helm_chart_name" {
  default     = "kubernetes-external-secrets"
  description = "The name of the Helm chart in the repository for kubernetes-external-secrets"
  type        = string
}

variable "external_secrets_helm_chart_repository" {
  default     = "https://external-secrets.github.io/kubernetes-external-secrets"
  description = "The repository containing the kubernetes-external-secrets helm chart"
  type        = string
}

variable "external_secrets_helm_chart_version" {
  default     = "8.3.0"
  description = "Helm chart version for kubernetes-external-secrets. Defaults to \"8.3.0\". See https://github.com/external-secrets/kubernetes-external-secrets/tree/master/charts/kubernetes-external-secrets for updates"
  type        = string
}

variable "external_secrets_settings" {
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values, see https://github.com/external-secrets/kubernetes-external-secrets/tree/master/charts/kubernetes-external-secrets for available options"
  type        = map(any)
}

variable "firewall_inbound_ports" {
  type        = list(string)
  description = "List of TCP ports for admission/webhook controllers. Either flag `add_master_webhook_firewall_rules` or `add_cluster_firewall_rules` (also adds egress rules) must be set to `true` for inbound-ports firewall rules to be applied."
  // we add 5443 for OLM
  default = ["5443", "8443", "9443", "15017"]
}

variable "func_pool_autoscaling" {
  default     = true
  description = "Enable autoscaling of the Pulsar Functions pool. Defaults to \"true\"."
  type        = bool
}

variable "func_pool_autoscaling_initial_count" {
  default     = 0
  description = "The initial number of nodes in the Pulsar Functions pool, per zone, when autoscaling is enabled. Defaults to 0."
  type        = number
}

variable "func_pool_autoscaling_min_size" {
  default     = 0
  description = "The minimum size of the Pulsar Functions pool AutoScaling group. Defaults to 0."
  type        = number
}

variable "func_pool_autoscaling_max_size" {
  default     = 3
  description = "The maximum size of the Pulsar Functions pool Autoscaling group. Defaults to 3."
  type        = number
}

variable "func_pool_auto_repair" {
  default     = true
  description = "Enable auto-repair for the Pulsar Functions pool."
  type        = bool
}

variable "func_pool_auto_upgrade" {
  default     = true
  description = "Enable auto-upgrade for the Pulsar Functions pool."
  type        = bool
}

variable "func_pool_count" {
  default     = 1
  description = "The number of worker nodes in the Pulsar Functions pool. This is only used if func_pool_autoscaling is set to false. Defaults to 1."
  type        = number
}

variable "func_pool_disk_size" {
  default     = 100
  description = "Disk size in GB for worker nodes in the Pulsar Functions pool. Defaults to 100."
  type        = number
}

variable "func_pool_disk_type" {
  default     = "pd-standard"
  description = "The type disk attached to worker nodes in the Pulsar Functions pool. Defaults to \"pd-standard\"."
  type        = string
}


variable "func_pool_image_type" {
  default     = "COS_CONTAINERD"
  description = "The image type to use for worker nodes in the Pulsar Functions pool. Defaults to \"COS\" (cointainer-optimized OS with docker)."
  type        = string
}

variable "func_pool_locations" {
  default     = ""
  description = "A string of comma seperated values (upstream requirement) of zones for the Pulsar Functions pool, e.g. \"us-central1-b,us-central1-c\" etc. Nodes must be in the same region as the cluster. Defaults to three random zones in the region specified for the cluster via the \"cluster_location\" input, or the zones provided through the \"node_pool_locations\" input (if it is defined)."
  type        = string
}

variable "func_pool_machine_type" {
  default     = "n2-standard-4"
  description = "The machine type to use for worker nodes in the Pulsar Functions pool. Defaults to \"n2-standard-4\"."
  type        = string
}

variable "func_pool_max_pods_per_node" {
  description = "the number of pods per node"
  type        = number
  default     = 110
}

variable "func_pool_name" {
  default     = "func-pool"
  description = "The name of the Pulsar Functions pool. Defaults to \"default-node-pool\"."
  type        = string
}

variable "func_pool_service_account" {
  default     = ""
  description = "The service account email address to use for the Pulsar Functions pool. If create_service_account is set to true, it will use the the output from the module."
  type        = string
}

variable "func_pool_ssd_count" {
  default     = 0
  description = "The number of SSDs to attach to each node in the Pulsar Functions pool. Defaults to 0."
  type        = number
}

variable "func_pool_version" {
  default     = ""
  description = "The version of Kubernetes to use for the Pulsar Functions pool. If the input \"release_channel\" is not defined, defaults to \"kubernetes_version\" used for the cluster. Should only be defined while \"func_pool_auto_upgrade\" is also set to \"false\"."
  type        = string
}

variable "google_service_account" {
  default     = ""
  description = "when set, don't create GSAs and instead use the this service account for all apps"
  type        = string
}

variable "horizontal_pod_autoscaling" {
  default     = true
  description = "Enable horizontal pod autoscaling for the cluster. Defaults to \"true\"."
  type        = bool
}

variable "istio_mesh_id" {
  default     = null
  description = "The ID used by the Istio mesh. This is also the ID of the StreamNative Cloud Pool used for the workload environments. This is required when \"enable_istio_operator\" is set to \"true\"."
  type        = string
}

variable "istio_network" {
  default     = "default"
  description = "The name of network used for the Istio deployment. This is required when \"enable_istio_operator\" is set to \"true\"."
  type        = string
}

variable "istio_profile" {
  default     = "default"
  description = "The path or name for an Istio profile to load. Set to the profile \"default\" if not specified."
  type        = string
}

variable "istio_revision_tag" {
  default     = "sn-stable"
  description = "The revision tag value use for the Istio label \"istio.io/rev\"."
  type        = string
}

variable "istio_trust_domain" {
  default     = "cluster.local"
  description = "The trust domain used for the Istio deployment, which corresponds to the root of a system. This is required when \"enable_istio_operator\" is set to \"true\"."
  type        = string
}

variable "istio_settings" {
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values"
  type        = map(any)
}

variable "istio_chart_version" {
  default     = "2.11"
  description = "The version of the istio chart to use"
  type        = string
}

variable "kiali_operator_settings" {
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values"
  type        = map(any)
}

variable "kubernetes_version" {
  default     = "latest"
  description = "The version of Kubernetes to use for the cluster. Defaults to \"latest\", which uses the latest available version for GKE in the region specified."
  type        = string
}

variable "logging_service" {
  default     = "logging.googleapis.com/kubernetes"
  description = "The logging service to use for the cluster. Defaults to \"logging.googleapis.com/kubernetes\"."
  type        = string
}

variable "logging_enabled_components" {
  type        = list(string)
  description = "List of services to monitor: SYSTEM_COMPONENTS, APISERVER, CONTROLLER_MANAGER, SCHEDULER, WORKLOADS. Empty list is default GKE configuration."
  default     = []
}

variable "monitoring_enabled_components" {
  type        = list(string)
  description = "List of services to monitor: SYSTEM_COMPONENTS, APISERVER, CONTROLLER_MANAGER, SCHEDULER. Empty list is default GKE configuration."
  default     = []
}

variable "maintenance_exclusions" {
  default     = []
  description = "A list of objects used to define exceptions to the maintenance window, when non-emergency maintenance should not occur. Can have up to three exclusions. Refer to the offical Terraform docs on the \"google_container_cluster\" resource for object schema."
  type        = list(object({ name = string, start_time = string, end_time = string, exclusion_scope = string }))
}

variable "maintenance_window" {
  default     = "05:00"
  description = "The start time (in RFC3339 format) for the GKE to perform maintenance operations. Defaults to \"05:00\"."
  type        = string
}

variable "master_authorized_networks" {
  default     = []
  description = "A list of objects used to define authorized networks. If none are provided, the default is to disallow external access. See the parent module for more details. https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/latest"
  type        = list(object({ cidr_block = string, display_name = string }))
}

variable "node_pool_autoscaling" {
  default     = true
  description = "Enable autoscaling of the default node pool. Defaults to \"true\"."
  type        = bool
}

variable "node_pool_autoscaling_initial_count" {
  default     = 1
  description = "The initial number of nodes per zone in the default node pool, PER ZONE, when autoscaling is enabled. Defaults to 1."
  type        = number
}

variable "node_pool_autoscaling_min_size" {
  default     = 1
  description = "The minimum size of the default node pool AutoScaling group. Defaults to 1."
  type        = number
}

variable "node_pool_autoscaling_max_size" {
  default     = 5
  description = "The maximum size of the default node pool Autoscaling group. Defaults to 5."
  type        = number
}

variable "node_pool_auto_repair" {
  default     = true
  description = "Enable auto-repair for the default node pool."
  type        = bool
}

variable "node_pool_auto_upgrade" {
  default     = true
  description = "Enable auto-upgrade for the default node pool."
  type        = bool
}

variable "node_pool_count" {
  default     = 3
  description = "The number of worker nodes in the default node pool. This is only used if node_pool_autoscaling is set to false. Defaults to 3."
  type        = number
}

variable "node_pool_disk_size" {
  default     = 100
  description = "Disk size in GB for worker nodes in the default node pool. Defaults to 100."
  type        = number
}

variable "node_pool_disk_type" {
  default     = "pd-standard"
  description = "The type disk attached to worker nodes in the default node pool. Defaults to \"pd-standard\"."
  type        = string
}

variable "node_pool_image_type" {
  default     = "COS_CONTAINERD"
  description = "The image type to use for worker nodes in the default node pool. Defaults to \"COS\" (cointainer-optimized OS with docker)."
  type        = string
}

variable "node_pool_locations" {
  default     = ""
  description = "A string of comma seperated values (upstream requirement) of zones for the location of the default node pool, e.g. \"us-central1-b,us-central1-c\" etc. Nodes must be in the region as the cluster. Defaults to three random zones in the region chosen for the cluster"
  type        = string
}

variable "node_pool_machine_type" {
  default     = "n2-standard-8"
  description = "The machine type to use for worker nodes in the default node pool. Defaults to \"n2-standard-8\"."
  type        = string
}

variable "node_pool_max_pods_per_node" {
  description = "the number of pods per node"
  type        = number
  default     = 110
}

variable "node_pool_name" {
  default     = "default-node-pool"
  description = "The name of the default node pool. Defaults to \"sn-node-pool\"."
  type        = string
}

variable "node_pool_secure_boot" {
  default     = false
  description = "enable the node pool secure boot setting"
  type        = bool
}

variable "node_pool_service_account" {
  default     = ""
  description = "The service account email address to use for the default node pool. If create_service_account is set to true, it will use the the output from the module."
  type        = string
}

variable "node_pool_ssd_count" {
  default     = 0
  description = "The number of SSDs to attach to each node in the default node pool"
  type        = number
}

variable "node_pool_version" {
  default     = ""
  description = "The version of Kubernetes to use for the default node pool. If the input \"release_channel\" is not defined, defaults to \"kubernetes_version\" used for the cluster. Should only be defined while \"node_pool_auto_upgrade\" is also set to \"false\"."
  type        = string
}

variable "project_id" {
  description = "The project ID to use for the cluster. Defaults to the current GCP project."
  type        = string
}

variable "release_channel" {
  default     = "STABLE"
  description = "The Kubernetes release channel to use for the cluster. Accepted values are \"UNSPECIFIED\", \"RAPID\", \"REGULAR\" and \"STABLE\". Defaults to \"UNSPECIFIED\"."
  type        = string
}

variable "region" {
  description = "The GCP region where the GKE cluster will be deployed. This module only supports creation of a regional cluster"
  type        = string
}

variable "secondary_ip_range_pods" {
  default     = null
  description = "The name of the secondary range to use for the pods in the cluster. If no secondary range for the pod network is provided, GKE will create a /14 CIDR within the subnetwork provided by the \"vpc_subnet\" input"
  type        = string
}

variable "secondary_ip_range_pods_cidr" {
  default     = null
  description = "The cidr of the secondary range, required when using cillium"
  type        = string
}

variable "secondary_ip_range_services" {
  default     = null
  description = "The name of the secondary range to use for services in the cluster. If no secondary range for the services network is provided, GKE will create a /20 CIDR within the subnetwork provided by the \"vpc_subnet\" input"
  type        = string
}

variable "service_domain" {
  default     = null
  description = "The DNS domain for external service endpoints. This must be set when enabling Istio or else the deployment will fail."
  type        = string
}

variable "suffix" {
  default     = ""
  description = "A unique string that is used to distinguish cluster resources, where name length constraints are imposed by GKE. Defaults to an empty string."
  type        = string
  validation {
    condition     = length(var.suffix) < 12
    error_message = "Suffix must be less than 12 characters."
  }
}

variable "storage_class_default_ssd" {
  default     = false
  description = "determines if the default storage class should be with ssd"
  type        = bool
}

variable "vpc_subnet" {
  description = "The name of the VPC subnetwork to use by the cluster nodes. Can be set to \"default\" if the default VPC is enabled in the project, and GKE will choose the subnetwork based on the \"region\" input"
  type        = string
}

variable "vpc_network" {
  description = "The name of the VPC network to use for the cluster. Can be set to \"default\" if the default VPC is enabled in the project"
  type        = string
}

variable "network_project_id" {
  default     = ""
  description = "If using a different project, the id of the project"
  type        = string
}

variable "istio_network_loadbalancer" {
  type    = string
  default = "internet_facing"

  validation {
    condition     = contains(["internet_facing", "internal_only"], var.istio_network_loadbalancer)
    error_message = "Allowed values for input_parameter are \"internet_facing\" or \"internal_only\"."
  }
}

variable "enable_private_nodes" {
  type        = bool
  description = "Whether nodes have internal IP addresses only, only used for private clusters"
  default     = true
}

variable "master_ipv4_cidr_block" {
  type        = string
  description = "The IP range in CIDR notation to use for the hosted master network. Only used for private clusters"
  default     = "10.0.0.0/28"
}

variable "deletion_protection" {
  type        = bool
  description = "Whether or not to allow Terraform to destroy the cluster."
  default     = true
}
