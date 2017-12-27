resource "helm_release" "ingress_controller" {
  name = "my-ingress-controller"
  repository = "${helm_repository.stable.metadata.0.name}"
  chart = "nginx-ingress"
  values = "${file("/exekube/live/helm-releases/ingress-controller.yaml")}"
}
