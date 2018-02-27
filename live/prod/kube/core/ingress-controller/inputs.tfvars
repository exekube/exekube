# If you create and destroy DNS records frequently
# You will likely face negative DNS caching, or NXDOMAIN caching
# https://technet.microsoft.com/en-us/library/cc958971.aspx
# Ideally we would tell Terraform to not destroy DNS records at all
# And use a cloud static IP address
# But Terraform doesn't support a useful "prevent_destroy" feature as of now
# Read GitHub issue: https://github.com/hashicorp/terraform/issues/3874
#
# Therefore, to avoid a NXDOMAIN error upon creating ingress resources
# We manage both a cloud static IP address
# And a cloud DNS record outside of helm_release modules
#
# cluster_dns_zones = [
#  "swarm.pw",
#]

release_spec = {
  enabled        = true
  release_name   = "ingress-controller"
  release_values = "values.yaml"

  chart_repo    = "stable"
  chart_name    = "nginx-ingress"
  chart_version = "0.9.4"
}

post_hook = {
  command = "kubectl apply -f $XK_LIVE_DIR/../../backup/tls/secret.yaml"
}
