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

# DNS and Bucket Module
A basic module used to create Cloud DNS Zone and Storage Buckets.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google.source"></a> [google.source](#provider\_google.source) | n/a |
| <a name="provider_google.target"></a> [google.target](#provider\_google.target) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_dns_managed_zone.zone](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_managed_zone) | resource |
| [google_dns_record_set.delegate](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_record_set) | resource |
| [google_storage_bucket.tiered_storage](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket.velero](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_dns_managed_zone.sn](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/dns_managed_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_cluster_backup_soft_delete"></a> [bucket\_cluster\_backup\_soft\_delete](#input\_bucket\_cluster\_backup\_soft\_delete) | Set the soft deletion policy, if false soft deletes will be disabled. | `bool` | `true` | no |
| <a name="input_bucket_encryption_kms_key_id"></a> [bucket\_encryption\_kms\_key\_id](#input\_bucket\_encryption\_kms\_key\_id) | KMS key id to use for bucket encryption. If not set, the gcp default key will be used | `string` | `null` | no |
| <a name="input_bucket_location"></a> [bucket\_location](#input\_bucket\_location) | The location of the bucket | `string` | n/a | yes |
| <a name="input_bucket_tiered_storage_soft_delete"></a> [bucket\_tiered\_storage\_soft\_delete](#input\_bucket\_tiered\_storage\_soft\_delete) | Set the soft deletion policy, if false soft deletes will be disabled. | `bool` | `true` | no |
| <a name="input_bucket_uniform_bucket_level_access"></a> [bucket\_uniform\_bucket\_level\_access](#input\_bucket\_uniform\_bucket\_level\_access) | Enables Uniform bucket-level access access to a bucket. | `bool` | `false` | no |
| <a name="input_custom_dns_zone_id"></a> [custom\_dns\_zone\_id](#input\_custom\_dns\_zone\_id) | if specified, then a streamnative zone will not be created, and this zone will be used instead. Otherwise, we will provision a new zone and delegate access | `string` | `""` | no |
| <a name="input_custom_dns_zone_name"></a> [custom\_dns\_zone\_name](#input\_custom\_dns\_zone\_name) | must be passed if custom\_dns\_zone\_id is passed, this is the zone name to use | `string` | `""` | no |
| <a name="input_parent_zone_name"></a> [parent\_zone\_name](#input\_parent\_zone\_name) | The parent zone in which we create the delegation records | `string` | n/a | yes |
| <a name="input_pm_name"></a> [pm\_name](#input\_pm\_name) | The name of the poolmember, for new clusters, this should be like `pm-<xxxxx>` | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backup_bucket"></a> [backup\_bucket](#output\_backup\_bucket) | n/a |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | n/a |
| <a name="output_zone_name"></a> [zone\_name](#output\_zone\_name) | n/a |
<!-- END_TF_DOCS -->