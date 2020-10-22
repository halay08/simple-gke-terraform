/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

terraform {
  backend "gcs" {
    bucket = "gke-tf-state"
    prefix = "terraform/state"
  }
}

locals {
  cluster_type = "node-pool"
  subnet_01    = "${var.network_name}-01"
  subnet_02    = "${var.network_name}-02"
}

provider "google-beta" {
  version = "~> 3.35.0"
  region  = var.region
}

module "vpc" {
  source       = "github.com/terraform-google-modules/terraform-google-network"
  project_id   = var.project_id
  network_name = var.network_name

  subnets = [
    {
      subnet_name   = "${local.subnet_01}"
      subnet_ip     = cidrsubnet("${var.network_primary_cidr_range}", 1, 0)
      subnet_region = var.region
    },
    {
      subnet_name   = "${local.subnet_02}"
      subnet_ip     = cidrsubnet("${var.network_primary_cidr_range}", 1, 1)
      subnet_region = var.region
    }
  ]

  secondary_ranges = {
    "${local.subnet_01}" = [
      {
        range_name    = "${local.subnet_01}-secondary-01"
        ip_cidr_range = cidrsubnet("${var.network_secondary_cidr_range}", 1, 0)
      },
      {
        range_name    = "${local.subnet_01}-secondary-02"
        ip_cidr_range = cidrsubnet("${var.network_secondary_cidr_range}", 1, 1)
      }
    ]
  }
}

module "gke_custom" {
  source = "./modules/gke"

  project_id         = var.project_id
  cluster_name       = var.cluster_name
  region             = var.region
  zones              = var.zones
  network            = "${module.vpc.network_name}"
  subnetwork         = "${module.vpc.subnets_names[0]}"
  kubernetes_version = var.kubernetes_version
  instance_type      = var.instance_type
  min_node_count     = var.min_node_count
  max_node_count     = var.max_node_count
  initial_node_count = var.initial_node_count
  disk_size          = var.disk_size
  preemptible        = var.preemptible
  domain             = var.domain
}

data "google_client_config" "default" {
}
