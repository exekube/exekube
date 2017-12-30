data "template_file" "jenkins" {
  template = "${file("/exekube/live/kube/jenkins.yaml")}"

  vars {
    domain_zone = "${var.cloudflare_domain_zone}"
  }
}

resource "helm_release" "jenkins" {
  depends_on = ["cloudflare_record.web"]
  count      = 1

  name       = "jenkins"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart      = "jenkins"
  values     = "${data.template_file.jenkins.rendered}"
}
