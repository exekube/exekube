// we use same default credentials that are used for `kubectl`
variable "helm_stable_repo_url" {
  default = "https://kubernetes-charts.storage.googleapis.com"
}

variable "helm_incubator_repo_url" {
  default = "https://kubernetes-charts.storage.googleapis.com"
}

variable "helm_private_repo_url" {
  default = ""
}

provider "helm" {}
