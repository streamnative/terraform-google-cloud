output "gke_cluster_endpoint" {
  value = module.sn_cluster.endpoint
}

output "gke_cluster_id" {
  value = module.sn_cluster.name
}

output "gke_cluster_name" {
  value = module.sn_cluster.name
}

output "gke_cluster_master_version" {
  value = module.sn_cluster.master_version
}

# output "gke_cluster_node_pool_names" {
#   value = module.sn_cluster.node_pool_names
# }

# output "gke_cluster_node_pool_versions" {
#   value = module.sn_cluster.node_pool_versions
# }

output "gke_cluster_service_account" {
  value = module.sn_cluster.service_account
}