module "cert_manager_sa" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  version = "16.1.0"

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

  set {
    name  = "installCRDs"
    value = true
  }

  set {
    name  = "extraArgs[0]"
    value = "--issuer-ambient-credentials=true"
  }

  set {
    name  = "controller.serviceAccount.annotations.iam\\.gke\\.io\\/gcp\\-service\\-account"
    value = module.cert_manager_sa.gcp_service_account_email
  }

  dynamic "set" {
    for_each = var.cert_manager_settings
    content {
      name  = set.key
      value = set.value
    }
  }
}
