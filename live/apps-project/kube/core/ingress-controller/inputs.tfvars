cluster_dns_zones = [
  "c6ns.pw",
]

release_spec = {
  enabled        = true
  release_name   = "ingress-controller"
  release_values = "values.yaml"

  chart_repo    = "stable"
  chart_name    = "nginx-ingress"
  chart_version = "0.8.23"
}

post_hook = {
  command = "kubectl apply -f $XK_LIVE_DIR/../../backup/tls/secret.yaml"
}
