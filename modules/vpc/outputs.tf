output "id" {
  value = google_compute_network.vpc.id
}

output "gateway_ipv4" {
  value = google_compute_network.vpc.gateway_ipv4
}

output "project" {
  value = var.project
}

output "region" {
  value = var.region
}

output "self_link" {
  value = google_compute_network.vpc.self_link
}
