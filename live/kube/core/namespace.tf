resource "kubernetes_namespace" "core" {
  metadata {
    name = "terraform-xk-core-namespace"
  }
}
