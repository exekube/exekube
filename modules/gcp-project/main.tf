# ------------------------------------------------------------------------------
# TERRAFORM REMOTE STATE BACKEND
# ------------------------------------------------------------------------------

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "gcs" {}
}

# ------------------------------------------------------------------------------
# TERRAFORM PROVIDERS
# ------------------------------------------------------------------------------

provider "random" {}

provider "google" {
  credentials = "${var.terraform_credentials}"
}

# ------------------------------------------------------------------------------
# GOOGLE CLOUD PROJECT
# ------------------------------------------------------------------------------

resource "random_id" "id" {
  prefix      = "${var.product_env}-${var.product_name}-"
  byte_length = 4
}

resource "google_project" "project" {
  name            = "${random_id.id.hex}"
  project_id      = "${random_id.id.hex}"
  billing_account = "${var.billing_id}"
  org_id          = "${var.organization_id}"
  skip_delete     = false
}

resource "google_project_service" "services" {
  count = "${length(var.project_services)}"

  project            = "${google_project.project.project_id}"
  disable_on_destroy = false

  service = "${element(var.project_services, count.index)}"
}

# ------------------------------------------------------------------------------
# Support for AuditConfigs is missing in terraform-provider-google
# GitHub issue:
# https://github.com/terraform-providers/terraform-provider-google/issues/936
# ------------------------------------------------------------------------------

# ...

# ------------------------------------------------------------------------------
# VPC NETWORK, SUBNETS, FIREWALL RULES
# ------------------------------------------------------------------------------

resource "google_compute_network" "network" {
  project                 = "${google_project.project.project_id}"
  name                    = "${var.product_env}-${var.product_name}-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnets" {
  count = "${length(var.cluster_subnets)}"

  project = "${google_project.project.project_id}"

  name                     = "nodes"
  network                  = "${google_compute_network.network.self_link}"
  ip_cidr_range            = "${element(split(",", lookup(var.cluster_subnets, count.index)), 1)}"
  private_ip_google_access = true
  region                   = "${element(split(",", lookup(var.cluster_subnets, count.index)), 0)}"

  secondary_ip_range = [
    {
      range_name    = "pods"
      ip_cidr_range = "${element(split(",", lookup(var.cluster_subnets, count.index)), 2)}"
    },
    {
      range_name    = "services"
      ip_cidr_range = "${element(split(",", lookup(var.cluster_subnets, count.index)), 3)}"
    },
  ]
}

resource "google_compute_firewall" "allow_nodes_internal" {
  project = "${google_project.project.project_id}"

  name        = "allow-nodes-internal"
  description = "Allow traffic between nodes"

  network  = "${google_compute_network.network.name}"
  priority = "65534"

  direction     = "INGRESS"
  source_ranges = ["${google_compute_subnetwork.subnets.*.ip_cidr_range}"]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
}

resource "google_compute_firewall" "allow_pods_internal" {
  project  = "${google_project.project.project_id}"
  name     = "allow-pods-internal"
  network  = "${google_compute_network.network.name}"
  priority = "1000"

  description = "Allow traffic between pods and services"

  # services and pods ranges
  direction = "INGRESS"

  source_ranges = [
    "${google_compute_subnetwork.subnets.*.secondary_ip_range.0.ip_cidr_range}",
    "${google_compute_subnetwork.subnets.*.secondary_ip_range.1.ip_cidr_range}",
  ]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
}

# ------------------------------------------------------------------------------
# DNS ZONES AND EXTERNAL IP ADDRESS
# ------------------------------------------------------------------------------

resource "google_compute_global_address" "ingress_controller_ip" {
  count   = "${var.create_static_ip_address ? 1 : 0}"
  project = "${google_project.project.project_id}"

  name       = "ingress-controller-ip"
  ip_version = "IPV4"
}

resource "google_dns_managed_zone" "dns_zones" {
  count   = "${length(var.dns_zones) > 0 ? length(var.dns_zones) : 0}"
  project = "${google_project.project.project_id}"

  name     = "${element(keys(var.dns_zones), count.index)}"
  dns_name = "${element(values(var.dns_zones), count.index)}"
}

resource "google_dns_record_set" "ingress_domains" {
  count   = "${length(var.dns_zones) > 0 && length(var.ingress_domains) > 0 ? length(var.ingress_domains) : 0}"
  project = "${google_project.project.project_id}"
  type    = "A"
  ttl     = 3600

  managed_zone = "${element(keys(var.ingress_domains), count.index)}"
  name         = "${element(values(var.ingress_domains), count.index)}"
  rrdatas      = ["${google_compute_global_address.ingress_controller_ip.0.address}"]
}
