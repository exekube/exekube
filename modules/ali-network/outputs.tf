output "vswitch_id" {
  value = "${alicloud_vswitch.vswitch.id}"
}

output "eip_address" {
  value = "${alicloud_eip.eip.*.ip_address}"
}
