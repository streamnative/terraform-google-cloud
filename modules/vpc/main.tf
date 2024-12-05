locals {
  subnet_name     = var.subnet_name != "" ? var.subnet_name : "${var.network_name}-${var.region}"
  psc_subnet_name = "${local.subnet_name}-psc"
}

module "network" {
  source  = "terraform-google-modules/network/google"
  version = ">= 4.1.0, < 7.2.0"
  # TODO: wait for fix release https://github.com/terraform-google-modules/terraform-google-network/pull/479
  # this bug will make properties on subnet won't take effect, like purpose

  project_id   = var.project
  network_name = var.network_name

  subnets = [
    {
      subnet_name           = local.subnet_name
      subnet_ip             = var.vpc_cidr
      subnet_region         = var.region
      subnet_private_access = "true"
    },
    {
      subnet_name   = local.psc_subnet_name
      subnet_ip     = var.psc_vpc_cidr
      subnet_region = var.region
      purpose       = "PRIVATE_SERVICE_CONNECT"
    },
  ]

  secondary_ranges = {
    (local.subnet_name) = [
      {
        range_name    = var.secondary_ip_range_pods_name
        ip_cidr_range = var.secondary_ip_range_pods
      },
      {
        range_name    = var.secondary_ip_range_services_name
        ip_cidr_range = var.secondary_ip_range_services
      },
    ]
  }
}

// TODO implement firewall rules for privateservice connect

module "cloud_router" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 5.0"

  project = var.project
  name    = "${var.network_name}-sn-router"
  network = module.network.network_name
  region  = var.region

  nats = [{
    name = "sn-nat-gateway"
  }]
}
