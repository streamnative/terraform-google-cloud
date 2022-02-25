module "cert_manager_sa" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  version = "19.0.0"

  use_existing_k8s_sa = true
  annotate_k8s_sa     = false
  name                = "cert-manager-controller"
  namespace           = "kube-system"
  project_id          = var.project_id
  roles               = ["roles/dns.admin"]
}

resource "helm_release" "cert_manager" {
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
          "controller.serviceAccount.annotations.iam.gke.io/gcp-service-account" = module.cert_manager_sa.gcp_service_account_email
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
    name  = "dns01.region"
    value = var.region
  }

  depends_on = [
    helm_release.cert_manager
  ]
}