resource "helm_release" "drone" {
  count      = 0
  depends_on = ["cloudflare_record.c6ns_pw"]

  name       = "drone"
  repository = "${helm_repository.incubator.metadata.0.name}"
  chart      = "drone"
  values     = "${file("/exekube/live/kube/drone.yaml")}"
}
