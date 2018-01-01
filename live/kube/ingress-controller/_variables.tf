#################################
# Cloudflare variables
#################################

variable "cloudflare_email" {}
variable "cloudflare_token" {}
variable "cloudflare_domain_zone" {}


#################################
# Helm variables
#################################

variable "helm_stable_repo_url" {
  default = "https://kubernetes-charts.storage.googleapis.com"
}
variable "helm_incubator_repo_url" {
  default = "https://kubernetes-charts.storage.googleapis.com"
}
variable "helm_private_repo_url" {
  default = ""
}
