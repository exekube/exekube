# ------------------------------------------------------------------------------
# Terragrunt configuration
# ------------------------------------------------------------------------------

terragrunt = {
  terraform {
    # Source for the module
    # This is how the client side (inputs.tfvars / TF_VAR_* and values/*.yaml territory) connects to
    # the module land (*.tf -- config, inputs, resources).
    source = "/exekube/modules//kube-core"

    # source = "git::git@github.com/ilyasotkov/modules.git//kube-core?ref=v0.2.0"
  }

  # Include all settings from the root terraform.tfvars file
  include = {
    path = "${find_in_parent_folders()}"
  }

  dependencies {
    paths = ["../gcp-project"]
  }
}
