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

chartmuseum_enabled = 0
chartmuseum_release_name = "chartmuseum"
chartmuseum_release_values = "/exekube/live/prod/kube-ci/values/chartmuseum.yaml"

docker_registry_enabled = 0
docker_registry_release_name = "docker-registry"
docker_registry_release_values = "/exekube/live/prod/kube-ci/values/docker-registry.yaml"
