resource "helm_release" "jenkins_dev" {
  count      = 1

  name       = "jenkins-dev"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart      = "jenkins"
  values     = "${file("/exekube/live/kube/apps/jenkins-dev.yaml")}"
}
