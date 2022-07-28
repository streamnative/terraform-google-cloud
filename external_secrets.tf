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
  source  = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  version = "20.0.0"

  use_existing_k8s_sa = true
  annotate_k8s_sa     = false
  k8s_sa_name         = "external-secrets"
  location            = var.region
  cluster_name        = module.gke.name
  name                = format("external-secrets-%s", var.suffix)
  namespace           = "kube-system"
  project_id          = var.project_id
  roles               = ["roles/secretmanager.secretAccessor"]
}

resource "helm_release" "external_secrets" {
  count           = var.enable_external_secrets ? 1 : 0
  atomic          = true
  chart           = var.external_secrets_helm_chart_name
  cleanup_on_fail = true
  namespace       = "kube-system"
  name            = "external-secrets"
  repository      = var.external_secrets_helm_chart_repository
  timeout         = 300
  version         = var.external_secrets_helm_chart_version
  values = [yamlencode({
    securityContext = {
      fsGroup = 65534
    }
    serviceAccount = {
      annotations = {
        "iam.gke.io/gcp-service-account" = module.external_secrets_sa.gcp_service_account_email
      }
      name = "external-secrets"
    }
  })]

  dynamic "set" {
    for_each = var.external_secrets_settings
    content {
      name  = set.key
      value = set.value
    }
  }
}
