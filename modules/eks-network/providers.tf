#
# Provider Configuration
#

provider "aws" {
  region = "us-west-2"
}

# Using this data source allows the configuration to be
# generic for any region.
data "aws_availability_zones" "available" {}

# Not required: currently used in conjuction with using
# icanhazip.com to determine local workstation external IP
# to open EC2 Security Group access to the Kubernetes cluster.
# See workstation-external-ip.tf for additional information.
provider "http" {}
