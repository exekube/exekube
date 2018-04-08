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

resource "alicloud_vpc" "network" {
  name       = "network"
  cidr_block = "${var.vpc_cidr}"
}

/*

resource "alicloud_vswitch" "vswitch" {
  availability_zone = ""
  name              = ""
  cird_block        = ""
  vpc_id            = "${alicloud_vpc.network}"
}

resource "alicloud_security_group" "group" {
  name   = ""
  vpc_id = "${alicloud_vpc.network}"
}

resource "alicloud_dns_group" "group" {
  name = ""
}

resource "alicloud_dns" "dns" {
  name     = "starmove.com"
  group_id = ""
}

resource "alicloud_dns_record" "record" {
  name        = ""
  host_record = "@"
  type        = "A"
  value       = ""
}
*/

