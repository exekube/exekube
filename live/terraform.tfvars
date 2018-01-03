terragrunt = {
  # Configure Terragrunt to automatically store tfstate files in an GCS bucket
  remote_state {
    backend = "gcs"
    config {
      bucket  = "ethereal-argon-terraform-state"
      project = "ethereal-argon-186217"
      prefix  = "${path_relative_to_include()}"
    }
  }
  terraform {
    extra_arguments "auto_approve" {
      commands = [ "apply" ]
      arguments = [ "-auto-approve" ]
    }
  }
}
