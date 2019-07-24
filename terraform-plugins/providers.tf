# This is the list of Terraform plugins to be installed in the exekube container

provider "google" {
  version = "~> 2.7.0"
}

provider "google-beta" {
  version = "~> 2.7.0"
}

provider "random" {
  version = "~> 2.1.2"
}

provider "null" {
  version = "~> 2.1.2"
}

provider "kubernetes" {
  version = "~> 1.6.2"
}

provider "template" {
  version = "~> 2.1.2"
}

provider "tls" {
  version = "~> 2.0.1"
}

provider "local" {
  version = "~> 1.2.2"
}

provider "external" {
  version = "~> 1.1.2"
}

provider "aws" {
  version = "~> 2.11.0"
}

provider "helm" {
  version = "~> 0.9.1"
}
