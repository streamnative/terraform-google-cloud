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

variable "create_cluster_subnet" {
  default     = true
  description = "Creates a dedicated subnet for the cluster in the default VPC."
  type        = bool
}

variable "create_service_account" {
  default     = true
  description = "Creates a service account for the cluster. Defaults to \"true\"."
  type        = bool
}

variable "cluster_autoscaling_config" {
  default = {
    enabled       = true
    max_cpu_cores = 10
    min_cpu_cores = 1
    max_memory_gb = 16
    min_memory_gb = 1
    gpu_resources = []
  }
  description = "Cluster autoscaling configuration"
  type = object({
    enabled       = bool
    min_cpu_cores = number
    max_cpu_cores = number
    min_memory_gb = number
    max_memory_gb = number
    gpu_resources = list(object({ resource_type = string, minimum = number, maximum = number }))
  })
}

variable "cluster_location" {
  description = "The GCP location (region) where your cluster will be created. This module only supports regional clusters."
  type        = string
}

variable "cluster_http_load_balancing" {
  default     = true
  description = "Enable the HTTP load balancing addon for the cluster. Defaults to \"true\"."
  type        = bool
}

variable "cluster_name" {
  description = "The name of your GKE cluster."
  type        = string
}

variable "cluster_network_policy" {
  default     = true
  description = "Enable the network policy addon for the cluster. Defaults to \"true\"."
  type        = bool
}

variable "cluster_subnet_cidr" {
  default     = "10.88.0.0/22"
  description = "The primary IPv4 CIDR range to use for the GKE cluster network. Used when the input \"create_cluster_subnet\" is set to \"true\". Defaults to \"10.88.0.0/22\"."
  type        = string
}

variable "cluster_subnet_pods_cidr" {
  default     = "10.24.0.0/14"
  description = "The secondary IPv4 CIDR range used for the GKE cluster pod network. Used when the input \"create_cluster_subnet\" is set to \"true\". Defaults to \"10.24.0.0/14\"."
  type        = string
}

variable "cluster_subnet_services_cidr" {
  default     = "10.88.16.0/20"
  description = "The secondary IPv4 CIDR range used for the GKE cluster service network. Used when the input \"create_cluster_subnet\" is set to \"true\". Defaults to \"10.88.16.0/20\"."
  type        = string
}

variable "enable_function_mesh_operator" {
  default     = true
  description = "Enables the StreamNative Function Mesh Operator on the GKE cluster. Enabled by default, but disabled if var.disable_olm is set to `true`"
  type        = bool
}

variable "enable_function_node_pool" {
  default     = true
  description = "Enable an additional dedicated pool for Pulsar Functions. Enabled by default."
  type        = bool
}

variable "enable_istio_operator" {
  default     = true
  description = "Enables the Istio operator on the GKE cluster. Enabled by default."
  type        = bool
}

variable "enable_prometheus_operator" {
  default     = true
  description = "Enables the Prometheus operator on the GKE cluster. Enabled by default, but disabled if var.disable_olm is set to `true`"
  type        = bool
}

variable "enable_pulsar_operator" {
  default     = true
  description = "Enables the Pulsar Operator on the EKS cluster. Enabled by default, but disabled if var.disable_olm is set to `true`"
  type        = bool
}

variable "enable_vault_operator" {
  default     = true
  description = "Enables Hashicorp Vault on the EKS cluster."
  type        = bool
}

variable "disable_olm" {
  default     = true
  description = "Enables Operator Lifecycle Manager (OLM) on the GKE cluster, and disables installing operators via helm releases. This is currently disabled by default."
  type        = bool
}

variable "func_pool_autoscaling" {
  default     = true
  description = "Enable autoscaling of the Pulsar Functions pool. Defaults to \"true\"."
  type        = bool
}

variable "func_pool_autoscaling_initial_count" {
  default     = 1
  description = "The initial number of nodes in the Pulsar Functions pool when autoscaling is enabled. Defaults to 1."
  type        = number
}

variable "func_pool_autoscaling_min_size" {
  default     = 1
  description = "The minimum size of the Pulsar Functions pool AutoScaling group. Defaults to 1."
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
  default     = false
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
  default     = "COS"
  description = "The image type to use for worker nodes in the Pulsar Functions pool. Defaults to \"COS\" (cointainer-optimized OS with docker)."
  type        = string
}

variable "func_pool_locations" {
  default     = ""
  description = "A string of comma seperated values (upstream requirement) of zones for the Pulsar Functions pool, e.g. \"us-central1-b,us-central1-c\" etc. Nodes must be in the same region as the cluster. Defaults to three random zones in the region specified for the cluster via the \"cluster_location\" input, or the zones provided through the \"node_pool_locations\" input (if it is defined)."
  type        = string
}

