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

variable "project_id" {
  description = "The project ID to host the cluster in"
}

variable "cluster_name_suffix" {
  description = "A suffix to append to the default cluster name"
  default     = ""
}

variable "cluster_name" {
  description = "The name of the cluster (required)"
}

variable "kubernetes_version" {
  description = "The Kubernetes version of the masters. If set to 'latest' it will pull latest available version in the selected region."
  default     = "1.15.12-gke.2"
}

variable "domain" {
  description = "The main DNS domain of system"
}

variable "instance_type" {
  description = "Instance type of node"
  default     = "n1-standard-2"
}

variable "min_node_count" {
  description = "The min node count of Node Pool"
  default     = 0
}

variable "max_node_count" {
  description = "The max node count of Node Pool"
  default     = 6
}

variable "initial_node_count" {
  description = "The number of nodes to create in this cluster's default node pool."
  default     = 2
}

variable "disk_size" {
  description = "Size of the disk attached to each node, specified in GB. The smallest allowed disk size is 10GB"
  default     = 50
}

variable "node_count" {
  description = "The number of nodes in the nodepool when autoscaling is false. Otherwise defaults to 1. Only valid for non-autoscaling clusers"
  default     = 2
}

variable "preemptible" {
  type        = bool
  description = "A boolean that represents whether or not the underlying node VMs are preemptible"
  default     = true
}

variable "region" {
  description = "The region to host the cluster in"
  default     = "asia-southeast1"
}

variable "zones" {
  type        = list(string)
  description = "The zone to host the cluster in (required if is a zonal cluster)"
  default     = ["asia-southeast1-a"]
}

variable "network_primary_cidr_range" {
  description = "Primary CIDR range of VPC network"
  default     = "10.10.10.0/16"
}

variable "network_secondary_cidr_range" {
  description = "Secondary CIDR range of VPC network"
  default     = "192.168.1.0/16"
}

variable "network_name" {
  description = "The VPC network name to host the cluster in"
}

variable "subnetwork_count" {
  description = "Total of sub-network will be created in VPC"
  default     = 1
}

variable "cluster_autoscaling" {
  type = object({
    enabled             = bool
    autoscaling_profile = string
    min_cpu_cores       = number
    max_cpu_cores       = number
    min_memory_gb       = number
    max_memory_gb       = number
  })
  default = {
    enabled             = false
    autoscaling_profile = "BALANCED"
    max_cpu_cores       = 0
    min_cpu_cores       = 0
    max_memory_gb       = 0
    min_memory_gb       = 0
  }
  description = "Cluster autoscaling configuration. See [more details](https://cloud.google.com/kubernetes-engine/docs/reference/rest/v1beta1/projects.locations.clusters#clusterautoscaling)"
}