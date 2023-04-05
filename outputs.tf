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
  value = module.gke.ca_certificate
}

output "endpoint" {
  value = module.gke.endpoint
}

output "id" {
  value = module.gke.cluster_id
}

output "name" {
  value = module.gke.name
}

output "master_version" {
  value = module.gke.master_version
}

output "service_account" {
  value = module.gke.service_account
}

output "cert_manager_sa_email" {
  value = module.cert_manager_sa.gcp_service_account_email
}

output "external_dns_manager_sa_email" {
  value = module.external_dns_sa.gcp_service_account_email
}

output "external_secrets_sa_email" {
  value = module.external_secrets_sa.gcp_service_account_email
}
