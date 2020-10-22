variable "project_id" {
  description = "The project ID to host the cluster in"
}

variable "region" {
  description = "The region to host the cluster in"
  default     = "asia-southeast1"
}

variable "cluster_name" {
  description = "The name of the cluster (required)"
}

variable "domain" {
  description = "The main DNS domain of system"
}

variable "zones" {
  type        = list(string)
  description = "The zone to host the cluster in (required if is a zonal cluster)"
  default     = ["asia-southeast1-a"]
}

variable "network" {
  description = "The VPC network name to host the cluster in"
}

variable "subnetwork" {
  description = "The VPC subnetwork name to host the cluster in"
}

variable "kubernetes_version" {
  description = "The Kubernetes version of the masters. If set to 'latest' it will pull latest available version in the selected region."
  default     = "1.15.12-gke.2"
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

variable "preemptible" {
  type        = bool
  description = "A boolean that represents whether or not the underlying node VMs are preemptible"
  default     = true
}