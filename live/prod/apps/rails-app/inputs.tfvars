release_spec = {
  enabled        = true
  release_name   = "rails-app"
  release_values = "values.yaml"

  chart_repo    = "private"
  chart_name    = "rails-app"
  chart_version = "0.1.1"

  pull_secret = "docker-config.json"
  domain_name = "react.swarm.pw"
}
