# ------------------------------------------------------------------------------
# live/prod/kube-ci | HCL (HashiCorp Configuration Language)
#
# Docs, deafaults, all inputs: modules/kube-ci/inputs.tf
# ------------------------------------------------------------------------------

jenkins = {
  enabled     = true
  domain_name = "ci.flexeption.pw"
}

chartmuseum = {
  enabled     = true
  domain_name = "charts.flexeption.pw"
}

docker_registry = {
  enabled     = true
  domain_name = "registry.flexeption.pw"
}
