release_spec = {
  enabled        = false
  release_name   = "vault"
  release_values = "values.yaml"

  chart_repo    = "incubator"
  chart_name    = "vault"
  chart_version = "0.3.0"
}
