# ------------------------------------------------------------------------------
# VPC NETWORK, SUBNETS, FIREWALL RULES
# ------------------------------------------------------------------------------

resource "google_compute_network" "network" {
  name                    = "network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnets" {
  count = "${length(var.cluster_subnets)}"

  name                     = "nodes"
  network                  = "${google_compute_network.network.self_link}"
  ip_cidr_range            = "${element(split(",", lookup(var.cluster_subnets, count.index)), 1)}"
  region                   = "${element(split(",", lookup(var.cluster_subnets, count.index)), 0)}"
  private_ip_google_access = true

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
  name        = "allow-nodes-internal"
  description = "Allow traffic between nodes"

  network  = "${google_compute_network.network.self_link}"
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

resource "null_resource" "delete_default_network" {
  provisioner "local-exec" {
    command = <<EOF
gcloud --project $TF_VAR_project_id --quiet compute firewall-rules delete \
default-allow-ssh \
default-allow-rdp \
default-allow-internal \
default-allow-icmp \
&& gcloud --quiet --project $TF_VAR_project_id compute networks delete default
EOF

    on_failure = "continue"
  }
}

# ------------------------------------------------------------------------------
# EXTERNAL IP ADDRESS
# ------------------------------------------------------------------------------

resource "google_compute_address" "ingress_controller_ip" {
  count = "${var.create_static_ip_address ? 1 : 0}"

  name         = "ingress-controller-ip"
  region       = "${var.static_ip_region}"
  address_type = "EXTERNAL"
}

# ------------------------------------------------------------------------------
# DNS ZONES AND RECORDS
# ------------------------------------------------------------------------------

resource "google_dns_managed_zone" "dns_zones" {
  count = "${length(var.dns_zones) > 0 ? length(var.dns_zones) : 0}"

  name     = "${element(keys(var.dns_zones), count.index)}"
  dns_name = "${element(values(var.dns_zones), count.index)}"
}

resource "google_dns_record_set" "dns_records" {
  depends_on = ["google_dns_managed_zone.dns_zones"]
  count      = "${length(var.dns_zones) > 0 && length(var.dns_records) > 0 && var.create_static_ip_address ? length(var.dns_records) : 0}"

  type = "A"
  ttl  = 3600

  managed_zone = "${element(keys(var.dns_records), count.index)}"
  name         = "${element(values(var.dns_records), count.index)}"
  rrdatas      = ["${google_compute_address.ingress_controller_ip.0.address}"]
}
