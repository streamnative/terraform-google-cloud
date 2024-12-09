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

locals {
  dns_zone_name = try(data.google_dns_managed_zone.sn[0].dns_name, "")
  new_zone_name = "${var.pm_name}.${local.dns_zone_name}"
  new_zone_id   = var.pm_name
  zone_name     = var.custom_dns_zone_name != "" ? var.custom_dns_zone_name : try(google_dns_managed_zone.zone[0].dns_name, "")
  zone_id       = var.custom_dns_zone_id != "" ? var.custom_dns_zone_id : try(google_dns_managed_zone.zone[0].name, "")
}

resource "google_dns_managed_zone" "zone" {
  count    = var.custom_dns_zone_id == "" ? 1 : 0
  provider = google.target

  name          = local.new_zone_id
  dns_name      = local.new_zone_name
  force_destroy = true

  cloud_logging_config {
    enable_logging = false
  }
}

data "google_dns_managed_zone" "sn" {
  count    = var.custom_dns_zone_id == "" ? 1 : 0
  provider = google.source

  name = var.parent_zone_name
}

resource "google_dns_record_set" "delegate" {
  count    = var.custom_dns_zone_id == "" ? 1 : 0
  provider = google.source

  managed_zone = data.google_dns_managed_zone.sn[0].name
  name         = google_dns_managed_zone.zone[0].dns_name
  type         = "NS"
  ttl          = "300"
  rrdatas      = google_dns_managed_zone.zone[0].name_servers
}
