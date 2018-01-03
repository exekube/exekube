# ------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
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
# MODULE PARAMETERS
# ------------------------------------------------------------------------------

helm_values_jenkins = "/exekube/live/prod/kube-ci/values/jenkins-dev.yaml"
