# ------------------------------------------------------------------------------
# Module parameters
# ------------------------------------------------------------------------------

jenkins = {
  enabled     = true
  values_file = "values/jenkins.yaml"
  domain_name = "ci.c6ns.pw"

  # release_name = "jenkins"
}

chartmuseum = {
  enabled     = true
  values_file = "values/chartmuseum.yaml"
  domain_name = "charts.c6ns.pw"

  # domain_zone = "example.com"
  # release_name = "chartmuseum"
  # username = ""
  # password = ""
}

docker_registry = {
  enabled     = true
  values_file = "values/docker-registry.yaml"
  domain_name = "r.c6ns.pw"

  # release_name = "docker-registry"
  # username = ""
  # password = ""
}
