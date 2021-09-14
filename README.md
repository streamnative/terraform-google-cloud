# terraform-google-cloud

Example configuration:

```hcl
terraform {
  required_version = ">=1.0.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.76.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.2.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "helm" {
  kubernetes {
    host                   = format("https://%s", data.google_container_cluster.cluster.endpoint)
    cluster_ca_certificate = base64decode(data.google_container_cluster.cluster.master_auth[0].cluster_ca_certificate)
    token                  = data.google_client_config.provider.access_token
  }
}

provider "kubernetes" {
  host                   = format("https://%s", data.google_container_cluster.cluster.endpoint)
  cluster_ca_certificate = base64decode(data.google_container_cluster.cluster.master_auth[0].cluster_ca_certificate)
  token                  = data.google_client_config.provider.access_token
}

# Configure variable defaults here, with a .tfvars file, or provide them to terraform when prompted.
variable "environment" {}
variable "project_id" {}
variable "region" {}

data "google_client_config" "provider" {}

data "google_container_cluster" "cluster" {
  name     = module.sn_cluster.gke_cluster_name
  location = var.region
}

resource "random_pet" "cluster_name" {
  length = 1
}

locals {
  cluster_name = format("sn-%s-%s", random_pet.cluster_name.id, var.environment)
}

module "sn_cloud_dns" {
  source  = "terraform-google-modules/cloud-dns/google"
  version = "3.1.0"

  domain     = "g.example.dev."
  name       = local.cluster_name
  project_id = var.project_id
  type       = "public"
}

# Add this repo as a git submodule and refer to its relative path (or clone and point to the location)
module "sn_cluster" {
  source = "../terraform-google-cloud" 

  cluster_location            = var.region
  cluster_name                = local.cluster_name
  enable_func_pool            = false
  external_dns_domain_filters = [module.sn_cloud_dns.domain]
  project_id                  = var.project_id
}

# Note: If the func pool is enabled, you must wait for the cluster to be ready before running this module
module "sn_bootstrap" {
  source = "streamnative/charts/helm"
  version = "0.4.0"

  # Note: OLM for GKE is still a WIP as we work on a long term solution for managing our operator images
  enable_olm               = true
  olm_registry             = "gcr.io/affable-ray-226821/streamnative/pulsar-operators/registry/pulsar-operators:production"

  depends_on = [
    module.sn_cluster
  ]
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.0.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | 3.76.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.2.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 3.76.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.2.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cert_manager_sa"></a> [cert\_manager\_sa](#module\_cert\_manager\_sa) | terraform-google-modules/kubernetes-engine/google//modules/workload-identity | 16.1.0 |
| <a name="module_external_dns_sa"></a> [external\_dns\_sa](#module\_external\_dns\_sa) | terraform-google-modules/kubernetes-engine/google//modules/workload-identity | 16.1.0 |
| <a name="module_external_secrets_sa"></a> [external\_secrets\_sa](#module\_external\_secrets\_sa) | terraform-google-modules/kubernetes-engine/google//modules/workload-identity | 16.1.0 |
| <a name="module_gke"></a> [gke](#module\_gke) | terraform-google-modules/kubernetes-engine/google | 16.1.0 |

## Resources

| Name | Type |
|------|------|
| [helm_release.cert_manager](https://registry.terraform.io/providers/hashicorp/helm/2.2.0/docs/resources/release) | resource |
| [helm_release.external_dns](https://registry.terraform.io/providers/hashicorp/helm/2.2.0/docs/resources/release) | resource |
| [helm_release.external_secrets](https://registry.terraform.io/providers/hashicorp/helm/2.2.0/docs/resources/release) | resource |
| [kubernetes_namespace.sn_system](https://registry.terraform.io/providers/hashicorp/kubernetes/2.2.0/docs/resources/namespace) | resource |
| [google_compute_zones.available](https://registry.terraform.io/providers/hashicorp/google/3.76.0/docs/data-sources/compute_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_add_cluster_firewall_rules"></a> [add\_cluster\_firewall\_rules](#input\_add\_cluster\_firewall\_rules) | Creates additional firewall rules on the cluster. | `bool` | `false` | no |
| <a name="input_add_master_webhook_firewall_rules"></a> [add\_master\_webhook\_firewall\_rules](#input\_add\_master\_webhook\_firewall\_rules) | Create master\_webhook firewall rules for ports defined in firewall\_inbound\_ports. | `bool` | `false` | no |
| <a name="input_add_shadow_firewall_rules"></a> [add\_shadow\_firewall\_rules](#input\_add\_shadow\_firewall\_rules) | Create GKE shadow firewall (the same as default firewall rules with firewall logs enabled). | `bool` | `false` | no |
| <a name="input_cert_manager_helm_chart_name"></a> [cert\_manager\_helm\_chart\_name](#input\_cert\_manager\_helm\_chart\_name) | The name of the Cert Manager Helm chart to be used. | `string` | `"cert-manager"` | no |
| <a name="input_cert_manager_helm_chart_repository"></a> [cert\_manager\_helm\_chart\_repository](#input\_cert\_manager\_helm\_chart\_repository) | The location of the helm chart to use for Cert Manager. | `string` | `"https://charts.bitnami.com/bitnami"` | no |
| <a name="input_cert_manager_helm_chart_version"></a> [cert\_manager\_helm\_chart\_version](#input\_cert\_manager\_helm\_chart\_version) | The version of the Cert Manager helm chart to install. Defaults to "0.1.10". | `string` | `"0.1.10"` | no |
| <a name="input_cert_manager_settings"></a> [cert\_manager\_settings](#input\_cert\_manager\_settings) | Additional settings which will be passed to the Helm chart values. See https://github.com/bitnami/charts/tree/master/bitnami/cert-manager for detailed options. | `map(any)` | `{}` | no |
| <a name="input_cluster_autoscaling_config"></a> [cluster\_autoscaling\_config](#input\_cluster\_autoscaling\_config) | Cluster autoscaling configuration | <pre>object({<br>    enabled       = bool<br>    min_cpu_cores = number<br>    max_cpu_cores = number<br>    min_memory_gb = number<br>    max_memory_gb = number<br>    gpu_resources = list(object({ resource_type = string, minimum = number, maximum = number }))<br>  })</pre> | <pre>{<br>  "enabled": true,<br>  "gpu_resources": [],<br>  "max_cpu_cores": 10,<br>  "max_memory_gb": 16,<br>  "min_cpu_cores": 1,<br>  "min_memory_gb": 1<br>}</pre> | no |
| <a name="input_cluster_http_load_balancing"></a> [cluster\_http\_load\_balancing](#input\_cluster\_http\_load\_balancing) | Enable the HTTP load balancing addon for the cluster. Defaults to "true" | `bool` | `true` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of your GKE cluster. | `string` | n/a | yes |
| <a name="input_cluster_network_policy"></a> [cluster\_network\_policy](#input\_cluster\_network\_policy) | Enable the network policy addon for the cluster. Defaults to "true", and uses CALICO as the provider | `bool` | `true` | no |
| <a name="input_create_service_account"></a> [create\_service\_account](#input\_create\_service\_account) | Creates a service account for the cluster. Defaults to "true". | `bool` | `true` | no |
| <a name="input_create_sn_system_namespace"></a> [create\_sn\_system\_namespace](#input\_create\_sn\_system\_namespace) | Whether or not to create the namespace "sn-system" on the cluster. This namespace is commonly used by OLM and StreamNative's Kubernetes Operators and services | `bool` | `true` | no |
| <a name="input_disable_istio_sources"></a> [disable\_istio\_sources](#input\_disable\_istio\_sources) | Disables Istio sources for the External DNS configuration. Set to "false" by default. Set to "true" for debugging External DNS or if Istio is disabled. | `bool` | `false` | no |
| <a name="input_enable_external_secrets"></a> [enable\_external\_secrets](#input\_enable\_external\_secrets) | Enables kubernetes-external-secrets on the cluster, which uses GCP Secret Manager as the secrets backend | `bool` | `true` | no |
| <a name="input_enable_func_pool"></a> [enable\_func\_pool](#input\_enable\_func\_pool) | Enable an additional dedicated pool for Pulsar Functions. Enabled by default. | `bool` | `true` | no |
| <a name="input_external_dns_domain_filters"></a> [external\_dns\_domain\_filters](#input\_external\_dns\_domain\_filters) | A list of domains that ExternalDNS is allowed to work with | `list(string)` | `[]` | no |
| <a name="input_external_dns_helm_chart_name"></a> [external\_dns\_helm\_chart\_name](#input\_external\_dns\_helm\_chart\_name) | The name of the Helm chart in the repository for ExternalDNS. | `string` | `"external-dns"` | no |
| <a name="input_external_dns_helm_chart_repository"></a> [external\_dns\_helm\_chart\_repository](#input\_external\_dns\_helm\_chart\_repository) | The repository containing the ExternalDNS helm chart. | `string` | `"https://charts.bitnami.com/bitnami"` | no |
| <a name="input_external_dns_helm_chart_version"></a> [external\_dns\_helm\_chart\_version](#input\_external\_dns\_helm\_chart\_version) | Helm chart version for ExternalDNS. See https://hub.helm.sh/charts/bitnami/external-dns for updates. | `string` | `"5.4.1"` | no |
| <a name="input_external_dns_policy"></a> [external\_dns\_policy](#input\_external\_dns\_policy) | Sets how DNS records are managed by ExternalDNS. Options are "sync", which allows ExternalDNS to create and delete records, or "upsert\_only", which only allows for the creation of records | `string` | `"upsert-only"` | no |
| <a name="input_external_dns_settings"></a> [external\_dns\_settings](#input\_external\_dns\_settings) | Additional settings which will be passed to the Helm chart values, see https://github.com/bitnami/charts/tree/master/bitnami/external-dns for detailed options. | `map(any)` | `{}` | no |
| <a name="input_external_dns_version"></a> [external\_dns\_version](#input\_external\_dns\_version) | The version of the ExternalDNS helm chart to install. Defaults to "5.2.2". | `string` | `"5.2.2"` | no |
| <a name="input_external_secrets_helm_chart_name"></a> [external\_secrets\_helm\_chart\_name](#input\_external\_secrets\_helm\_chart\_name) | The name of the Helm chart in the repository for kubernetes-external-secrets | `string` | `"kubernetes-external-secrets"` | no |
| <a name="input_external_secrets_helm_chart_repository"></a> [external\_secrets\_helm\_chart\_repository](#input\_external\_secrets\_helm\_chart\_repository) | The repository containing the kubernetes-external-secrets helm chart | `string` | `"https://external-secrets.github.io/kubernetes-external-secrets"` | no |
| <a name="input_external_secrets_helm_chart_version"></a> [external\_secrets\_helm\_chart\_version](#input\_external\_secrets\_helm\_chart\_version) | Helm chart version for kubernetes-external-secrets. Defaults to "8.3.0". See https://github.com/external-secrets/kubernetes-external-secrets/tree/master/charts/kubernetes-external-secrets for updates | `string` | `"8.3.0"` | no |
| <a name="input_external_secrets_settings"></a> [external\_secrets\_settings](#input\_external\_secrets\_settings) | Additional settings which will be passed to the Helm chart values, see https://github.com/external-secrets/kubernetes-external-secrets/tree/master/charts/kubernetes-external-secrets for available options | `map(any)` | `{}` | no |
| <a name="input_func_pool_auto_repair"></a> [func\_pool\_auto\_repair](#input\_func\_pool\_auto\_repair) | Enable auto-repair for the Pulsar Functions pool. | `bool` | `true` | no |
| <a name="input_func_pool_auto_upgrade"></a> [func\_pool\_auto\_upgrade](#input\_func\_pool\_auto\_upgrade) | Enable auto-upgrade for the Pulsar Functions pool. | `bool` | `false` | no |
| <a name="input_func_pool_autoscaling"></a> [func\_pool\_autoscaling](#input\_func\_pool\_autoscaling) | Enable autoscaling of the Pulsar Functions pool. Defaults to "true". | `bool` | `true` | no |
| <a name="input_func_pool_autoscaling_initial_count"></a> [func\_pool\_autoscaling\_initial\_count](#input\_func\_pool\_autoscaling\_initial\_count) | The initial number of nodes in the Pulsar Functions pool when autoscaling is enabled. Defaults to 1. | `number` | `1` | no |
| <a name="input_func_pool_autoscaling_max_size"></a> [func\_pool\_autoscaling\_max\_size](#input\_func\_pool\_autoscaling\_max\_size) | The maximum size of the Pulsar Functions pool Autoscaling group. Defaults to 3. | `number` | `3` | no |
| <a name="input_func_pool_autoscaling_min_size"></a> [func\_pool\_autoscaling\_min\_size](#input\_func\_pool\_autoscaling\_min\_size) | The minimum size of the Pulsar Functions pool AutoScaling group. Defaults to 1. | `number` | `1` | no |
| <a name="input_func_pool_count"></a> [func\_pool\_count](#input\_func\_pool\_count) | The number of worker nodes in the Pulsar Functions pool. This is only used if func\_pool\_autoscaling is set to false. Defaults to 1. | `number` | `1` | no |
| <a name="input_func_pool_disk_size"></a> [func\_pool\_disk\_size](#input\_func\_pool\_disk\_size) | Disk size in GB for worker nodes in the Pulsar Functions pool. Defaults to 100. | `number` | `100` | no |
| <a name="input_func_pool_disk_type"></a> [func\_pool\_disk\_type](#input\_func\_pool\_disk\_type) | The type disk attached to worker nodes in the Pulsar Functions pool. Defaults to "pd-standard". | `string` | `"pd-standard"` | no |
| <a name="input_func_pool_image_type"></a> [func\_pool\_image\_type](#input\_func\_pool\_image\_type) | The image type to use for worker nodes in the Pulsar Functions pool. Defaults to "COS" (cointainer-optimized OS with docker). | `string` | `"COS"` | no |
| <a name="input_func_pool_locations"></a> [func\_pool\_locations](#input\_func\_pool\_locations) | A string of comma seperated values (upstream requirement) of zones for the Pulsar Functions pool, e.g. "us-central1-b,us-central1-c" etc. Nodes must be in the same region as the cluster. Defaults to three random zones in the region specified for the cluster via the "cluster\_location" input, or the zones provided through the "node\_pool\_locations" input (if it is defined). | `string` | `""` | no |
| <a name="input_func_pool_machine_type"></a> [func\_pool\_machine\_type](#input\_func\_pool\_machine\_type) | The machine type to use for worker nodes in the Pulsar Functions pool. Defaults to "n1-standard-1". | `string` | `"n1-standard-1"` | no |
| <a name="input_func_pool_name"></a> [func\_pool\_name](#input\_func\_pool\_name) | The name of the Pulsar Functions pool. Defaults to "default-node-pool". | `string` | `"func-pool"` | no |
| <a name="input_func_pool_service_account"></a> [func\_pool\_service\_account](#input\_func\_pool\_service\_account) | The service account email address to use for the Pulsar Functions pool. If create\_service\_account is set to true, it will use the the output from the module. | `string` | `""` | no |
| <a name="input_func_pool_ssd_count"></a> [func\_pool\_ssd\_count](#input\_func\_pool\_ssd\_count) | The number of SSDs to attach to each node in the Pulsar Functions pool. Defaults to 0. | `number` | `0` | no |
| <a name="input_func_pool_version"></a> [func\_pool\_version](#input\_func\_pool\_version) | The version of Kubernetes to use for the Pulsar Functions pool. If the input "release\_channel" is not defined, defaults to "kubernetes\_version" used for the cluster. Should only be defined while "func\_pool\_auto\_upgrade" is also set to "false". | `string` | `""` | no |
| <a name="input_horizontal_pod_autoscaling"></a> [horizontal\_pod\_autoscaling](#input\_horizontal\_pod\_autoscaling) | Enable horizontal pod autoscaling for the cluster. Defaults to "true". | `bool` | `true` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | The version of Kubernetes to use for the cluster. Defaults to "latest", which uses the latest available version for GKE in the region specified. | `string` | `"latest"` | no |
| <a name="input_logging_service"></a> [logging\_service](#input\_logging\_service) | The logging service to use for the cluster. Defaults to "logging.googleapis.com/kubernetes". | `string` | `"logging.googleapis.com/kubernetes"` | no |
| <a name="input_maintenance_exclusions"></a> [maintenance\_exclusions](#input\_maintenance\_exclusions) | A list of objects used to define exceptions to the maintenance window, when non-emergency maintenance should not occur. Can have up to three exclusions. Refer to the offical Terraform docs on the "google\_container\_cluster" resource for object schema. | `list(object({ name = string, start_time = string, end_time = string }))` | `[]` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | The start time (in RFC3339 format) for the GKE to perform maintenance operations. Defaults to "05:00". | `string` | `"05:00"` | no |
| <a name="input_master_authorized_networks"></a> [master\_authorized\_networks](#input\_master\_authorized\_networks) | A list of objects used to define authorized networks. If none are provided, the default is to disallow external access. See the parent module for more details. https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/latest | `list(object({ cidr_block = string, display_name = string }))` | `[]` | no |
| <a name="input_node_pool_auto_repair"></a> [node\_pool\_auto\_repair](#input\_node\_pool\_auto\_repair) | Enable auto-repair for the default node pool. | `bool` | `true` | no |
| <a name="input_node_pool_auto_upgrade"></a> [node\_pool\_auto\_upgrade](#input\_node\_pool\_auto\_upgrade) | Enable auto-upgrade for the default node pool. | `bool` | `false` | no |
| <a name="input_node_pool_autoscaling"></a> [node\_pool\_autoscaling](#input\_node\_pool\_autoscaling) | Enable autoscaling of the default node pool. Defaults to "true". | `bool` | `true` | no |
| <a name="input_node_pool_autoscaling_initial_count"></a> [node\_pool\_autoscaling\_initial\_count](#input\_node\_pool\_autoscaling\_initial\_count) | The initial number of nodes per zone in the default node pool when autoscaling is enabled. Defaults to 1. | `number` | `1` | no |
| <a name="input_node_pool_autoscaling_max_size"></a> [node\_pool\_autoscaling\_max\_size](#input\_node\_pool\_autoscaling\_max\_size) | The maximum size of the default node pool Autoscaling group. Defaults to 5. | `number` | `5` | no |
| <a name="input_node_pool_autoscaling_min_size"></a> [node\_pool\_autoscaling\_min\_size](#input\_node\_pool\_autoscaling\_min\_size) | The minimum size of the default node pool AutoScaling group. Defaults to 1. | `number` | `1` | no |
| <a name="input_node_pool_count"></a> [node\_pool\_count](#input\_node\_pool\_count) | The number of worker nodes in the default node pool. This is only used if node\_pool\_autoscaling is set to false. Defaults to 3. | `number` | `3` | no |
| <a name="input_node_pool_disk_size"></a> [node\_pool\_disk\_size](#input\_node\_pool\_disk\_size) | Disk size in GB for worker nodes in the default node pool. Defaults to 100. | `number` | `100` | no |
| <a name="input_node_pool_disk_type"></a> [node\_pool\_disk\_type](#input\_node\_pool\_disk\_type) | The type disk attached to worker nodes in the default node pool. Defaults to "pd-standard". | `string` | `"pd-standard"` | no |
| <a name="input_node_pool_image_type"></a> [node\_pool\_image\_type](#input\_node\_pool\_image\_type) | The image type to use for worker nodes in the default node pool. Defaults to "COS" (cointainer-optimized OS with docker). | `string` | `"COS"` | no |
| <a name="input_node_pool_locations"></a> [node\_pool\_locations](#input\_node\_pool\_locations) | A string of comma seperated values (upstream requirement) of zones for the location of the default node pool, e.g. "us-central1-b,us-central1-c" etc. Nodes must be in the region as the cluster. Defaults to three random zones in the region chosen for the cluster | `string` | `""` | no |
| <a name="input_node_pool_machine_type"></a> [node\_pool\_machine\_type](#input\_node\_pool\_machine\_type) | The machine type to use for worker nodes in the default node pool. Defaults to "n1-standard-1". | `string` | `"n1-standard-1"` | no |
| <a name="input_node_pool_name"></a> [node\_pool\_name](#input\_node\_pool\_name) | The name of the default node pool. Defaults to "sn-node-pool". | `string` | `"default-node-pool"` | no |
| <a name="input_node_pool_service_account"></a> [node\_pool\_service\_account](#input\_node\_pool\_service\_account) | The service account email address to use for the default node pool. If create\_service\_account is set to true, it will use the the output from the module. | `string` | `""` | no |
| <a name="input_node_pool_ssd_count"></a> [node\_pool\_ssd\_count](#input\_node\_pool\_ssd\_count) | The number of SSDs to attach to each node in the default node pool | `number` | `0` | no |
| <a name="input_node_pool_version"></a> [node\_pool\_version](#input\_node\_pool\_version) | The version of Kubernetes to use for the default node pool. If the input "release\_channel" is not defined, defaults to "kubernetes\_version" used for the cluster. Should only be defined while "node\_pool\_auto\_upgrade" is also set to "false". | `string` | `""` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID to use for the cluster. Defaults to the current GCP project. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The GCP region where the GKE cluster will be deployed. This module only supports creation of a regional cluster | `string` | n/a | yes |
| <a name="input_release_channel"></a> [release\_channel](#input\_release\_channel) | The Kubernetes release channel to use for the cluster. Accepted values are "UNSPECIFIED", "RAPID", "REGULAR" and "STABLE". Defaults to "UNSPECIFIED". | `string` | `"UNSPECIFIED"` | no |
| <a name="input_secondary_ip_range_pods"></a> [secondary\_ip\_range\_pods](#input\_secondary\_ip\_range\_pods) | The name of the secondary range to use for the pods in the cluster. If no secondary range for the pod network is provided, GKE will create a /14 CIDR within the subnetwork provided by the "vpc\_subnet" input | `string` | `null` | no |
| <a name="input_secondary_ip_range_services"></a> [secondary\_ip\_range\_services](#input\_secondary\_ip\_range\_services) | The name of the secondary range to use for services in the cluster. If no secondary range for the services network is provided, GKE will create a /20 CIDR within the subnetwork provided by the "vpc\_subnet" input | `string` | `null` | no |
| <a name="input_vpc_network"></a> [vpc\_network](#input\_vpc\_network) | The name of the VPC network to use for the cluster. Can be set to "default" if the default VPC is enabled in the project | `string` | n/a | yes |
| <a name="input_vpc_subnet"></a> [vpc\_subnet](#input\_vpc\_subnet) | The name of the VPC subnetwork to use by the cluster nodes. Can be set to "default" if the default VPC is enabled in the project, and GKE will choose the subnetwork based on the "region" input | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_gke_cluster_endpoint"></a> [gke\_cluster\_endpoint](#output\_gke\_cluster\_endpoint) | n/a |
| <a name="output_gke_cluster_id"></a> [gke\_cluster\_id](#output\_gke\_cluster\_id) | n/a |
| <a name="output_gke_cluster_master_version"></a> [gke\_cluster\_master\_version](#output\_gke\_cluster\_master\_version) | n/a |
| <a name="output_gke_cluster_name"></a> [gke\_cluster\_name](#output\_gke\_cluster\_name) | n/a |
| <a name="output_gke_cluster_service_account"></a> [gke\_cluster\_service\_account](#output\_gke\_cluster\_service\_account) | n/a |
