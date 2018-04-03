#output "static_ip_address" {
#  value = "${google_compute_address.ingress_controller_ip.0.address}"
#}

output "dns_zones" {
  value = ["${google_dns_managed_zone.dns_zones.*.dns_name}"]
}

output "dns_zone_servers" {
  value = ["${google_dns_managed_zone.dns_zones.*.name_servers}"]
}
