#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

data "google_compute_zones" "available" {}

locals {

  ### Node Pools
  default_node_pool_config = {
    auto_repair        = var.node_pool_auto_repair
    auto_upgrade       = var.node_pool_auto_upgrade
    autoscaling        = var.node_pool_autoscaling
    disk_size_gb       = var.node_pool_disk_size
    disk_type          = var.node_pool_disk_type
    image_type         = var.node_pool_image_type
    initial_node_count = var.node_pool_autoscaling_initial_count
    local_ssd_count    = var.node_pool_ssd_count
    machine_type       = var.node_pool_machine_type
    max_count          = var.node_pool_autoscaling_max_size
    min_count          = var.node_pool_autoscaling_min_size
    name               = var.node_pool_name
    node_count         = var.node_pool_autoscaling ? null : var.node_pool_count
    node_locations     = var.node_pool_locations != "" ? var.node_pool_locations : ""
    service_account    = var.create_service_account ? "" : var.node_pool_service_account
    version            = var.node_pool_auto_upgrade ? null : var.node_pool_version
  }
  func_pool_config = {
    auto_repair        = var.func_pool_auto_repair
    auto_upgrade       = var.func_pool_auto_upgrade
    autoscaling        = var.func_pool_autoscaling
    disk_size_gb       = var.func_pool_disk_size
    disk_type          = var.func_pool_disk_type
    image_type         = var.func_pool_image_type
    initial_node_count = var.func_pool_autoscaling_initial_count
    local_ssd_count    = var.func_pool_ssd_count
    machine_type       = var.func_pool_machine_type
    max_count          = var.func_pool_autoscaling_max_size
    min_count          = var.func_pool_autoscaling_min_size
    name               = var.func_pool_name
    node_count         = var.func_pool_autoscaling ? null : var.func_pool_count
    node_locations     = var.func_pool_locations != "" ? var.func_pool_locations : var.node_pool_locations
    service_account    = var.create_service_account ? "" : var.func_pool_service_account
    version            = var.func_pool_auto_upgrade ? null : var.func_pool_version
  }
  node_pools = var.enable_func_pool ? [local.default_node_pool_config, local.func_pool_config] : [local.default_node_pool_config]
  node_pools_labels = {
    all = {
      cluster_name = var.cluster_name
      managed_by   = "terraform"
    }
  }
  node_pools_metadata = {
    all = {}
  }
  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/ndev.clouddns.readwrite",
    ]
  }

  node_pools_taints = {
    all = []

    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]

    func-pool = [
      {
        key    = "func-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }
}
