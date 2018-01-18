output "k8s_master_version" {
  value = "${google_container_cluster.gke_cluster.master_version}"
}
