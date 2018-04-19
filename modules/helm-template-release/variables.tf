# ------------------------------------------------------------------------------
# REQUIRED VARIABLES
# ------------------------------------------------------------------------------

variable "release_name" {
  description = "Name of your Helm release to create"
}

variable "chart_repo" {
  description = "Name of chart repoisitory"
}

variable "chart_name" {
  description = "Name or local path for chart to install"
}

# ------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# ------------------------------------------------------------------------------

variable "prevent_destroy" {
  default = false
}

variable "disable_release" {
  description = "Do not create the release"
  default     = false
}

variable "release_namespace" {
  description = "Namespace to install the release into"
  default     = "default"
}

variable "chart_version" {
  description = "Version of chart to install"
  default     = ""
}

variable "release_values" {
  description = "Specify values in a YAML file, relative to module's path"
  default     = "values.yaml"
}

variable "kubernetes_yaml" {
  description = "List paths to secrets to create before installing the chart"
  default     = []
}

variable "domain_name" {
  description = "Specify the domain name to use for ingress (interpolated in values.yaml)"
  default     = ""
}

variable "load_balancer_ip" {
  description = "Specify the IP of to use for LoadBalancer (used for ingress controllers)"
  default     = ""
}

variable "ingress_basic_auth" {
  default = {
    secret_name = ""
    username    = ""
    password    = ""
  }
}
