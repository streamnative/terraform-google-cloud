module "external_dns_sa" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  version = "19.0.0"

  use_existing_k8s_sa = true
  annotate_k8s_sa     = false
  name                = "external-dns"
  namespace           = "kube-system"
  project_id          = var.project_id
  roles               = ["roles/dns.admin"]
}

locals {
  default_sources = ["service", "ingress"]
  istio_sources   = ["istio-gateway", "istio-virtualservice"]
  sources         = var.enable_istio ? concat(local.istio_sources, local.default_sources) : local.default_sources
}

resource "helm_release" "external_dns" {
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
        "serviceAccount.annotations.iam.gke.io/gcp-service-account" = module.external_dns_sa.gcp_service_account_email
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
