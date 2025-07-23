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

output "zone_id" {
  value = local.zone_id
}

output "zone_name" {
  value = local.zone_name
}


output "tiered_storage_bucket" {
  value = google_storage_bucket.tiered_storage.name
}

output "backup_bucket" {
  value = google_storage_bucket.velero.name
}

output "loki_bucket" {
  value = var.enable_loki ? google_storage_bucket.loki.name : ""
}

