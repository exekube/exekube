# ------------------------------------------------------------------------------
# Terragrunt configuration
# ------------------------------------------------------------------------------

terragrunt = {
  # Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
  # working directory, into a temporary folder, and execute your Terraform commands in that folder.
  terraform {
    source = "/exekube/modules//kube-ci"
  }

  # Include all settings from the root terraform.tfvars file
  include = {
    path = "${find_in_parent_folders()}"
  }

  dependencies {
    paths = ["../gke-cluster", "../kube-core"]
  }
}

# ------------------------------------------------------------------------------
# Module parameters
# ------------------------------------------------------------------------------

jenkins_enabled = 1
jenkins_release_name = "jenkins"
jenkins_release_values = "/exekube/live/prod/kube-ci/values/jenkins.yaml"
# jenkins_domain_name = ""

chartmuseum_enabled = 1
chartmuseum_release_name = "chartmuseum"
chartmuseum_release_values = "/exekube/live/prod/kube-ci/values/chartmuseum.yaml"
# chartmuseum_username = ""
# chartmuseum_password = ""
# chartmuseum_domain_name = ""

docker_registry_enabled = 1
docker_registry_release_name = "docker-registry"
docker_registry_release_values = "/exekube/live/prod/kube-ci/values/docker-registry.yaml"
# docker_registry_domain_name = ""
# docker_registry_username = ""
# docker_registry_password = ""
