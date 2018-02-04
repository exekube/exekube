# ------------------------------------------------------------------------------
# Terragrunt configuration
# ------------------------------------------------------------------------------

terragrunt = {
  terraform {
    source = "${get_env("XK_LIVE_DIR", "")}/../../modules//gcp-gke"
  }

  include = {
    path = "${find_in_parent_folders()}"
  }
}
