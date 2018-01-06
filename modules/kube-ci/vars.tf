# ------------------------------------------------------------------------------
# Jenkins variables
# ------------------------------------------------------------------------------

variable "jenkins_enabled" {
  default = 1
}
variable "jenkins_release_name" {}
variable "jenkins_release_values" {}
variable "jenkins_domain_name" {}

# ------------------------------------------------------------------------------
# ChartMuseum variables
# ------------------------------------------------------------------------------

variable "chartmuseum_enabled" {
  default = 1
}
variable "chartmuseum_release_name" {}
variable "chartmuseum_release_values" {}
variable "chartmuseum_domain_name" {}
variable "chartmuseum_username" {}
variable "chartmuseum_password" {}

# ------------------------------------------------------------------------------
# Docker Registry variables
# ------------------------------------------------------------------------------

variable "docker_registry_enabled" {
  default = 1
}
variable "docker_registry_release_name" {}
variable "docker_registry_release_values" {}
variable "docker_registry_domain_name" {}
variable "docker_registry_username" {}
variable "docker_registry_password" {}
