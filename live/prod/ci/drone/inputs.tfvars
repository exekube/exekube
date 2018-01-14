release_spec = {
  enabled        = false
  release_name   = "drone"
  release_values = "values.yaml"

  chart_repo    = "https://kubernetes-charts-incubator.storage.googleapis.com"
  chart_name    = "drone"
  chart_version = "0.2.1"

  domain_name = "drone.swarm.pw"
}
