# This is the list of Terraform plugins to be installed in the exekube container

provider "google" {
  version = "~> 1.16"
}

provider "random" {
  version = "~> 1.3"
}

provider "null" {
  version = "~> 1.0"
}

provider "kubernetes" {
  version = "~> 1.1"
}

provider "template" {
  version = "~> 1.0"
}

provider "tls" {
  version = "~> 1.2"
}

provider "local" {
  version = "~> 1.1"
}

provider "external" {
  version = "~> 1.0"
}

provider "aws" {
  version = "~> 1.36"
}
