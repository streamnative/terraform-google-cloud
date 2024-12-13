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

output "network" {
  value = module.network.network_name
}

output "subnet_name" {
  value = module.network.subnets_names[0]
}

output "psc_subnet_name" {
  value = local.psc_subnet_name
}

output "secondary_ip_range_pods" {
  value = var.secondary_ip_range_pods
}

output "secondary_ip_range_pods_name" {
  value = var.secondary_ip_range_pods_name
}

output "secondary_ip_range_services" {
  value = var.secondary_ip_range_services
}

output "secondary_ip_range_services_name" {
  value = var.secondary_ip_range_services_name
}
