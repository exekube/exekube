provider "alicloud" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "alicloud_cs_kubernetes" "k8s_cluster" {
  # name_prefix = "k8s-cluster"

  # name = "k8s-cluster"

  # availability_zone = ""

  new_nat_gateway      = true
  vswitch_id           = "${}"
  pod_cidr             = ""
  service_cird         = ""
  security_group_id    = ""
  image_id             = ""
  master_instance_type = ""
  worker_instance_type = ""
  worker_number        = ""
  worker_disk_size     = ""
  worker_disk_category = ""
  password             = ""

  # enable_ssh            = false
  install_cloud_monitor = true

  provisioner "local-exec" {
    command = ""
  }
}
