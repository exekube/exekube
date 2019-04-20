variable "secrets_dir" {}

# Helm Initializer module will install Tiller into your namespace and generate
# TLS assets we are gonna use to authenticate to Tiller
# By default, TLS assets will be created to a directory in
# ${TF_VAR_secrets_dir}/${custom_tls_dir:-tiller-namespace}/${helm_dir_name}

variable "tiller_namespace" {
  default = "kube-system"
}

variable "custom_tls_dir" {
  default = ""
}

variable "helm_dir_name" {
  default = "helm-tls"
}

variable "tiller_connection_timeout" {
  default     = "30"
  description = "How long will Helm wait to establish a connection to tiller"
}
