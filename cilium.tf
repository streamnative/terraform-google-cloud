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

variable "enable_cilium" {
  default     = false
  description = "Enables Cilium on the cluster. Set to \"false\" by default."
  type        = bool
}

variable "cilium_helm_chart_name" {
  default     = "cilium"
  description = "The name of the Helm chart in the repository for Cilium."
  type        = string
}

variable "cilium_helm_chart_repository" {
  default     = "https://helm.cilium.io"
  description = "The repository containing the Cilium helm chart."
  type        = string
}

variable "cilium_helm_chart_version" {
  default     = "1.13.2"
  description = "Helm chart version for Cilium. See https://artifacthub.io/packages/helm/cilium/cilium for updates."
  type        = string
}

resource "helm_release" "cilium" {
  count           = (var.enable_resource_creation && var.enable_cilium) ? 1 : 0
  name            = "cilium"
  namespace       = "kube-system"
  repository      = var.cilium_helm_chart_repository
  chart           = var.cilium_helm_chart_name
  version         = var.cilium_helm_chart_version
  atomic          = false
  cleanup_on_fail = false
  timeout         = 60

  // these values were generated by "cilium install"
  values = [yamlencode({
    cluster = {
      id   = 0
      name = var.cluster_name
    }
    cni = {
      binPath = "/home/kubernetes/bin"
    }
    enableIPv4Masquerade = false
    enableIPv6Masquerade = false
    encryption = {
      nodeEncryption = false
    }
    gke = {
      disableDefaultSnat = false
      enabled            = true
    }
    hubble = {
      enabled = false
    }
    ipam = {
      mode = "kubernetes"
    }
    ipv4NativeRoutingCIDR = var.secondary_ip_range_pods
    kubeProxyReplacement  = "disabled"
    logOptions = {
      format = "json"
    }
    nodeinit = {
      enabled            = true
      reconfigureKubelet = true
      removeCbrBridge    = true
    }
    operator = {
      replicas = 1
    }
    serviceAccounts = {
      cilium = {
        name = "cilium"
      }
      operator = {
        name = "cilium-operator"
      }
    }
  })]

  lifecycle {
    precondition {
      condition     = !var.enable_cilium || var.cluster_network_policy == false
      error_message = "Cilium is incompatible with GKE built-in network policy"
    }
  }
}
