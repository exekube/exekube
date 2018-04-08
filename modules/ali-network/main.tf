# ------------------------------------------------------------------------------
# TERRAFORM / PROVIDER CONFIG
# ------------------------------------------------------------------------------

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "gcs" {}
}

provider "alicloud" {
  version    = ">= 1.9.1"
  region     = "eu-central-1"
  access_key = "${chomp(file("${var.access_key}"))}"
  secret_key = "${chomp(file("${var.secret_key}"))}"
}

# ------------------------------------------------------------------------------
# VPC NETWORK, VSWITCHES, SECURITY GROUPS
# ------------------------------------------------------------------------------

resource "alicloud_vpc" "network" {
  name       = "k8s-network"
  cidr_block = "${var.vpc_cidr}"
}

resource "alicloud_vswitch" "vswitch" {
  availability_zone = "eu-central-1a"
  vpc_id            = "${alicloud_vpc.network.id}"

  name       = "k8s-vswitch"
  cidr_block = "${var.vswitch_cidr}"
}

resource "alicloud_security_group" "group" {
  name        = "k8s-security-group"
  vpc_id      = "${alicloud_vpc.network.id}"
  description = "Security group for the Kubernetes cluster"
}

# ------------------------------------------------------------------------------
# DNS ZONES AND RECORDS
# ------------------------------------------------------------------------------

resource "alicloud_eip" "eip" {
  # bandwidth            = "10"
  internet_charge_type = "PayByTraffic"
}

resource "alicloud_dns_group" "group" {
  name = "k8s-domains"
}

resource "alicloud_dns" "zones" {
  count = "${length(var.dns_zones) > 0 ? length(var.dns_zones) : 0}"

  name     = "${element(var.dns_zones, count.index)}"
  group_id = "${alicloud_dns_group.group.id}"
}

resource "alicloud_dns_record" "records" {
  count = "${length(var.dns_zones) > 0 ? length(var.dns_zones) : 0}"

  name        = "${element(var.dns_zones, count.index)}"
  host_record = "*"
  type        = "A"
  value       = "${alicloud_eip.eip.ip_address}"
}
