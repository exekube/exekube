# ------------------------------------------------------------------------------
# Terragrunt configuration
# ------------------------------------------------------------------------------

terragrunt = {
  terraform {
    # source = "git::git@github.com/ilyasotkov/modules.git//kube-ci?ref=v0.2.0"
    source = "/exekube/modules//kube-ci"
  }

  # Include all settings from the root terraform.tfvars file
  include = {
    path = "${find_in_parent_folders()}"
  }

  dependencies {
    paths = [
      "../gcp-project",
      "../kube-core",
    ]
  }
}
