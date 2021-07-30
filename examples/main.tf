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
  region  = var.region
}

provider "helm" {
  kubernetes {
    host                   = format("https://%s", data.google_container_cluster.cluster.endpoint)
    cluster_ca_certificate = base64decode(data.google_container_cluster.cluster.master_auth[0].cluster_ca_certificate)
    token                  = data.google_client_config.provider.access_token
  }
}

provider "kubernetes" {
  host                   = format("https://%s", data.google_container_cluster.cluster.endpoint)
  cluster_ca_certificate = base64decode(data.google_container_cluster.cluster.master_auth[0].cluster_ca_certificate)
  token                  = data.google_client_config.provider.access_token
}

data "google_client_config" "provider" {}

data "google_container_cluster" "cluster" {
  name     = module.my_cluster.gke_cluster_name
  location = var.region
}

resource "random_pet" "cluster_name" {
  length = 1
}

locals {
  cluster_name = format("sn-%s-%s", random_pet.cluster_name.id, var.environment)
}

variable "environment" {
  default = "test"
}

variable "project_id" {
  default = "sncloud-dev-joey"
}

variable "region" {
  default = "us-central1"
}

module "my_cluster" {
  source = "../terraform-google-cloud"

  cluster_location          = var.region
  cluster_name              = local.cluster_name
  create_cluster_subnet     = false
  disable_olm               = false
  enable_function_node_pool = true
  project_id                = var.project_id
  pulsar_namespace          = "pulsar-demo"

  olm_sn_image = "598203581484.dkr.ecr.us-east-1.amazonaws.com/streamnative/pulsar-operators/registry/pulsar-operators:production"

}