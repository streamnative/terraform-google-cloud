output "network" {
  value = module.network.network_name
}

output "subnet_name" {
  value = module.network.subnets_names[0]
}

output "psc_subnet_name" {
  value = local.psc_subnet_name
}

output "secondary_ip_range_pods" {
  value = var.secondary_ip_range_pods
}

output "secondary_ip_range_pods_name" {
  value = var.secondary_ip_range_pods_name
}

output "secondary_ip_range_services" {
  value = var.secondary_ip_range_services
}

output "secondary_ip_range_services_name" {
  value = var.secondary_ip_range_services_name
}
