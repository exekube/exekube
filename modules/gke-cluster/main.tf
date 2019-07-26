# ------------------------------------------------------------------------------
# TERRAFORM / PROVIDER CONFIG
# ------------------------------------------------------------------------------

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "gcs" {}
}

# Keep non-beta provider to be backward compatible
provider "google" {
  project     = "${var.project_id}"
  credentials = "${var.serviceaccount_key}"
}

# Beta features will be available only in beta provider from 2.0
# https://www.terraform.io/docs/providers/google/provider_versions.html
provider "google-beta" {
  project     = "${var.project_id}"
  credentials = "${var.serviceaccount_key}"
}

# ------------------------------------------------------------------------------
# GOOGLE KUBERNTES ENGINE CLUSTER
# ------------------------------------------------------------------------------

# Check that only one of region and main_compute_zone is set
# This is to get a reasonable error message out of Terraform, however weird it
# might look like
resource "null_resource" "region_or_zone" {
  count                                                         = "${var.region != "" && var.main_compute_zone != "" ? 1 : 0}"
  "ERROR: Only one of region and main_compute_zone may be set." = true
}

resource "google_container_cluster" "cluster" {
  provider = "google-beta"
  count    = "${var.region == "" ? 1 : 0}"
  name     = "${var.cluster_name}"
  zone     = "${var.main_compute_zone}"

  additional_zones = "${var.additional_zones}"

  initial_node_count          = "${var.initial_node_count}"
  node_version                = "${var.kubernetes_version}"
  min_master_version          = "${var.kubernetes_version}"
  enable_kubernetes_alpha     = "${var.enable_kubernetes_alpha}"
  enable_binary_authorization = "${var.enable_binary_authorization}"
  enable_legacy_abac          = false
  network                     = "${var.network_name}"
  subnetwork                  = "nodes"

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  addons_config {
    horizontal_pod_autoscaling {
      disabled = false
    }

    kubernetes_dashboard {
      disabled = "${var.dashboard_disabled}"
    }

    http_load_balancing {
      disabled = "${var.http_load_balancing_disabled}"
    }

    network_policy_config {
      disabled = false
    }
  }

  monitoring_service = "${var.monitoring_service}"
  logging_service    = "${var.logging_service}"

  maintenance_policy {
    daily_maintenance_window {
      start_time = "03:00"
    }
  }

  node_config {
    machine_type = "${var.node_type}"
    disk_size_gb = 200
    oauth_scopes = "${var.oauth_scopes}"
    image_type   = "${var.node_image_type}"

    labels {
      project = "${var.project_id}"
      pool    = "default"
    }
  }

  network_policy {
    enabled  = true
    provider = "CALICO"
  }

  provisioner "local-exec" {
    command = <<EOF
gcloud auth activate-service-account --key-file ${var.serviceaccount_key} \
&& gcloud container clusters get-credentials ${var.cluster_name} \
--zone ${var.main_compute_zone} \
--project ${var.project_id} \
&& kubectl label ns kube-system name=kube-system \
&& kubectl create clusterrolebinding \
creator-cluster-admin-binding \
--clusterrole=cluster-admin \
--user=$(gcloud info --format='value(config.account)')
EOF
  }

  timeouts {
    create = "${var.create_timeout}"
    update = "${var.update_timeout}"
    delete = "${var.delete_timeout}"
  }
}

resource "google_container_cluster" "cluster-regional" {
  provider = "google-beta"
  count    = "${var.region == "" ? 0 : 1}"
  name     = "${var.cluster_name}"
  region   = "${var.region}"

  additional_zones = "${var.additional_zones}"

  initial_node_count          = "${var.initial_node_count}"
  node_version                = "${var.kubernetes_version}"
  min_master_version          = "${var.kubernetes_version}"
  enable_kubernetes_alpha     = "${var.enable_kubernetes_alpha}"
  enable_binary_authorization = "${var.enable_binary_authorization}"
  enable_legacy_abac          = false
  network                     = "${var.network_name}"
  subnetwork                  = "nodes"

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  addons_config {
    horizontal_pod_autoscaling {
      disabled = false
    }

    kubernetes_dashboard {
      disabled = "${var.dashboard_disabled}"
    }

    http_load_balancing {
      disabled = false
    }

    network_policy_config {
      disabled = false
    }
  }

  monitoring_service = "${var.monitoring_service}"
  logging_service    = "${var.logging_service}"

  maintenance_policy {
    daily_maintenance_window {
      start_time = "03:00"
    }
  }

  node_config {
    machine_type = "${var.node_type}"
    disk_size_gb = 200
    oauth_scopes = "${var.oauth_scopes}"
    image_type   = "${var.node_image_type}"

    labels {
      project = "${var.project_id}"
      pool    = "default"
    }
  }

  network_policy {
    enabled  = true
    provider = "CALICO"
  }

  master_auth {
    username = "${var.master_auth_username}"
    password = "${var.master_auth_password}"

    client_certificate_config {
      issue_client_certificate = "${var.issue_client_certificate}"
    }
  }

  master_auth {
    username = "${var.master_auth_username}"
    password = "${var.master_auth_password}"

    client_certificate_config {
      issue_client_certificate = "${var.issue_client_certificate}"
    }
  }

  provisioner "local-exec" {
    command = <<EOF
gcloud auth activate-service-account --key-file ${var.serviceaccount_key} \
&& gcloud container clusters get-credentials ${var.cluster_name} \
--region ${var.region} \
--project ${var.project_id} \
&& kubectl label ns kube-system name=kube-system \
&& kubectl create clusterrolebinding \
creator-cluster-admin-binding \
--clusterrole=cluster-admin \
--user=$(gcloud info --format='value(config.account)')
EOF
  }

  timeouts {
    create = "${var.create_timeout}"
    update = "${var.update_timeout}"
    delete = "${var.delete_timeout}"
  }
}
