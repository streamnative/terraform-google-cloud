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

### This module shows how you can enable the required Google Cloud APIs within your Google Cloud Project.
### The following APIs are required to be enabled before running the GKE module
### If you use this module, it is recommended that it runs in a seperate scope "beneath" any resources that depend on it.
module "project_services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "11.1.1"

  project_id = var.project_id

  activate_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "dns.googleapis.com",
    "iam.googleapis.com"
  ]
}