provider "google" {
  project = var.project
  region  = var.region
}

terraform {
  backend "s3" {}
  required_version = ">= 0.14.4"
}

resource "google_compute_network" "vpc" {
  name                    = var.name
  auto_create_subnetworks = true
}
