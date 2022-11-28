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


