provider "alicloud" {
  access_key = ""
  secret_key = ""
  region     = ""
}

resource "alicloud_vpc" "network" {
  name       = "network"
  cidr_block = ""
}

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
