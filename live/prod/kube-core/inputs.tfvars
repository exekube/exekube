# ------------------------------------------------------------------------------
# Module parameters
# ------------------------------------------------------------------------------

# cloudflare_dns_zones = []

ingress_controller {
  enabled = true
  # values_file = "values/ingress-controller.yaml"
}

kube_lego {
  enabled = true
  # values_file = "values/kube-lego.yaml"
}