variable "func_pool_machine_type" {
  default     = "n1-standard-1"
  description = "The machine type to use for worker nodes in the Pulsar Functions pool. Defaults to \"n1-standard-1\"."
  type        = string
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

variable "function_mesh_operator_chart_name" {
  default     = "function-mesh-operator"
  description = "The name of the Helm chart to install"
  type        = string
}

variable "function_mesh_operator_chart_repository" {
  default     = "https://charts.streamnative.io"
  description = "The repository containing the Helm chart to install"
  type        = string
}

variable "function_mesh_operator_chart_version" {
  default     = "0.1.7"
  description = "The version of the Helm chart to install"
  type        = string
}

variable "function_mesh_operator_cleanup_on_fail" {
  default     = true
  description = "Allow deletion of new resources created in this upgrade when upgrade fails"
  type        = bool
}

variable "function_mesh_operator_release_name" {
  default     = "function-mesh-operator"
  description = "The name of the helm release"
  type        = string
}

variable "function_mesh_operator_settings" {
  default     = null
  description = "Additional settings which will be passed to the Helm chart values"
  type        = map(any)
}

variable "function_mesh_operator_timeout" {
  default     = 600
  description = "Time in seconds to wait for any individual kubernetes operation"
  type        = number
}

variable "horizontal_pod_autoscaling" {
  default     = true
  description = "Enable horizontal pod autoscaling for the cluster. Defaults to \"true\"."
  type        = bool
}

variable "istio_operator_chart_name" {
  default     = "istio-operator"
  description = "The name of the Helm chart to install"
  type        = string
}

variable "istio_operator_chart_repository" {
  default     = "https://kubernetes-charts.banzaicloud.com"
  description = "The repository containing the Helm chart to install"
  type        = string
}

variable "istio_operator_chart_version" {
  default     = "0.0.88"
  description = "The version of the Helm chart to install"
  type        = string
}

variable "istio_operator_cleanup_on_fail" {
  default     = true
  description = "Allow deletion of new resources created in this upgrade when upgrade fails"
  type        = bool
}

variable "istio_operator_release_name" {
  default     = "istio-operator"
  description = "The name of the helm release"
  type        = string
}

variable "istio_operator_settings" {
  default     = null
  description = "Additional settings which will be passed to the Helm chart values"
  type        = map(any)
}

variable "istio_operator_timeout" {
  default     = 600
  description = "Time in seconds to wait for any individual kubernetes operation"
  type        = number
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

variable "maintenance_exclusions" {
  default     = []
  description = "A list of objects used to define exceptions to the maintenance window, when non-emergency maintenance should not occur. Can have up to three exclusions. Refer to the offical Terraform docs on the \"google_container_cluster\" resource for object schema."
  type        = list(object({ name = string, start_time = string, end_time = string }))
}

variable "maintenance_window" {
  default     = "05:00"
  description = "The start time (in RFC3339 format) for the GKE to perform maintenance operations. Defaults to \"05:00\"."
  type        = string
}

variable "manage_pulsar_namespace" {
  default     = true
  description = "Allows Terraform to create and manage Kubernetes namespace used by Pulsar, if it doesn't already exist. Set to \"true\" by default."
  type        = bool
}

variable "node_pool_autoscaling" {
  default     = true
  description = "Enable autoscaling of the default node pool. Defaults to \"true\"."
  type        = bool
}

variable "node_pool_autoscaling_initial_count" {
  default     = 1
  description = "The initial number of nodes per zone in the default node pool when autoscaling is enabled. Defaults to 1."
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
  default     = false
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
  default     = "COS"
  description = "The image type to use for worker nodes in the default node pool. Defaults to \"COS\" (cointainer-optimized OS with docker)."
  type        = string
}

variable "node_pool_locations" {
  default     = ""
  description = "A string of comma seperated values (upstream requirement) of zones for the location of the default node pool, e.g. \"us-central1-b,us-central1-c\" etc. Nodes must be in the region as the cluster. Defaults to three random zones in the region chosen for the cluster."
  type        = string
}

variable "node_pool_machine_type" {
  default     = "n1-standard-1"
  description = "The machine type to use for worker nodes in the default node pool. Defaults to \"n1-standard-1\"."
  type        = string
}

variable "node_pool_name" {
  default     = "default-node-pool"
  description = "The name of the default node pool. Defaults to \"sn-node-pool\"."
  type        = string
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

variable "olm_namespace" {
  default     = "olm"
  description = "The namespace used by OLM and its resources"
  type        = string
}

variable "olm_operators_namespace" {
  default     = "operators"
  description = "The namespace where OLM will install the operators"
  type        = string
}

variable "olm_settings" {
  default     = null
  description = "Additional settings which will be passed to the Helm chart values"
  type        = map(any)
}

variable "olm_sn_image" {
  default     = ""
  description = "The registry containing StreamNative's operator catalog image"
  type        = string
}

variable "olm_subscription_settings" {
  default     = null
  description = "Additional settings which will be passed to the Helm chart values"
  type        = map(any)
}

variable "project_id" {
  description = "The project ID to use for the cluster. Defaults to the current GCP project."
  type        = string
}

variable "prometheus_operator_chart_name" {
  default     = "kube-prometheus-stack"
  description = "The name of the Helm chart to install"
  type        = string
}

variable "prometheus_operator_chart_repository" {
  default     = "https://prometheus-community.github.io/helm-charts"
  description = "The repository containing the Helm chart to install"
  type        = string
}

variable "prometheus_operator_chart_version" {
  default     = "16.12.1"
  description = "The version of the Helm chart to install"
  type        = string
}

variable "prometheus_operator_cleanup_on_fail" {
  default     = true
  description = "Allow deletion of new resources created in this upgrade when upgrade fails"
  type        = bool
}

variable "prometheus_operator_release_name" {
  default     = "kube-prometheus-stack"
  description = "The name of the helm release"
  type        = string
}

variable "prometheus_operator_settings" {
  default     = null
  description = "Additional settings which will be passed to the Helm chart values"
  type        = map(any)
}

variable "prometheus_operator_timeout" {
  default     = 600
  description = "Time in seconds to wait for any individual kubernetes operation"
  type        = number
}

variable "pulsar_namespace" {
  description = "The Kubernetes namespace that will be used for the Pulsar workload. This does not get created automatically, but is needed in order to create the scoped access policies in GCP. Can be enabled by setting the input \"manage_pulsar_namespace\" to \"true\"."
  type        = string
}

variable "pulsar_operator_chart_name" {
  default     = "pulsar-operator"
  description = "The name of the Helm chart to install"
  type        = string
}

variable "pulsar_operator_chart_repository" {
  default     = "https://charts.streamnative.io"
  description = "The repository containing the Helm chart to install"
  type        = string
}

variable "pulsar_operator_chart_version" {
  default     = "0.7.2"
  description = "The version of the Helm chart to install"
  type        = string
}

variable "pulsar_operator_cleanup_on_fail" {
  default     = true
  description = "Allow deletion of new resources created in this upgrade when upgrade fails"
  type        = bool
}

variable "pulsar_operator_release_name" {
  default     = "pulsar-operator"
  description = "The name of the helm release"
  type        = string
}

variable "pulsar_operator_settings" {
  default     = null
  description = "Additional settings which will be passed to the Helm chart values"
  type        = map(any)
}

variable "pulsar_operator_timeout" {
  default     = 600
  description = "Time in seconds to wait for any individual kubernetes operation"
  type        = number
}

variable "remove_default_node_pool" {
  default     = true
  description = "Removes the default node pool from the cluster. Defaults to \"true\"."
  type        = bool
}

variable "release_channel" {
  default     = null
  description = "The Kubernetes release channel to use for the cluster. Accepted values are \"UNSPECIFIED\", \"RAPID\", \"REGULAR\" and \"STABLE\". Defaults to \"UNSPECIFIED\"."
  type        = string
}

variable "vault_operator_chart_name" {
  default     = "vault-operator"
  description = "The name of the Helm chart to install"
  type        = string
}

variable "vault_operator_chart_repository" {
  default     = "https://kubernetes-charts.banzaicloud.com"
  description = "The repository containing the Helm chart to install"
  type        = string
}

variable "vault_operator_chart_version" {
  default     = "1.13.0"
  description = "The version of the Helm chart to install"
  type        = string
}

variable "vault_operator_cleanup_on_fail" {
  default     = true
  description = "Allow deletion of new resources created in this upgrade when upgrade fails"
  type        = bool
}

variable "vault_operator_release_name" {
  default     = "vault-operator"
  description = "The name of the helm release"
  type        = string
}

variable "vault_operator_settings" {
  default     = null
  description = "Additional settings which will be passed to the Helm chart values"
  type        = map(any)
}

variable "vault_operator_timeout" {
  default     = 600
  description = "Time in seconds to wait for any individual kubernetes operation"
  type        = number
}

variable "vault_prefix_override" {
  default     = ""
  description = "Overrides the name prefix for Vault resources"
  type        = string
}

variable "vpc_network" {
  default     = "default"
  description = "The name of the VPC network to use for the cluster. Defaults to the project \"default\" VPC."
  type        = string
}

variable "vpc_subnet" {
  default     = "default"
  description = "The name of the VPC subnetwork to use for the cluster. Defaults to the project \"default\" subnet."
  type        = string
}

