// we use same default credentials that are used for `kubectl`
provider "kubernetes" {}

# This is a Kubernetes namespace we create as a proof-of-concept
# for declaratively managing Kubernetes objects directly with Terraform and HCL
resource "kubernetes_namespace" "example" {
  metadata {
    annotations {
      name = "example-annotation"
    }

    labels {
      mylabel = "label-value"
    }

    name = "terraform-example-namespace"
  }
}
