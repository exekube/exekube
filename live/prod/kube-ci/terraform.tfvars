# ------------------------------------------------------------------------------
# Terragrunt configuration
# ------------------------------------------------------------------------------

terragrunt = {
  terraform {
    source = "/exekube/modules//kube-ci"
  }

  # Include all settings from the root terraform.tfvars file
  include = {
    path = "${find_in_parent_folders()}"
  }

  dependencies {
    paths = [
      "../gke-cluster",
      "../kube-core",
    ]
  }
}

# ------------------------------------------------------------------------------
# Module parameters
# ------------------------------------------------------------------------------

jenkins = {
  enabled             = true
  values_file = "values/jenkins.yaml"

  domain_name = "cd"
  # domain_zone = "example.com"
  # release_name = "jenkins"
}

chartmuseum = {
  enabled             = true
  values_file = "values/chartmuseum.yaml"

  # enabled = false
  domain_name = "chartsss"
  # domain_zone = "example.com"
  # release_name = "chartmuseum"
  # username = ""
  # password = ""
}

docker_registry = {
  enabled             = true
  values_file = "values/docker-registry.yaml"

  # enabled = false
  # domain_zone = "example.com"
  domain_name = "registryyy"
  # release_name = "docker-registry"
  # username = ""
  # password = ""
}
