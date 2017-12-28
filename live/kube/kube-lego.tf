resource "helm_release" "kube_lego" {
  name       = "kube-lego"
  repository = "${helm_repository.stable.metadata.0.name}"
  chart      = "kube-lego"
  values     = "${file("/exekube/live/kube/kube-lego.yaml")}"
  depends_on = ["helm_release.ingress_controller"]

  provisioner "local-exec" {
    command = "sleep 30"
  }
}
