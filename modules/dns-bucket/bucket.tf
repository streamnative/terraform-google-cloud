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

resource "google_storage_bucket" "velero" {
  name     = format("%s-cluster-backup", var.pm_name)
  provider = google.target

  location                    = var.bucket_location
  uniform_bucket_level_access = var.bucket_uniform_bucket_level_access
  force_destroy               = true
  encryption {
    default_kms_key_name = var.bucket_encryption_kms_key_id
  }

  dynamic "soft_delete_policy" {
    for_each = !var.bucket_cluster_backup_soft_delete ? ["apply"] : []
    content {
      retention_duration_seconds = 0
    }
  }
}

resource "google_storage_bucket" "tiered_storage" {
  name     = format("%s-tiered-storage", var.pm_name)
  provider = google.target

  location                    = var.bucket_location
  uniform_bucket_level_access = var.bucket_uniform_bucket_level_access
  force_destroy               = true
  encryption {
    default_kms_key_name = var.bucket_encryption_kms_key_id
  }

  dynamic "soft_delete_policy" {
    for_each = !var.bucket_cluster_backup_soft_delete ? ["apply"] : []
    content {
      retention_duration_seconds = 0
    }
  }
}
