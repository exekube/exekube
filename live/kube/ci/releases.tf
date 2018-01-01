resource "helm_release" "jenkins_dev" {
  count      = 1

  name       = "jenkins-dev"
  repository = "${var.helm_stable_repo_url}"
  chart      = "jenkins"
  values     = "${file("/exekube/live/kube/ci/values/jenkins-dev.yaml")}"
}
