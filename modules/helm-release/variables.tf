# ------------------------------------------------------------------------------
# HELM TLS CONFIG
# ------------------------------------------------------------------------------

# By default ca.cert.pem, helm.cert.pem, and helm.key.pem will be sourced from
# ${secrets_dir}/${tiller_namespace}/_helm/*.pem
variable "secrets_dir" {
  description = "The directory for storing secrets for the project"
}

# Set this if TLS assets are in directory other than ${tiller_namespace}
# i.e. ${secrets_dir}/${custom_tls_dir}/${helm_dir}/*.pem
variable "custom_tls_dir" {
  default = ""
}

variable "helm_dir_name" {
  default = "_helm"
}

# ------------------------------------------------------------------------------
# Helm release specification
# ------------------------------------------------------------------------------

variable "release_spec" {
  type = "map"

  default = {
    enabled          = false
    tiller_namespace = "kube-system"
    chart_repo       = ""
    namespace        = "default"
    chart_name       = ""
    chart_version    = ""
    release_name     = ""
    release_values   = "values.yaml"

    domain_name = ""
  }
}

# ------------------------------------------------------------------------------
# Helm chart repo
# ------------------------------------------------------------------------------

variable "chart_repo" {
  default = {
    name = ""
    url  = ""
  }
}

# ------------------------------------------------------------------------------
# Create a Kubernetes secret
# ------------------------------------------------------------------------------

variable "kubernetes_secrets" {
  description = "A list of paths from $TF_VAR_secrets_dir to `kubectl apply`"
  default     = []
}

# ------------------------------------------------------------------------------
# Create secret for ingress basic authenticaion
# Two separate files instead of one YAML used to integrate
# with docker-registry and chartmuseum charts
# ------------------------------------------------------------------------------

variable "ingress_basic_auth" {
  type = "map"

  default = {
    username    = ""
    password    = ""
    secret_name = ""
  }
}

# ------------------------------------------------------------------------------
# Pre-hook and post-hook, to be run before creation and after release creation
# ------------------------------------------------------------------------------

variable "pre_hook" {
  type        = "map"
  description = "Raw bash command to run before release creation"

  default = {
    command = "helm repo update"
  }
}

variable "post_hook" {
  type        = "map"
  description = "Raw bash command to run after release creation"

  default = {
    command = "echo hello from post_hook"
  }
}
