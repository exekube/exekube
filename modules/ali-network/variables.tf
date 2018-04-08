variable "access_key" {}
variable "secret_key" {}

variable "vpc_cidr" {
  description = "The cidr block used to launch a new VPC."
  default     = "172.16.0.0/12"
}
