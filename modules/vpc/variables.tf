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

variable "project" {
  type        = string
  description = "The GCP project to deploy to"
}

variable "region" {
  type        = string
  description = "The GCP region to deploy to"
}

variable "network_name" {
  type        = string
  description = "The name of the VPC"
}

variable "subnet_name" {
  type        = string
  default     = ""
  description = "The name of the subnet, can be left empty to auto-generate"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "The CIDR block for the VPC"
}

variable "psc_subnet_name" {
  type        = string
  default     = ""
  description = "The name of the PSC subnet, can be left empty to auto-generate"
}

variable "psc_vpc_cidr" {
  type        = string
  default     = "10.1.0.0/18"
  description = "The CIDR block for the private service connect"
}

variable "secondary_ip_range_pods" {
  type        = string
  default     = "192.168.0.0/18"
  description = "The secondary IP range for pods"
}

variable "secondary_ip_range_services" {
  type        = string
  default     = "192.168.64.0/18"
  description = "The secondary IP range for services"
}

variable "secondary_ip_range_pods_name" {
  type        = string
  default     = "ip-range-pods"
  description = "The name of the secondary IP range for pods"
}

variable "secondary_ip_range_services_name" {
  type        = string
  default     = "ip-range-svc"
  description = "The name of the secondary IP range for services"
}
