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
  depends_on = ["module.gke_cluster"]
}
