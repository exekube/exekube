# Workaround from
# https://github.com/hashicorp/terraform/issues/3116#issuecomment-292038781
# to allow us to optionally enable 'lifecycle { prevent_destroy = true }'.
#
# 'endpoint' is an arbitrarily-chosen attribute; its value is not used.
output "stub_output_for_dependency" {
  value = "${google_container_cluster.cluster.endpoint}"
}
