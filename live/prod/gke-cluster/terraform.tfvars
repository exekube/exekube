# ------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# ------------------------------------------------------------------------------

terragrunt = {
  # Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
  # working directory, into a temporary folder, and execute your Terraform commands in that folder.
  terraform {
    source = "/exekube/modules//gke-cluster"
  }

  # Include all settings from the root terraform.tfvars file
  include = {
    path = "${find_in_parent_folders()}"
  }
}

# ------------------------------------------------------------------------------
# MODULE PARAMETERS
# ------------------------------------------------------------------------------
gcp_project = "ethereal-argon-186217"
gcp_zone = "europe-west1-d"
cluster_name       = "k8s-cluster"
nodepool_name      = "k8s-np"
gke_version        = "1.8.4-gke.1"
enable_legacy_auth = "true"
