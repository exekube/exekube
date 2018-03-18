output "project_id" {
  value = "${google_project.project.project_id}"
}

output "network_name" {
  value = "${google_compute_network.network.name}"
}

output "static_ip_address" {
  value = ["${google_compute_global_address.ingress_controller_ip.*.address}"]
}

output "dns_zones" {
  value = ["${google_dns_managed_zone.dns_zones.*.dns_name}"]
}

output "dns_zone_servers" {
  value = ["${google_dns_managed_zone.dns_zones.*.name_servers}"]
}
