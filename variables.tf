variable "add_cluster_firewall_rules" {
  default     = false
  description = "Creates additional firewall rules on the cluster"
  type        = bool
}

variable "add_master_webhook_firewall_rules" {
  default     = false
  description = "Create master_webhook firewall rules for ports defined in firewall_inbound_ports"
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
  description = "The name of your GKE cluster"
  type        = string
}

variable "cluster_network_policy" {
  default = true
  description = "Enable the network policy addon for the cluster. Defaults to \"true\"."
  type        = bool 
}

variable "cluster_subnet_cidr" {
  default     = "10.88.0.0/22"
  description = "The IPv4 CIDR range to use for the cluster subnet. Required when create_cluster_subnet are set to \"true\", and only eligable when using the default VPC."
  type        = string
}

variable "cluster_subnet_pods_cidr" {
  default     = "10.24.0.0/14"
  description = "The secondary IP range for the subnet, used for the pod network. Required when *both* use_default_vpc and create_cluster_subnet are set to \"true\""
  type        = string
}

variable "cluster_subnet_services_cidr" {
  default     = "10.88.16.0/20"
  description = "The secondary IP range for the subnet, used for the service network. Required when *both* use_default_vpc and create_cluster_subnet are set to \"true\"."
  type        = string
}

variable "func_pool_autoscaling" {
  default        = true
  description = "Enable autoscaling of the Pulsar Functions pool. Defaults to \"true\"."
  type           = bool
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
  description = "Enable auto-repair for the Pulsar Functions pool"
  type        = bool
}

variable "func_pool_auto_upgrade" {
  default     = false
  description = "Enable auto-upgrade for the Pulsar Functions pool"
  type        = bool
}

variable "func_pool_disk_size" {
  default     = 100
  description = "Disk size in GB for worker nodes in the Pulsar Functions pool. Defaults to 100"
  type        = number
}

variable "func_pool_disk_type" {
  default     = "pd-standard"
  description = "The type disk attached to worker nodes in the Pulsar Functions pool. Defaults to \"pd-standard\"."
  type        = string
}

variable "func_pool_count" {
  default     = 1
  description = "The number of worker nodes in the Pulsar Functions pool. This is only used if func_pool_autoscaling is set to false. Defaults to 1."
  type        = number
}

variable "func_pool_enabled" {
  default     = true
  description = "Enable an additional dedicated pool for Pulsar Functions"
  type        = bool
}

variable "func_pool_image_type" {
  default     = "COS"
  description = "The image type to use for worker nodes in the Pulsar Functions pool. Defaults to \"COS\" (cointainer-optimized OS with docker)."
  type        = string
}

variable "func_pool_locations" {
  default     = "" 
  description = "A string of comma seperated values (upstream requirement) of zones for the Pulsar Functions pool, e.g. \"us-central1-b,us-central1-c\" etc. Nodes must be in the region as the cluster"
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
  description = "The service account email address to use for the Pulsar Functions pool. If create_service_account is set to true, it will use the the output from the module"
  type        = string
}

variable "func_pool_ssd_count" {
  default     = 0
  description = "The number of SSDs to attach to each node in the Pulsar Functions pool"
  type        = number
}

variable "func_pool_version" {
  default        = ""
  description = "The version of Kubernetes to use for the Pulsar Functions pool. Defaults to \"\" (use the latest version)."
  type           = string
}

variable "horizontal_pod_autoscaling" {
  default = true
  description = "Enable horizontal pod autoscaling for the cluster. Defaults to \"true\"."
  type = bool
}

variable "kubernetes_version" {
  default = "1.19.9-gke.1900"
  description = "The version of Kubernetes to use for the cluster. Defaults to \"1.19\"."
  type = string
}

variable "node_pool_autoscaling" {
  default        = true
  description = "Enable autoscaling of the default node pool. Defaults to \"true\"."
  type           = bool
}

variable "node_pool_autoscaling_initial_count" {
  default     = 3
  description = "The initial number of nodes in the default node pool when autoscaling is enabled. Defaults to 3."
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
  description = "Enable auto-repair for the default node pool"
  type        = bool
}

variable "node_pool_auto_upgrade" {
  default     = false
  description = "Enable auto-upgrade for the default node pool"
  type        = bool
}

variable "node_pool_count" {
  default     = 3
  description = "The number of worker nodes in the default node pool. This is only used if node_pool_autoscaling is set to false. Defaults to 3."
  type        = number
}

variable "node_pool_disk_size" {
  default     = 100
  description = "Disk size in GB for worker nodes in the default node pool. Defaults to 100"
  type        = number
}

variable "node_pool_disk_type" {
  default     = "pd-standard"
  description = "The type disk attached to worker nodes in the default node pool. Defaults to \"pd-standard\"."
  type        = string
}

variable "node_pool_image_type" {
  default     = "COS"
  description = "The image type to use for worker nodes in the default node pool. Defaults to \"COS\" (cointainer-optimized OS with docker). "
  type        = string
}

variable "node_pool_locations" {
  default     = ""
  description = "A string of comma seperated values (upstream requirement) of zones for the location of the default node pool, e.g. \"us-central1-b,us-central1-c\" etc. Nodes must be in the region as the cluster"
  type        = string
}

variable "node_pool_machine_type" {
  default     = "n1-standard-1"
  description = "The machine type to use for worker nodes in the default node pool. Defaults to \"n1-standard-1\"."
  type        = string
}

variable "node_pool_name" {
  default     = "default-node-pool"
  description = "The name of the default node pool. Defaults to \"default-node-pool\"."
  type        = string
}

variable "node_pool_service_account" {
  default     = ""
  description = "The service account email address to use for the default node pool. If create_service_account is set to true, it will use the the output from the module"
  type        = string
}

variable "node_pool_ssd_count" {
  default     = 0
  description = "The number of SSDs to attach to each node in the default node pool"
  type        = number
}

variable "node_pool_version" {
  default     = ""
  description = "The version of Kubernetes to use for the default node pool. Defaults to \"\" (use the latest version)."
  type        = string
}

variable "project_id" {
  description = "The project ID to use for the cluster. Defaults to the current GCP project."
  type        = string
}

variable "remove_default_node_pool" {
  default     = true
  description = "Removes the default node pool from the cluster. Defaults to \"true\"."
  type        = bool
}

variable "release_channel" {
  default     = "STABLE"
  description = "The Kubernetes release channel to use for the cluster. Defaults to \"STABLE\"."
  type        = string
}

variable "vpc_network" {
  default     = "default"
  description = "The VPC network to use for the cluster. Defaults to the project \"default\" VPC." 
  type        = string
}

variable "vpc_subnet" {
  default     = "default"
  description = "The VPC subnetwork to use for the cluster. Defaults to the project \"default\" subnet." 
  type        = string
}

