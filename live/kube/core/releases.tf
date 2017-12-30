resource "helm_release" "ingress_controller" {
  name       = "my-ingress-controller"
  repository = "${var.helm_stable_repo_url}"
  chart      = "nginx-ingress"
  values     = "${file("/exekube/live/kube/core/values/ingress-controller.yaml")}"

  provisioner "local-exec" {
    command = "sleep 15"
  }
}

resource "helm_release" "kube_lego" {
  name       = "kube-lego"
  repository = "${var.helm_stable_repo_url}"
  chart      = "kube-lego"
  values     = "${file("/exekube/live/kube/core/values/kube-lego.yaml")}"
  depends_on = ["helm_release.ingress_controller"]

  provisioner "local-exec" {
    command = "sleep 30"
  }
}
