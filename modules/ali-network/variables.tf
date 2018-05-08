variable "vpc_cidr" {
  description = "The cidr block used to launch a new VPC"
  default     = "10.0.0.0/8"
}

variable "vswitch_cidr" {
  description = "VSwitch CIDR (subnet for Kubernetes nodes)"
  default     = "10.16.0.0/20"
}

variable "create_eip" {
  default = false
}

variable "dns_zones" {
  type = "list"

  default = []
}
