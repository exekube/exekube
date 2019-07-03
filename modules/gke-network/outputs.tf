/*
output "static_ip_address" {
  value = "${element(concat(google_compute_address.ingress_controller_ip.*.address, list("")), 0)}"
}
*/

output "dns_zones" {
  value = ["${google_dns_managed_zone.dns_zones.*.dns_name}"]
}

output "dns_zone_servers" {
  value = ["${google_dns_managed_zone.dns_zones.*.name_servers}"]
}
