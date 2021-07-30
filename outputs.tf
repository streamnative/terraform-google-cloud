output "gke_cluster_endpoint" {
  value = module.gke.endpoint
}

output "gke_cluster_id" {
  value = module.gke.name
}

output "gke_cluster_name" {
  value = module.gke.name
}

output "gke_cluster_master_version" {
  value = module.gke.master_version
}

# output "gke_cluster_node_pool_names" {
#   value = module.gke.node_pool_names
# }

# output "gke_cluster_node_pool_versions" {
#   value = module.gke.node_pool_versions
# }

output "gke_cluster_service_account" {
  value = module.gke.service_account
}