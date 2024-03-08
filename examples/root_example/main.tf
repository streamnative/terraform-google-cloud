# Copyright 2023 StreamNative, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

terraform {
  required_version = ">=1.0.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>5.19"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.19"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.27.0"
    }
  }
}

module "sn_crds" {
  source  = "streamnative/charts/helm//modules/crds"
  version = "v0.8.4"

  depends_on = [
    module.sn_cluster
  ]
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
variable "environment" {
  default     = "example"
  description = ""
}

variable "project_id" {
  description = "GCP project to deploy into"
}

variable "region" {
  default     = "northamerica-northeast1"
  description = "GCP region to deploy in"
}

variable "domain" {
  default     = "g.example.dev."
  description = "Google DNS domain for DNS records"
}

data "google_client_config" "provider" {}

data "google_container_cluster" "cluster" {
  name     = module.sn_cluster.name
  location = var.region
}

resource "random_pet" "cluster_name" {
  length = 1
}

locals {
  organization   = "streamnative"
  cluster_name   = format("sn-%s-%s", random_pet.cluster_name.id, var.environment)
  service_domain = format("%s.%s.%s", local.cluster_name, local.organization, var.domain)
}

data "google_container_engine_versions" "versions" {
  location       = var.region
  version_prefix = "1.21."
}

# Add this repo as a git submodule and refer to its relative path (or clone and point to the location)
module "sn_cluster" {
  source = "../../"

  cluster_name       = local.cluster_name
  enable_func_pool   = false
  kubernetes_version = data.google_container_engine_versions.versions.latest_master_version

  project_id  = var.project_id
  region      = var.region
  suffix      = random_pet.cluster_name.id
  vpc_network = "default"
  vpc_subnet  = "default"
}

# Note: If the func pool is enabled, you must wait for the cluster to be ready before running this module
module "sn_bootstrap" {
  source  = "streamnative/charts/helm"
  version = "0.8.4"

  # Note: OLM for GKE is still a WIP as we work on a long term solution for managing our operator images
  enable_olm   = true
  olm_registry = "gcr.io/affable-ray-226821/streamnative/pulsar-operators/registry/pulsar-operators:production"

  depends_on = [
    module.sn_cluster
  ]
}
