output "project_id" {
  value = "${google_project.project.project_id}"
}

output "network_name" {
  value = "${google_compute_network.network.name}"
}
