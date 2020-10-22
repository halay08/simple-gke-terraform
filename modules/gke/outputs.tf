output "cluster_lp_ip_addr" {
  value = "${google_compute_global_address.default}"
}

output "cluster_endpoint" {
  value = "https://${module.gke.endpoint}"
}

output "cluster_access_token" {
  value = "${data.google_client_config.default.access_token}"
}

output "cluster_ca_certificate" {
  value = "${base64decode(module.gke.ca_certificate)}"
}