resource "helm_release" "ghost" {
  name       = "ghost"
  repository = "${helm_repository.stable.metadata.0.name}"
  chart      = "ghost"
  values     = "${file("/exekube/live/kube/ghost.yaml")}"
  depends_on = ["cloudflare_record.c6ns_pw"]
}
