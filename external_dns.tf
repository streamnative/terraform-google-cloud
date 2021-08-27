module "external_dns_sa" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  version = "16.1.0"

  use_existing_k8s_sa = true
  annotate_k8s_sa     = false
  name                = "external-dns"
  namespace           = "kube-system"
  project_id          = var.project_id
  roles               = ["roles/dns.admin"]
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

  dynamic "set" {
    for_each = var.external_dns_domain_filters
    content {
      name  = join("", ["domainFilters[", set.key, "]"])
      value = set.value
    }
  }

  set {
    name  = "google.project"
    value = var.project_id
  }

  set {
    name  = "policy"
    value = var.external_dns_policy
  }

  set {
    name  = "podSecurityContext.fsGroup"
    value = "65534"
  }

  set {
    name  = "podSecurityContext.runAsUser"
    value = "65534"
  }

  set {
    name  = "provider"
    value = "google"
  }

  set {
    name  = "serviceAccount.annotations.iam\\.gke\\.io\\/gcp\\-service\\-account"
    value = module.external_dns_sa.gcp_service_account_email
  }

  set {
    name  = "serviceAccount.name"
    value = "external-dns"
  }

  set {
    name  = "sources"
    value = var.disable_istio_sources == true ? "{service,ingress}" : "{service,ingress,istio-gateway,istio-virtualservice}"
  }

  set {
    name  = "txtOwnerId"
    value = module.gke.name
  }

  dynamic "set" {
    for_each = var.external_dns_settings
    content {
      name  = set.key
      value = set.value
    }
  }
}
