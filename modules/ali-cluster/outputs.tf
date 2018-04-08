output "docker_version" {
  value = "${alicloud_cs_kubernetes.k8s_cluster.docker_version}"
}

output "cluster_id" {
  value = "${alicloud_cs_kubernetes.k8s_cluster.id}"
}
