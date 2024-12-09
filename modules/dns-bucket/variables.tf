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

variable "pm_name" {
  description = "The name of the poolmember, for new clusters, this should be like `pm-<xxxxx>`"
  type        = string
}

variable "parent_zone_name" {
  type        = string
  description = "The parent zone in which we create the delegation records"
}

variable "custom_dns_zone_id" {
  type        = string
  default     = ""
  description = "if specified, then a streamnative zone will not be created, and this zone will be used instead. Otherwise, we will provision a new zone and delegate access"
}

variable "custom_dns_zone_name" {
  type        = string
  default     = ""
  description = "must be passed if custom_dns_zone_id is passed, this is the zone name to use"
}

variable "bucket_location" {
  type        = string
  description = "The location of the bucket"
}

variable "bucket_encryption_kms_key_id" {
  default     = null
  description = "KMS key id to use for bucket encryption. If not set, the gcp default key will be used"
  type        = string
}

variable "bucket_uniform_bucket_level_access" {
  default     = false
  description = "Enables Uniform bucket-level access access to a bucket."
  type        = bool
}

variable "bucket_tiered_storage_soft_delete" {
  default     = true
  description = "Set the soft deletion policy, if false soft deletes will be disabled."
  type        = bool
}

variable "bucket_cluster_backup_soft_delete" {
  default     = true
  description = "Set the soft deletion policy, if false soft deletes will be disabled."
  type        = bool
}