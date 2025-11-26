<!--
  Copyright 2023 StreamNative, Inc.
  
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
  
      http://www.apache.org/licenses/LICENSE-2.0
  
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->

# terraform-google-cloud

An example configuration is found in [examples/root_example/main.tf](./examples/root_example/main.tf).

Assuming you have the GCloud CLI installed and configured, to the example, run

```
tf apply --target module.sn_cluster
tf apply
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.3.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 5.40.0, < 7 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.10 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 5.45.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.35.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gke"></a> [gke](#module\_gke) | terraform-google-modules/kubernetes-engine/google | 35.0.1 |
| <a name="module_gke_private"></a> [gke\_private](#module\_gke\_private) | terraform-google-modules/kubernetes-engine/google//modules/private-cluster | 35.0.1 |

## Resources

| Name | Type |
|------|------|
| [google_kms_crypto_key.gke_encryption_key](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/kms_crypto_key) | resource |
| [google_kms_key_ring.keyring](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/kms_key_ring) | resource |
| [google_project_iam_member.kms_iam_binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [kubernetes_namespace.sn_system](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_storage_class.sn_default](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/storage_class) | resource |
| [kubernetes_storage_class.sn_ssd](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/storage_class) | resource |
| [google_compute_zones.available](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_zones) | data source |
| [google_project.project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_add_cluster_firewall_rules"></a> [add\_cluster\_firewall\_rules](#input\_add\_cluster\_firewall\_rules) | Creates additional firewall rules on the cluster. | `bool` | `false` | no |
| <a name="input_add_master_webhook_firewall_rules"></a> [add\_master\_webhook\_firewall\_rules](#input\_add\_master\_webhook\_firewall\_rules) | Create master\_webhook firewall rules for ports defined in firewall\_inbound\_ports. | `bool` | `false` | no |
| <a name="input_add_shadow_firewall_rules"></a> [add\_shadow\_firewall\_rules](#input\_add\_shadow\_firewall\_rules) | Create GKE shadow firewall (the same as default firewall rules with firewall logs enabled). | `bool` | `false` | no |
| <a name="input_additive_vpc_scope_dns_domain"></a> [additive\_vpc\_scope\_dns\_domain](#input\_additive\_vpc\_scope\_dns\_domain) | This will enable Cloud DNS additive VPC scope. Must provide a domain name that is unique within the VPC. For this to work cluster\_dns = `CLOUD_DNS` and cluster\_dns\_scope = `CLUSTER_SCOPE` must both be set as well. | `string` | `""` | no |
| <a name="input_authenticator_security_group"></a> [authenticator\_security\_group](#input\_authenticator\_security\_group) | The name of the RBAC security group for use with Google security groups in Kubernetes RBAC. Group name must be in format gke-security-groups@yourdomain.com | `string` | `null` | no |
| <a name="input_cluster_autoscaling_config"></a> [cluster\_autoscaling\_config](#input\_cluster\_autoscaling\_config) | Cluster autoscaling configuration for node auto-provisioning. This is disabled for our configuration, since we typically want to scale existing node pools rather than add new ones to the cluster | <pre>object({<br>    enabled             = bool<br>    min_cpu_cores       = number<br>    max_cpu_cores       = number<br>    min_memory_gb       = number<br>    max_memory_gb       = number<br>    gpu_resources       = list(object({ resource_type = string, minimum = number, maximum = number }))<br>    auto_repair         = bool<br>    auto_upgrade        = bool<br>    autoscaling_profile = string<br>  })</pre> | <pre>{<br>  "auto_repair": true,<br>  "auto_upgrade": false,<br>  "autoscaling_profile": "BALANCED",<br>  "enabled": false,<br>  "gpu_resources": [],<br>  "max_cpu_cores": null,<br>  "max_memory_gb": null,<br>  "min_cpu_cores": null,<br>  "min_memory_gb": null<br>}</pre> | no |
| <a name="input_cluster_dns_domain"></a> [cluster\_dns\_domain](#input\_cluster\_dns\_domain) | The suffix used for all cluster service records. | `string` | `""` | no |
| <a name="input_cluster_dns_provider"></a> [cluster\_dns\_provider](#input\_cluster\_dns\_provider) | Which in-cluster DNS provider should be used. PROVIDER\_UNSPECIFIED (default) or PLATFORM\_DEFAULT or CLOUD\_DNS. | `string` | `"PROVIDER_UNSPECIFIED"` | no |
| <a name="input_cluster_dns_scope"></a> [cluster\_dns\_scope](#input\_cluster\_dns\_scope) | The scope of access to cluster DNS records. DNS\_SCOPE\_UNSPECIFIED (default) or CLUSTER\_SCOPE or VPC\_SCOPE. | `string` | `"DNS_SCOPE_UNSPECIFIED"` | no |
| <a name="input_cluster_http_load_balancing"></a> [cluster\_http\_load\_balancing](#input\_cluster\_http\_load\_balancing) | Enable the HTTP load balancing addon for the cluster. Defaults to "true" | `bool` | `true` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of your GKE cluster. | `string` | n/a | yes |
| <a name="input_cluster_network_policy"></a> [cluster\_network\_policy](#input\_cluster\_network\_policy) | Enable the network policy addon for the cluster. Defaults to "true", and uses CALICO as the provider | `bool` | `true` | no |
| <a name="input_create_service_account"></a> [create\_service\_account](#input\_create\_service\_account) | Creates a service account for the cluster. Defaults to "true". | `bool` | `true` | no |
| <a name="input_database_encryption_key_name"></a> [database\_encryption\_key\_name](#input\_database\_encryption\_key\_name) | Name of the KMS key to encrypt Kubernetes secrets at rest in etcd | `string` | `""` | no |
| <a name="input_datapath_provider"></a> [datapath\_provider](#input\_datapath\_provider) | the datapath provider to use, in the future, the default of this should be ADVANCED\_DATAPATH | `string` | `"DATAPATH_PROVIDER_UNSPECIFIED"` | no |
| <a name="input_default_max_pods_per_node"></a> [default\_max\_pods\_per\_node](#input\_default\_max\_pods\_per\_node) | the number of pods per node, defaults to GKE default of 110, but in smaller CIDRs we want to tune this | `number` | `110` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Whether or not to allow Terraform to destroy the cluster. | `bool` | `true` | no |
| <a name="input_enable_database_encryption"></a> [enable\_database\_encryption](#input\_enable\_database\_encryption) | Enables etcd encryption via Google KMS. | `bool` | `false` | no |
| <a name="input_enable_func_pool"></a> [enable\_func\_pool](#input\_enable\_func\_pool) | Enable an additional dedicated pool for Pulsar Functions. Enabled by default. | `bool` | `true` | no |
| <a name="input_enable_l4_ilb_subsetting"></a> [enable\_l4\_ilb\_subsetting](#input\_enable\_l4\_ilb\_subsetting) | Enable L4 ILB Subsetting on the cluster, this cannot be disabled once it has been enabled. | `bool` | `false` | no |
| <a name="input_enable_private_endpoint"></a> [enable\_private\_endpoint](#input\_enable\_private\_endpoint) | Enables private endpoint for GKE master. Defaults to "false". | `bool` | `false` | no |
| <a name="input_enable_private_gke"></a> [enable\_private\_gke](#input\_enable\_private\_gke) | Enables private GKE cluster, where nodes are not publicly accessible. Defaults to "false". | `bool` | `false` | no |
| <a name="input_enable_private_nodes"></a> [enable\_private\_nodes](#input\_enable\_private\_nodes) | Whether nodes have internal IP addresses only. | `bool` | `false` | no |
| <a name="input_enable_resource_creation"></a> [enable\_resource\_creation](#input\_enable\_resource\_creation) | When enabled, all dependencies, like service accounts, buckets, etc will be created. When disabled, they will note. Use in combination with `enable_<app>` to manage these outside this module | `bool` | `true` | no |
| <a name="input_firewall_inbound_ports"></a> [firewall\_inbound\_ports](#input\_firewall\_inbound\_ports) | List of TCP ports for admission/webhook controllers. Either flag `add_master_webhook_firewall_rules` or `add_cluster_firewall_rules` (also adds egress rules) must be set to `true` for inbound-ports firewall rules to be applied. | `list(string)` | <pre>[<br>  "5443",<br>  "8443",<br>  "9443",<br>  "15017"<br>]</pre> | no |
| <a name="input_fleet_project"></a> [fleet\_project](#input\_fleet\_project) | The Fleet project to register the GKE cluster to. If not set, the GKE cluster's project will be used. | `string` | `null` | no |
| <a name="input_func_pool_auto_repair"></a> [func\_pool\_auto\_repair](#input\_func\_pool\_auto\_repair) | Enable auto-repair for the Pulsar Functions pool. | `bool` | `true` | no |
| <a name="input_func_pool_auto_upgrade"></a> [func\_pool\_auto\_upgrade](#input\_func\_pool\_auto\_upgrade) | Enable auto-upgrade for the Pulsar Functions pool. | `bool` | `true` | no |
| <a name="input_func_pool_autoscaling"></a> [func\_pool\_autoscaling](#input\_func\_pool\_autoscaling) | Enable autoscaling of the Pulsar Functions pool. Defaults to "true". | `bool` | `true` | no |
| <a name="input_func_pool_autoscaling_initial_count"></a> [func\_pool\_autoscaling\_initial\_count](#input\_func\_pool\_autoscaling\_initial\_count) | The initial number of nodes in the Pulsar Functions pool, per zone, when autoscaling is enabled. Defaults to 0. | `number` | `0` | no |
| <a name="input_func_pool_autoscaling_max_size"></a> [func\_pool\_autoscaling\_max\_size](#input\_func\_pool\_autoscaling\_max\_size) | The maximum size of the Pulsar Functions pool Autoscaling group. Defaults to 3. | `number` | `3` | no |
| <a name="input_func_pool_autoscaling_min_size"></a> [func\_pool\_autoscaling\_min\_size](#input\_func\_pool\_autoscaling\_min\_size) | The minimum size of the Pulsar Functions pool AutoScaling group. Defaults to 0. | `number` | `0` | no |
| <a name="input_func_pool_count"></a> [func\_pool\_count](#input\_func\_pool\_count) | The number of worker nodes in the Pulsar Functions pool. This is only used if func\_pool\_autoscaling is set to false. Defaults to 1. | `number` | `1` | no |
| <a name="input_func_pool_disk_size"></a> [func\_pool\_disk\_size](#input\_func\_pool\_disk\_size) | Disk size in GB for worker nodes in the Pulsar Functions pool. Defaults to 100. | `number` | `100` | no |
| <a name="input_func_pool_disk_type"></a> [func\_pool\_disk\_type](#input\_func\_pool\_disk\_type) | The type disk attached to worker nodes in the Pulsar Functions pool. Defaults to "pd-standard". | `string` | `"pd-standard"` | no |
| <a name="input_func_pool_image_type"></a> [func\_pool\_image\_type](#input\_func\_pool\_image\_type) | The image type to use for worker nodes in the Pulsar Functions pool. Defaults to "COS" (cointainer-optimized OS with docker). | `string` | `"COS_CONTAINERD"` | no |
| <a name="input_func_pool_locations"></a> [func\_pool\_locations](#input\_func\_pool\_locations) | A string of comma seperated values (upstream requirement) of zones for the Pulsar Functions pool, e.g. "us-central1-b,us-central1-c" etc. Nodes must be in the same region as the cluster. Defaults to three random zones in the region specified for the cluster via the "cluster\_location" input, or the zones provided through the "node\_pool\_locations" input (if it is defined). | `string` | `""` | no |
| <a name="input_func_pool_machine_type"></a> [func\_pool\_machine\_type](#input\_func\_pool\_machine\_type) | The machine type to use for worker nodes in the Pulsar Functions pool. Defaults to "n2-standard-4". | `string` | `"n2-standard-4"` | no |
| <a name="input_func_pool_max_pods_per_node"></a> [func\_pool\_max\_pods\_per\_node](#input\_func\_pool\_max\_pods\_per\_node) | the number of pods per node | `number` | `110` | no |
| <a name="input_func_pool_name"></a> [func\_pool\_name](#input\_func\_pool\_name) | The name of the Pulsar Functions pool. Defaults to "default-node-pool". | `string` | `"func-pool"` | no |
| <a name="input_func_pool_service_account"></a> [func\_pool\_service\_account](#input\_func\_pool\_service\_account) | The service account email address to use for the Pulsar Functions pool. If create\_service\_account is set to true, it will use the the output from the module. | `string` | `""` | no |
| <a name="input_func_pool_ssd_count"></a> [func\_pool\_ssd\_count](#input\_func\_pool\_ssd\_count) | The number of SSDs to attach to each node in the Pulsar Functions pool. Defaults to 0. | `number` | `0` | no |
| <a name="input_func_pool_version"></a> [func\_pool\_version](#input\_func\_pool\_version) | The version of Kubernetes to use for the Pulsar Functions pool. If the input "release\_channel" is not defined, defaults to "kubernetes\_version" used for the cluster. Should only be defined while "func\_pool\_auto\_upgrade" is also set to "false". | `string` | `""` | no |
| <a name="input_gcp_public_cidrs_access_enabled"></a> [gcp\_public\_cidrs\_access\_enabled](#input\_gcp\_public\_cidrs\_access\_enabled) | Enable access from GCP public CIDRs. Defaults to false. | `bool` | `false` | no |
| <a name="input_google_service_account"></a> [google\_service\_account](#input\_google\_service\_account) | when set, don't create GSAs and instead use the this service account for all apps | `string` | `""` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | The version of Kubernetes to use for the cluster. Defaults to "latest", which uses the latest available version for GKE in the region specified. | `string` | `"latest"` | no |
| <a name="input_logging_enabled_components"></a> [logging\_enabled\_components](#input\_logging\_enabled\_components) | List of services to monitor: SYSTEM\_COMPONENTS, APISERVER, CONTROLLER\_MANAGER, SCHEDULER, WORKLOADS. Empty list is default GKE configuration. | `list(string)` | `[]` | no |
| <a name="input_logging_service"></a> [logging\_service](#input\_logging\_service) | The logging service to use for the cluster. Defaults to "logging.googleapis.com/kubernetes". | `string` | `"logging.googleapis.com/kubernetes"` | no |
| <a name="input_maintenance_exclusions"></a> [maintenance\_exclusions](#input\_maintenance\_exclusions) | A list of objects used to define exceptions to the maintenance window, when non-emergency maintenance should not occur. Can have up to three exclusions. Refer to the offical Terraform docs on the "google\_container\_cluster" resource for object schema. | `list(object({ name = string, start_time = string, end_time = string, exclusion_scope = string }))` | `[]` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | The start time (in RFC3339 format) for the GKE to perform maintenance operations. Defaults to "05:00". | `string` | `"05:00"` | no |
| <a name="input_master_authorized_networks"></a> [master\_authorized\_networks](#input\_master\_authorized\_networks) | A list of objects used to define authorized networks. If none are provided, the default is to disallow external access. See the parent module for more details. https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/latest | `list(object({ cidr_block = string, display_name = string }))` | `[]` | no |
| <a name="input_master_global_access_enabled"></a> [master\_global\_access\_enabled](#input\_master\_global\_access\_enabled) | Whether the cluster master is accessible globally (from any region) or only within the same region as the private endpoint. | `bool` | `false` | no |
| <a name="input_master_ipv4_cidr_block"></a> [master\_ipv4\_cidr\_block](#input\_master\_ipv4\_cidr\_block) | The IP range in CIDR notation to use for the hosted master network. Only used for private clusters | `string` | `"10.0.0.0/28"` | no |
| <a name="input_monitoring_enabled_components"></a> [monitoring\_enabled\_components](#input\_monitoring\_enabled\_components) | List of services to monitor: SYSTEM\_COMPONENTS, APISERVER, CONTROLLER\_MANAGER, SCHEDULER. Empty list is default GKE configuration. | `list(string)` | `[]` | no |
| <a name="input_network_project_id"></a> [network\_project\_id](#input\_network\_project\_id) | If using a different project, the id of the project | `string` | `""` | no |
| <a name="input_node_pool_auto_repair"></a> [node\_pool\_auto\_repair](#input\_node\_pool\_auto\_repair) | Enable auto-repair for the default node pool. | `bool` | `true` | no |
| <a name="input_node_pool_auto_upgrade"></a> [node\_pool\_auto\_upgrade](#input\_node\_pool\_auto\_upgrade) | Enable auto-upgrade for the default node pool. | `bool` | `true` | no |
| <a name="input_node_pool_autoscaling"></a> [node\_pool\_autoscaling](#input\_node\_pool\_autoscaling) | Enable autoscaling of the default node pool. Defaults to "true". | `bool` | `true` | no |
| <a name="input_node_pool_autoscaling_initial_count"></a> [node\_pool\_autoscaling\_initial\_count](#input\_node\_pool\_autoscaling\_initial\_count) | The initial number of nodes per zone in the default node pool, PER ZONE, when autoscaling is enabled. Defaults to 1. | `number` | `1` | no |
| <a name="input_node_pool_autoscaling_max_size"></a> [node\_pool\_autoscaling\_max\_size](#input\_node\_pool\_autoscaling\_max\_size) | The maximum size of the default node pool Autoscaling group. Defaults to 5. | `number` | `5` | no |
| <a name="input_node_pool_autoscaling_min_size"></a> [node\_pool\_autoscaling\_min\_size](#input\_node\_pool\_autoscaling\_min\_size) | The minimum size of the default node pool AutoScaling group. Defaults to 1. | `number` | `1` | no |
| <a name="input_node_pool_count"></a> [node\_pool\_count](#input\_node\_pool\_count) | The number of worker nodes in the default node pool. This is only used if node\_pool\_autoscaling is set to false. Defaults to 3. | `number` | `3` | no |
| <a name="input_node_pool_disk_size"></a> [node\_pool\_disk\_size](#input\_node\_pool\_disk\_size) | Disk size in GB for worker nodes in the default node pool. Defaults to 100. | `number` | `100` | no |
| <a name="input_node_pool_disk_type"></a> [node\_pool\_disk\_type](#input\_node\_pool\_disk\_type) | The type disk attached to worker nodes in the default node pool. Defaults to "pd-standard". | `string` | `"pd-standard"` | no |
| <a name="input_node_pool_image_type"></a> [node\_pool\_image\_type](#input\_node\_pool\_image\_type) | The image type to use for worker nodes in the default node pool. Defaults to "COS" (cointainer-optimized OS with docker). | `string` | `"COS_CONTAINERD"` | no |
| <a name="input_node_pool_locations"></a> [node\_pool\_locations](#input\_node\_pool\_locations) | A string of comma seperated values (upstream requirement) of zones for the location of the default node pool, e.g. "us-central1-b,us-central1-c" etc. Nodes must be in the region as the cluster. Defaults to three random zones in the region chosen for the cluster | `string` | `""` | no |
| <a name="input_node_pool_machine_type"></a> [node\_pool\_machine\_type](#input\_node\_pool\_machine\_type) | The machine type to use for worker nodes in the default node pool. Defaults to "n2-standard-8". | `string` | `"n2-standard-8"` | no |
| <a name="input_node_pool_max_pods_per_node"></a> [node\_pool\_max\_pods\_per\_node](#input\_node\_pool\_max\_pods\_per\_node) | the number of pods per node | `number` | `110` | no |
| <a name="input_node_pool_name"></a> [node\_pool\_name](#input\_node\_pool\_name) | The name of the default node pool. Defaults to "sn-node-pool". | `string` | `"default-node-pool"` | no |
| <a name="input_node_pool_secure_boot"></a> [node\_pool\_secure\_boot](#input\_node\_pool\_secure\_boot) | enable the node pool secure boot setting | `bool` | `false` | no |
| <a name="input_node_pool_service_account"></a> [node\_pool\_service\_account](#input\_node\_pool\_service\_account) | The service account email address to use for the default node pool. If create\_service\_account is set to true, it will use the the output from the module. | `string` | `""` | no |
| <a name="input_node_pool_ssd_count"></a> [node\_pool\_ssd\_count](#input\_node\_pool\_ssd\_count) | The number of SSDs to attach to each node in the default node pool | `number` | `0` | no |
| <a name="input_node_pool_version"></a> [node\_pool\_version](#input\_node\_pool\_version) | The version of Kubernetes to use for the default node pool. If the input "release\_channel" is not defined, defaults to "kubernetes\_version" used for the cluster. Should only be defined while "node\_pool\_auto\_upgrade" is also set to "false". | `string` | `""` | no |
| <a name="input_private_endpoint_subnetwork"></a> [private\_endpoint\_subnetwork](#input\_private\_endpoint\_subnetwork) | The subnetwork to use for the hosted master network. | `string` | `null` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID to use for the cluster. Defaults to the current GCP project. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The GCP region where the GKE cluster will be deployed. This module only supports creation of a regional cluster | `string` | n/a | yes |
| <a name="input_release_channel"></a> [release\_channel](#input\_release\_channel) | The Kubernetes release channel to use for the cluster. Accepted values are "UNSPECIFIED", "RAPID", "REGULAR" and "STABLE". Defaults to "UNSPECIFIED". | `string` | `"STABLE"` | no |
| <a name="input_secondary_ip_range_pods"></a> [secondary\_ip\_range\_pods](#input\_secondary\_ip\_range\_pods) | The name of the secondary range to use for the pods in the cluster. If no secondary range for the pod network is provided, GKE will create a /14 CIDR within the subnetwork provided by the "vpc\_subnet" input | `string` | `null` | no |
| <a name="input_secondary_ip_range_pods_cidr"></a> [secondary\_ip\_range\_pods\_cidr](#input\_secondary\_ip\_range\_pods\_cidr) | The cidr of the secondary range, required when using cillium | `string` | `null` | no |
| <a name="input_secondary_ip_range_services"></a> [secondary\_ip\_range\_services](#input\_secondary\_ip\_range\_services) | The name of the secondary range to use for services in the cluster. If no secondary range for the services network is provided, GKE will create a /20 CIDR within the subnetwork provided by the "vpc\_subnet" input | `string` | `null` | no |
| <a name="input_storage_class_default_ssd"></a> [storage\_class\_default\_ssd](#input\_storage\_class\_default\_ssd) | determines if the default storage class should be with ssd | `bool` | `false` | no |
| <a name="input_suffix"></a> [suffix](#input\_suffix) | A unique string that is used to distinguish cluster resources, where name length constraints are imposed by GKE. Defaults to an empty string. | `string` | `""` | no |
| <a name="input_vpc_network"></a> [vpc\_network](#input\_vpc\_network) | The name of the VPC network to use for the cluster. Can be set to "default" if the default VPC is enabled in the project | `string` | n/a | yes |
| <a name="input_vpc_subnet"></a> [vpc\_subnet](#input\_vpc\_subnet) | The name of the VPC subnetwork to use by the cluster nodes. Can be set to "default" if the default VPC is enabled in the project, and GKE will choose the subnetwork based on the "region" input | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ca_certificate"></a> [ca\_certificate](#output\_ca\_certificate) | n/a |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | n/a |
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_master_version"></a> [master\_version](#output\_master\_version) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
| <a name="output_node_pool_azs"></a> [node\_pool\_azs](#output\_node\_pool\_azs) | n/a |
| <a name="output_service_account"></a> [service\_account](#output\_service\_account) | n/a |
<!-- END_TF_DOCS -->
