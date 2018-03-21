variable "secrets_dir" {}

variable "tiller_namespace" {
  default = "kube-system"
}

variable "custom_tls_dir" {
  default = ""
}
