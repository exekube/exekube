release_spec = {
  enabled        = true
  release_name   = "drone"
  release_values = "values.yaml"

  chart_repo    = "private"
  chart_name    = "drone"
  chart_version = "0.3.0"

  domain_name = "ci.swarm.pw"
}
