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

output "ca_certificate" {
  value = try(module.gke[0].ca_certificate, module.gke_private[0].ca_certificate)
}

output "endpoint" {
  value = try(module.gke[0].endpoint, module.gke_private[0].endpoint)
}

output "id" {
  value = try(module.gke[0].cluster_id, module.gke_private[0].cluster_id)
}

output "name" {
  value = local.cluster_name
}

output "master_version" {
  value = try(module.gke[0].master_version, module.gke_private[0].master_version)
}

output "service_account" {
  value = try(module.gke[0].service_account, module.gke_private[0].service_account)
}