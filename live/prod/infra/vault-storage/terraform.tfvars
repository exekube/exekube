# ------------------------------------------------------------------------------
# Terragrunt configuration
# ------------------------------------------------------------------------------

terragrunt = {
  terraform {
    source = "/exekube/modules//vault-storage"
  }

  dependencies {
    paths = [
      "../gcp-gke",
    ]
  }

  include = {
    path = "${find_in_parent_folders()}"
  }
}
