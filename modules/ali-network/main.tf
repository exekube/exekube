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

resource "alicloud_security_group" "default" {
  name        = "k8s-security-group"
  vpc_id      = "${alicloud_vpc.network.id}"
  description = "Security group for the Kubernetes cluster"
}

resource "alicloud_security_group_rule" "allow_ssh" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "22/22"
  priority          = 1
  security_group_id = "${alicloud_security_group.default.id}"
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "allow_icmp" {
  type              = "ingress"
  ip_protocol       = "icmp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "-1/-1"
  priority          = 1
  security_group_id = "${alicloud_security_group.default.id}"
  cidr_ip           = "0.0.0.0/0"
}

# ------------------------------------------------------------------------------
# DNS ZONES AND RECORDS
# ------------------------------------------------------------------------------

resource "alicloud_eip" "eip" {
  count = "${var.create_eip}"

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
