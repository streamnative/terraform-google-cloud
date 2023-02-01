output "ca_certificate" {
  value = var.autopilot == false ? module.gke[0].ca_certificate : module.gke_autopilot[0].ca_certificate
}

output "endpoint" {
  value = var.autopilot == false ? module.gke[0].endpoint : module.gke_autopilot[0].endpoint
}

output "id" {
  value = var.autopilot == false ? module.gke[0].cluster_id : module.gke_autopilot[0].cluster_id
}

output "name" {
  value = local.gke_cluster_name
}

output "master_version" {
  value = var.autopilot == false ? module.gke[0].master_version : module.gke_autopilot[0].master_version
}

output "service_account" {
  value = var.autopilot == false ? module.gke[0].service_account : module.gke_autopilot[0].service_account
}

output "cert_manager_sa_email" {
  value = module.cert_manager_sa.gcp_service_account_email
}

output "external_dns_manager_sa_email" {
  value = module.external_dns_sa.gcp_service_account_email
}

output "external_secrets_sa_email" {
  value = module.external_secrets_sa.gcp_service_account_email
}
