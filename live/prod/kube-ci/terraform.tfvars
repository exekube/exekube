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
  # enabled = false
  # domain_zone = "example.com"
  domain_name = "jenkins.ci"
  release_name = "jenkins"
  release_values = "/exekube/live/prod/kube-ci/values/jenkins.yaml"
}

# chartmuseum_enabled = 0
chartmuseum_release_name = "chartmuseum"
chartmuseum_release_values = "/exekube/live/prod/kube-ci/values/chartmuseum.yaml"
# chartmuseum_username = ""
# chartmuseum_password = ""
# chartmuseum_domain_name = ""

# jenkins_enabled = 0
docker_registry_release_name = "docker-registry"
docker_registry_release_values = "/exekube/live/prod/kube-ci/values/docker-registry.yaml"
# docker_registry_domain_name = ""
# docker_registry_username = ""
# docker_registry_password = ""
