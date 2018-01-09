# ------------------------------------------------------------------------------
# live/prod/kube-core | HCL (HashiCorp Configuration Language)
#
# Docs, deafaults, all inputs: modules/kube-core/inputs.tf
# ------------------------------------------------------------------------------

cluster_dns_zones = [
  "c6ns.pw",
  "flexeption.pw",
]

ingress_controller = {}

kube_lego = {}
