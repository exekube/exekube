release_spec = {
  enabled     = true
  domain_name = "registry.swarm.pw"

  release_name   = "docker-registry"
  release_values = "values.yaml"

  chart_repo    = "stable"
  chart_name    = "docker-registry"
  chart_version = "1.0.1"
}

basic_auth = {
  secret_name = "registry-htpasswd"
}
