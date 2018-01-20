terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "gcs" {}
}

# ------------------------------------------------------------------------------
# Terragrunt configuration
# ------------------------------------------------------------------------------

terragrunt = {
  terraform {
    source = "/exekube/modules//vault-storage"
  }

  dependencies {
    paths = [
      "../../../../infra/gcp-gke",
    ]
  }

  include = {
    path = "${find_in_parent_folders()}"
  }
}
