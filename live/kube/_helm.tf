// we use same default credentials that are used for `kubectl`
provider "helm" {}

resource "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"
}
