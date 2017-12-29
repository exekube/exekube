resource "helm_release" "jenkins" {
  name       = "jenkins"
  repository = "${helm_repository.stable.metadata.0.name}"
  chart      = "jenkins"
  values     = "${file("/exekube/live/kube/jenkins.yaml")}"
  depends_on = ["cloudflare_record.c6ns_pw"]
}
