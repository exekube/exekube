release_spec = {
  enabled        = false
  release_name   = "rails-app"
  release_values = "values.yaml"

  chart_repo    = "private"
  chart_name    = "rails-app"
  chart_version = "0.1.1"

  domain_name = "react.swarm.pw"
}
