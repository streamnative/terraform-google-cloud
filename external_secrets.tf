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

module "external_secrets_sa" {
  count   = var.enable_external_secrets ? 1 : 0
  source  = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  version = "16.1.0"

  use_existing_k8s_sa = true
  annotate_k8s_sa     = false
  name                = "external-secrets"
  namespace           = "sn-system"
  project_id          = var.project_id
  roles               = ["roles/secretmanager.secretAccessor"]
}

resource "helm_release" "external_secrets" {
  count           = var.enable_external_secrets ? 1 : 0
  atomic          = true
  chart           = var.external_secrets_helm_chart_name
  cleanup_on_fail = true
  namespace       = join("", kubernetes_namespace.sn_system.*.id)
  name            = "external-secrets"
  repository      = var.external_secrets_helm_chart_repository
  timeout         = 300
  version         = var.external_secrets_helm_chart_version

  set {
    name  = "securityContext.fsGroup"
    value = "65534"
  }

  set {
    name  = "serviceAccount.annotations.iam\\.gke\\.io\\/gcp\\-service\\-account"
    value = module.external_secrets_sa[0].gcp_service_account_email
  }

  set {
    name  = "serviceAccount.name"
    value = "external-secrets"
  }

  dynamic "set" {
    for_each = var.external_secrets_settings
    content {
      name  = set.key
      value = set.value
    }
  }
}