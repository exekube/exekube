resource "helm_release" "ingress_controller" {
  name       = "my-ingress-controller"
  repository = "${var.helm_stable_repo_url}"
  chart      = "nginx-ingress"
  values     = "${file("/exekube/live/kube/core/ingress-controller.yaml")}"

  provisioner "local-exec" {
    command = "sleep 15"
  }
}
