resource "helm_release" "jenkins" {
  name = "jenkins"
  repository = "${helm_repository.stable.metadata.0.name}"
  chart = "jenkins"
  values = "${file("/exekube/live/helm-releases/jenkins.yaml")}"
  depends_on = ["helm_release.ingress_controller", "helm_release.kube_lego"]
}
