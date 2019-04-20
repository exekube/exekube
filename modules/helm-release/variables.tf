# ------------------------------------------------------------------------------
# REQUIRED VARIABLES
# ------------------------------------------------------------------------------

variable "client_auth" {
  description = "Path with helm.cert.pem, helm.key.pem, and ca.cert.pem"
}

variable "release_name" {
  description = "Name of your Helm release to create"
}

variable "chart_name" {
  description = "Name or local path for chart to install"
}

# ------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# ------------------------------------------------------------------------------

variable "disable_release" {
  description = "Do not create the release"
  default     = false
}

variable "tiller_namespace" {
  description = "Namespace of Tiller"
  default     = "kube-system"
}

variable "project_id" {
  default = ""
}

variable "release_namespace" {
  description = "Namespace to install the release into"
  default     = "default"
}

variable "chart_repo" {
  description = "Helm chart repo, URL or saved name"
  default     = ""
}

variable "chart_version" {
  description = "Version of chart to install"
  default     = ""
}

variable "release_values_rendered" {
  description = "Provide rendered template with release values"
  default     = ""
}

variable "release_values" {
  description = "Specify path to release values, relative to module's path"
  default     = "values.yaml"
}

variable "extra_values" {
  description = "Specify list of paths to release values, relative to module's path"
  default     = ""
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

variable "force_update" {
  description = "Force resource update through delete/recreate if needed"
  default     = false
}
