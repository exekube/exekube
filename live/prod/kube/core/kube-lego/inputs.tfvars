release_spec = {
  enabled        = true
  release_name   = "kube-lego"
  release_values = "values.yaml"

  chart_repo    = "stable"
  chart_name    = "kube-lego"
  chart_version = "0.3.0"
}
