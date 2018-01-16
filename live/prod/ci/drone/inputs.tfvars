release_spec = {
  enabled        = false
  release_name   = "drone"
  release_values = "values.yaml"

  chart_repo    = "incubator"
  chart_name    = "drone"
  chart_version = "0.2.1"

  domain_name = "ci.swarm.pw"
}
