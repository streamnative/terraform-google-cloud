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

locals {
  subnet_name     = var.subnet_name != "" ? var.subnet_name : "${var.network_name}-${var.region}"
  psc_subnet_name = "${local.subnet_name}-psc"
}

module "network" {
  source  = "terraform-google-modules/network/google"
  version = "10.0.0"
  # required_providers {
  #   google = {
  #     source  = "hashicorp/google"
  #     version = ">= 4.64, < 7"
  #   }
  #   google-beta = {
  #     source  = "hashicorp/google-beta"
  #     version = ">= 4.64, < 7"
  #   }
  # }

  # TODO: wait for fix release https://github.com/terraform-google-modules/terraform-google-network/pull/479
  # this bug will make properties on subnet won't take effect, like purpose

  project_id   = var.project
  network_name = var.network_name

  subnets = [
    {
      subnet_name           = local.subnet_name
      subnet_ip             = var.vpc_cidr
      subnet_region         = var.region
      subnet_private_access = "true"
    },
    {
      subnet_name   = local.psc_subnet_name
      subnet_ip     = var.psc_vpc_cidr
      subnet_region = var.region
      purpose       = "PRIVATE_SERVICE_CONNECT"
    },
  ]

  secondary_ranges = {
    (local.subnet_name) = [
      {
        range_name    = var.secondary_ip_range_pods_name
        ip_cidr_range = var.secondary_ip_range_pods
      },
      {
        range_name    = var.secondary_ip_range_services_name
        ip_cidr_range = var.secondary_ip_range_services
      },
    ]
  }
}

// TODO implement firewall rules for privateservice connect

module "cloud_router" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "6.3.0"
  # required_providers {
  #   google = {
  #     source  = "hashicorp/google"
  #     version = ">= 4.51, < 6"
  #   }
  # }

  project = var.project
  name    = "${var.network_name}-sn-router"
  network = module.network.network_name
  region  = var.region

  nats = [{
    name = var.nat_gateway_name
  }]
}
