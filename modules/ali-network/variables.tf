variable "access_key" {
  description = "Path to file with Alibaba Cloud Access Key ID"
}

variable "secret_key" {
  description = "Path to file with Alibaba Cloud Access Key Secret"
}

variable "vpc_cidr" {
  description = "The cidr block used to launch a new VPC."
  default     = "10.0.0.0/8"
}

variable "vswitch_cidr" {
  description = "The cidr block used to launch a new VPC."
  default     = "10.16.0.0/16"
}

variable "dns_zones" {
  type = "list"

  default = []
}
