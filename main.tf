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

module "sn_cluster" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  name    = var.cluster_name
  version = "15.0.2"

  add_cluster_firewall_rules        = var.add_cluster_firewall_rules
  add_master_webhook_firewall_rules = var.add_master_webhook_firewall_rules
  add_shadow_firewall_rules         = var.add_shadow_firewall_rules
  cluster_autoscaling               = var.cluster_autoscaling_config
  http_load_balancing               = var.cluster_http_load_balancing
  ip_range_pods                     = var.create_cluster_subnet ? google_compute_subnetwork.cluster_subnet[0].secondary_ip_range[0].range_name : null
  ip_range_services                 = var.create_cluster_subnet ? google_compute_subnetwork.cluster_subnet[0].secondary_ip_range[1].range_name : null
  network                           = var.use_default_vpc ? "default" : var.vpc_network
  network_policy                    = var.cluster_network_policy
  node_pools                        = [ local.node_pools ]
  project_id                        = var.project_id
  region                            = var.cluster_location
  subnetwork                        = var.use_default_vpc ? "default" : var.vpc_subnet
}
