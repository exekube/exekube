terragrunt = {
  # Configure Terragrunt to automatically store tfstate files in an GCS bucket
  remote_state {
    backend = "gcs"
    config {
      bucket  = "${get_env("TF_VAR_gcp_remote_state_bucket", "")}"
      project = "${get_env("TF_VAR_gcp_project", "")}"
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
