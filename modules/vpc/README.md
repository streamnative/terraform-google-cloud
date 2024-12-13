<!--
  ~ Copyright 2023 StreamNative, Inc.
  ~
  ~ Licensed under the Apache License, Version 2.0 (the "License");
  ~ you may not use this file except in compliance with the License.
  ~ You may obtain a copy of the License at
  ~
  ~     http://www.apache.org/licenses/LICENSE-2.0
  ~
  ~ Unless required by applicable law or agreed to in writing, software
  ~ distributed under the License is distributed on an "AS IS" BASIS,
  ~ WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  ~ See the License for the specific language governing permissions and
  ~ limitations under the License.
-->

# VPC Module
A basic module used to create a GCP VPC Network with a Subnet and Private Service Connect Subnet, intended to be used by StreamNative Cloud. 

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloud_router"></a> [cloud\_router](#module\_cloud\_router) | terraform-google-modules/cloud-router/google | ~> 5.0 |
| <a name="module_network"></a> [network](#module\_network) | terraform-google-modules/network/google | >= 4.1.0, < 7.2.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | The name of the VPC | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The GCP project to deploy to | `string` | n/a | yes |
| <a name="input_psc_subnet_name"></a> [psc\_subnet\_name](#input\_psc\_subnet\_name) | The name of the PSC subnet, can be left empty to auto-generate | `string` | `""` | no |
| <a name="input_psc_vpc_cidr"></a> [psc\_vpc\_cidr](#input\_psc\_vpc\_cidr) | The CIDR block for the private service connect | `string` | `"10.1.0.0/18"` | no |
| <a name="input_region"></a> [region](#input\_region) | The GCP region to deploy to | `string` | n/a | yes |
| <a name="input_secondary_ip_range_pods"></a> [secondary\_ip\_range\_pods](#input\_secondary\_ip\_range\_pods) | The secondary IP range for pods | `string` | `"192.168.0.0/18"` | no |
| <a name="input_secondary_ip_range_pods_name"></a> [secondary\_ip\_range\_pods\_name](#input\_secondary\_ip\_range\_pods\_name) | The name of the secondary IP range for pods | `string` | `"ip-range-pods"` | no |
| <a name="input_secondary_ip_range_services"></a> [secondary\_ip\_range\_services](#input\_secondary\_ip\_range\_services) | The secondary IP range for services | `string` | `"192.168.64.0/18"` | no |
| <a name="input_secondary_ip_range_services_name"></a> [secondary\_ip\_range\_services\_name](#input\_secondary\_ip\_range\_services\_name) | The name of the secondary IP range for services | `string` | `"ip-range-svc"` | no |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | The name of the subnet, can be left empty to auto-generate | `string` | `""` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | The CIDR block for the VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_network"></a> [network](#output\_network) | n/a |
| <a name="output_psc_subnet_name"></a> [psc\_subnet\_name](#output\_psc\_subnet\_name) | n/a |
| <a name="output_secondary_ip_range_pods"></a> [secondary\_ip\_range\_pods](#output\_secondary\_ip\_range\_pods) | n/a |
| <a name="output_secondary_ip_range_pods_name"></a> [secondary\_ip\_range\_pods\_name](#output\_secondary\_ip\_range\_pods\_name) | n/a |
| <a name="output_secondary_ip_range_services"></a> [secondary\_ip\_range\_services](#output\_secondary\_ip\_range\_services) | n/a |
| <a name="output_secondary_ip_range_services_name"></a> [secondary\_ip\_range\_services\_name](#output\_secondary\_ip\_range\_services\_name) | n/a |
| <a name="output_subnet_name"></a> [subnet\_name](#output\_subnet\_name) | n/a |
<!-- END_TF_DOCS -->