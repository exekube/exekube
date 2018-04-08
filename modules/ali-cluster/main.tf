provider "alicloud" {
  version    = ">= 1.9.1"
  region     = "eu-central-1"
  access_key = "${chomp(file("${var.access_key}"))}"
  secret_key = "${chomp(file("${var.secret_key}"))}"
}

resource "alicloud_cs_kubernetes" "k8s_cluster" {
  name_prefix = "k8s-cluster"

  new_nat_gateway = true
  vswitch_id      = "${var.vswitch_id}"

  pod_cidr     = "10.17.0.0/16"
  service_cidr = "10.18.0.0/16"
  enable_ssh   = true

  master_instance_type = "ecs.sn2.medium"
  master_disk_category = "cloud_efficiency"

  worker_instance_type = "ecs.sn2.medium"
  worker_number        = "2"
  worker_disk_size     = "20"
  worker_disk_category = "cloud_efficiency"

  password = "${chomp(file("${var.ssh_password}"))}"

  install_cloud_monitor = true
}
