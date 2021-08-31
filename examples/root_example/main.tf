#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

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

# Configure variable defaults here, with a .tfvars file, or provide them to terraform when prompted.
variable "environment" {}
variable "project_id" {}
variable "region" {}

data "google_client_config" "provider" {}

data "google_container_cluster" "cluster" {
  name     = module.sn_cluster.gke_cluster_name
  location = var.region
}

resource "random_pet" "cluster_name" {
  length = 1
}

locals {
  cluster_name = format("sn-%s-%s", random_pet.cluster_name.id, var.environment)
}

module "sn_cloud_dns" {
  source  = "terraform-google-modules/cloud-dns/google"
  version = "3.1.0"

  domain     = "g.example.dev."
  name       = local.cluster_name
  project_id = var.project_id
  type       = "public"
}

# Add this repo as a git submodule and refer to its relative path (or clone and point to the location)
module "sn_cluster" {
  source = "../terraform-google-cloud" 

  cluster_location            = var.region
  cluster_name                = local.cluster_name
  create_cluster_subnet       = false
  enable_func_pool            = false
  external_dns_domain_filters = [module.sn_cloud_dns.domain]
  project_id                  = var.project_id
}

# Note: If the func pool is enabled, you must wait for the cluster to be ready before running this module
module "sn_bootstrap" {
  source = "streamnative/charts/helm"
  version = "0.4.0"

  # Note: OLM for GKE is still a WIP as we work on a long term solution for managing our operator images
  enable_olm               = true
  olm_registry             = "gcr.io/affable-ray-226821/streamnative/pulsar-operators/registry/pulsar-operators:production"

  depends_on = [
    module.sn_cluster
  ]
}