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

module "cert_manager_sa" {
  count   = var.enable_cert_manager ? 1 : 0
  source  = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  version = "20.0.0"

  use_existing_gcp_sa = true
  name                = google_service_account.preexisting.account_id
  project_id          = var.project_id

  use_existing_k8s_sa = true
  annotate_k8s_sa     = false
  k8s_sa_name         = "cert-manager-controller"
  namespace           = "kube-system"
  location            = var.region
  cluster_name        = module.gke.name
}

resource "helm_release" "cert_manager" {
  count           = var.enable_cert_manager ? 1 : 0
  atomic          = true
  chart           = var.cert_manager_helm_chart_name
  cleanup_on_fail = true
  name            = "cert-manager"
  namespace       = "kube-system"
  repository      = var.cert_manager_helm_chart_repository
  timeout         = 300
  version         = var.cert_manager_helm_chart_version
  values = [yamlencode({
    installCRDs = true
    controller = {
      args = [
        "--issuer-ambient-credentials=true"
      ]
      serviceAccount = {
        annotations = {
          "iam.gke.io/gcp-service-account" = google_service_account.preexisting.account_id
        }
      }
      podSecurityContext = {
        fsGroup = 65534
      }
    }
    kubeVersion = var.kubernetes_version

  })]
  dynamic "set" {
    for_each = var.cert_manager_settings
    content {
      name  = set.key
      value = set.value
    }
  }
}


resource "helm_release" "cert_issuer" {
  count           = var.enable_cert_manager ? 1 : 0
  atomic          = true
  chart           = "${path.module}/charts/cert-issuer"
  cleanup_on_fail = true
  name            = "cert-issuer"
  namespace       = kubernetes_namespace.sn_system.metadata[0].name
  timeout         = 300

  set {
    name  = "supportEmail"
    value = var.cert_issuer_support_email
  }

  set {
    name  = "dns01.cloudDNS.project"
    value = var.project_id
  }

  depends_on = [
    helm_release.cert_manager
  ]
}
