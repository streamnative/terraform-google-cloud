data "google_compute_network" "default" {
  name = "default"
}

resource "google_compute_subnetwork" "cluster_subnet" {
  count         = var.use_default_vpc && var.create_cluster_subnet ? 1 : 0
  name          = format("gke-%s-%s-subnet", var.cluster_name, var.cluster_location)
  ip_cidr_range = var.cluster_subnet_cidr
  region        = var.cluster_location
  network       = data.google_compute_network.default.id

  secondary_ip_range {
    range_name    = format("gke-%s-%s-pods", var.cluster_name, var.cluster_location)
    ip_cidr_range = var.cluster_subnet_pods_cidr
  }

  secondary_ip_range {
    range_name    = format("gke-%s-%s-services", var.cluster_name, var.cluster_location)
    ip_cidr_range = var.cluster_subnet_services_cidr
  }
}