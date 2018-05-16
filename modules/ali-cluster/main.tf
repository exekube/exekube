resource "alicloud_cs_kubernetes" "k8s_cluster" {
  name_prefix = "k8s-cluster"

  new_nat_gateway = "${var.new_nat_gateway}"
  vswitch_id      = "${var.vswitch_id}"
  is_outdated     = false

  pod_cidr     = "172.20.0.0/16"
  service_cidr = "172.21.0.0/20"
  enable_ssh   = true

  master_instance_type = "ecs.n4.small"
  master_disk_category = "cloud_efficiency"

  worker_instance_type = "ecs.n4.small"
  worker_number        = "2"
  worker_disk_size     = "30"
  worker_disk_category = "cloud_efficiency"

  password = "${chomp(file("${var.ssh_password}"))}"

  install_cloud_monitor = true
}
