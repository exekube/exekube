data "template_file" "drone" {
  template = "${file("/exekube/live/kube/drone.yaml")}"

  vars {
    domain_zone = "${var.cloudflare_domain_zone}"
  }
}

resource "helm_release" "drone" {
  depends_on = ["cloudflare_record.web"]
  count      = 0

  name       = "drone"
  repository = "${var.helm_incubator_repo_url}"
  chart      = "drone"
  values     = "${data.template_file.drone.rendered}"
}
