output "ca_certificate" {
  value = module.gke.ca_certificate
}

output "endpoint" {
  value = module.gke.endpoint
}

output "id" {
  value = module.gke.cluster_id
}

output "name" {
  value = module.gke.name
}

output "master_version" {
  value = module.gke.master_version
}

output "service_account" {
  value = module.gke.service_account
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
