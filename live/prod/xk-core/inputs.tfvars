# ------------------------------------------------------------------------------
# live/prod/kube-core | HCL (HashiCorp Configuration Language)
#
# Docs, defaults, all inputs: modules/kube-core/inputs.tf
# ------------------------------------------------------------------------------

cluster_dns_zones = [
  "sotkov.pw",
]

ingress_controller = {}

kube_lego = {}
