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

module "external_dns_workload_identity" {
  count               = var.enable_external_dns ? 1 : 0
  source              = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  version             = "20.0.0"

  use_existing_gcp_sa = true
  gcp_sa_name         = var.google_service_account
  project_id          = var.project_id

  use_existing_k8s_sa = true
  annotate_k8s_sa     = false
  k8s_sa_name         = "external-dns"
  namespace           = "kube-system"
  location            = var.region
  cluster_name        = module.gke.name
}

locals {
  default_sources = ["service", "ingress"]
  istio_sources   = ["istio-gateway", "istio-virtualservice"]
  sources         = var.enable_istio ? concat(local.istio_sources, local.default_sources) : local.default_sources
}

resource "helm_release" "external_dns" {
  count           = var.enable_external_dns ? 1 : 0
  atomic          = true
  chart           = var.external_dns_helm_chart_name
  cleanup_on_fail = true
  name            = "external-dns"
  namespace       = "kube-system"
  repository      = var.external_dns_helm_chart_repository
  timeout         = 300
  version         = var.external_dns_helm_chart_version
  values = [yamlencode({
    google = {
      project = var.project_id
    }
    policy = var.external_dns_policy
    podSecurityContext = {
      fsGroup   = 65534
      runAsUser = 0
    }
    provider = "google"
    rbac = {
      create = true
    }
    serviceAccount = {
      create = true
      name   = "external-dns"
      annotations = {
        "iam.gke.io/gcp-service-account" = var.google_service_account
      }
    }
    sources    = local.sources
    txtOwnerId = module.gke.name
  })]

  dynamic "set" {
    for_each = var.external_dns_settings
    content {
      name  = set.key
      value = set.value
    }
  }
}
