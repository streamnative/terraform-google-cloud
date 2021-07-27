terraform {
  required_version = ">=1.0.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.76.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.2.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region = var.region
}

provider "helm" {
  kubernetes {
    host                   = format("https://%s", data.google_container_cluster.cluster.endpoint)
    cluster_ca_certificate = base64decode(data.google_container_cluster.cluster.master_auth[0].cluster_ca_certificate)
  }
}

provider "kubernetes" {
  host                   = format("https://%s", data.google_container_cluster.cluster.endpoint)
  cluster_ca_certificate = base64decode(data.google_container_cluster.cluster.master_auth[0].cluster_ca_certificate)
  token                  = data.google_client_config.provider.access_token
}

data "google_client_config" "provider" {}

data "google_container_cluster" "cluster" {
  name     = module.sn_cluster.gke_cluster_name
}

resource "random_pet" "cluster_name" {
  length = 1
}

locals {
  cluster_name = format("sn-gke-%s-%s", random_pet.cluster_name.id, var.environment)
}

variable "environment" {
  default = "test"
}

variable "project_id" {
}

variable "region" {
  default = "us-central1"
}

module "sn_cluster" {
  source = "../terraform-google-cloud_gke_module"

  cluster_location = var.region
  cluster_name = local.cluster_name
  project_id = var.project_id
}