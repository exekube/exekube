# ------------------------------------------------------------------------------
# Module parameters
# ------------------------------------------------------------------------------

cluster_dns_zones = [
  "c6ns.pw",
  "flexeption.pw",
]

ingress_controller {
  enabled = true
  # values_file = "values/ingress-controller.yaml"
}

kube_lego {
  enabled = true
  # values_file = "values/kube-lego.yaml"
}
