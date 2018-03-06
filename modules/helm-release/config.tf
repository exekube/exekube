terraform {
  backend "gcs" {}
}

provider "local" {}

provider "helm" {}

provider "kubernetes" {}
