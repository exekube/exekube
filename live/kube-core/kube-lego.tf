resource "helm_release" "kube_lego" {
  name       = "kube-lego"
  repository = "${var.helm_stable_repo_url}"
  chart      = "kube-lego"
  values     = "${file("/exekube/live/kube/kube-lego.yaml")}"
  depends_on = ["helm_release.ingress_controller"]

  provisioner "local-exec" {
    command = "sleep 30"
  }
}
