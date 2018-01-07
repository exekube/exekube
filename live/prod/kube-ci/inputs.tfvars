# ------------------------------------------------------------------------------
# Module parameters
# ------------------------------------------------------------------------------

jenkins = {
  enabled     = true
  values_file = "values/jenkins.yaml"
  domain_name = "jenkins.c6ns.pw"

  # release_name = "jenkins"
}

chartmuseum = {
  enabled     = true
  values_file = "values/chartmuseum.yaml"
  domain_name = "chartmuseum.c6ns.pw"

  # release_name = "chartmuseum"
  # username = ""
  # password = ""
}

docker_registry = {
  enabled     = true
  values_file = "values/docker-registry.yaml"
  domain_name = "docker-registry.c6ns.pw"

  # release_name = "docker-registry"
  # username = ""
  # password = ""
}
