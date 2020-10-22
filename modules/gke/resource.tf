provider "kubernetes" {
  load_config_file       = false
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}


locals {
  subnet_01    = "${var.network}-01"
  subnet_02    = "${var.network}-02"
  namespaces   = [
    "traefik",
    "develop",
    "staging",
    "production",
    "cert-manager"
  ]
  kubeconfig = "${path.root}/generated/kubeconfig"
}

module "gke" {
  source                            = "terraform-google-modules/kubernetes-engine/google"
  project_id                        = "${var.project_id}"
  name                              = "${var.cluster_name}"
  region                            = "${var.region}"
  zones                             = "${var.zones}"
  network                           = "${var.network}"
  subnetwork                        = "${var.subnetwork}"
  ip_range_pods                     = "${local.subnet_01}-secondary-01"
  ip_range_services                 = "${local.subnet_01}-secondary-02"
  create_service_account            = true
  remove_default_node_pool          = true
  disable_legacy_metadata_endpoints = true
  http_load_balancing               = true
  horizontal_pod_autoscaling        = true
  network_policy                    = true
  kubernetes_version                = "${var.kubernetes_version}"

  node_pools = [
    {
      name               = "default-pool"
      node_locations     = "${var.region}-b,${var.region}-c"
      machine_type       = "${var.instance_type}"
      min_count          = "${var.min_node_count}"
      max_count          = "${var.max_node_count}"
      initial_node_count = "${var.initial_node_count}"
      local_ssd_count    = 0
      disk_size_gb       = "${var.disk_size}"
      disk_type          = "pd-standard"
      image_type         = "COS"
      preemptible        = "${var.preemptible}"
      auto_repair        = true
      auto_upgrade       = true
    },
  ]

  node_pools_metadata = {
    default-pool = {
      shutdown-script = file("${path.module}/data/shutdown-script.sh")
    }
  }
}

# Get the credentials 
# module "gke_auth" {
#   source           = "terraform-google-modules/kubernetes-engine/google//modules/auth"

#   project_id       = "${var.project_id}"
#   cluster_name     = "${var.cluster_name}"
#   location         = "${module.gke.location}"

#   depends_on = [module.gke]
# }

# Create all namespaces
resource "kubernetes_namespace" "namespaces" {
  count = length(local.namespaces)
  metadata {
    name          = local.namespaces[count.index]
  }

  depends_on = [module.gke]
}

# resource "local_file" "kubeconfig" {
#   content  = module.gke_auth.kubeconfig_raw
#   filename = local.kubeconfig
# }

resource "null_resource" "get_credentials" {
  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${var.cluster_name} --region ${var.region} --project ${var.project_id}"
  }

  depends_on = [module.gke]
}

resource "null_resource" "kubeconfig" {
  provisioner "local-exec" {
    command = <<LOCAL_EXEC
export KUBECONFIG="${path.root}/generated/kubeconfig"

kubectl config set-context "${var.cluster_name}_traefik" --namespace=traefik \
   --cluster=gke_${var.project_id}_${var.region}_${var.cluster_name} \
   --user=gke_${var.project_id}_${var.region}_${var.cluster_name}
 
kubectl config set-context "${var.cluster_name}_dev" --namespace=develop \
   --cluster=gke_${var.project_id}_${var.region}_${var.cluster_name} \
   --user=gke_${var.project_id}_${var.region}_${var.cluster_name}

kubectl config set-context "${var.cluster_name}_stg" --namespace=staging \
   --cluster=gke_${var.project_id}_${var.region}_${var.cluster_name} \
   --user=gke_${var.project_id}_${var.region}_${var.cluster_name}

kubectl config set-context "${var.cluster_name}_prod" --namespace=production \
   --cluster=gke_${var.project_id}_${var.region}_${var.cluster_name} \
   --user=gke_${var.project_id}_${var.region}_${var.cluster_name}

kubectl config set-context "${var.cluster_name}_cert" --namespace=cert-manager \
   --cluster=gke_${var.project_id}_${var.region}_${var.cluster_name} \
   --user=gke_${var.project_id}_${var.region}_${var.cluster_name}

kubectl config use-context ${var.cluster_name}_dev
LOCAL_EXEC
  }

  depends_on = [
    module.gke,
    null_resource.get_credentials,
    kubernetes_namespace.namespaces
  ]
}

data "google_client_config" "default" {
}

resource "google_compute_global_address" "default" {
  name = "global-${var.cluster_name}-ip"
  project = var.project_id
}