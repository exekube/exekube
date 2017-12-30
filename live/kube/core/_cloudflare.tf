variable "cloudflare_email" {}
variable "cloudflare_token" {}
variable "cloudflare_domain_zone" {}

provider "cloudflare" {
  email = "${var.cloudflare_email}"
  token = "${var.cloudflare_token}"
}

resource "cloudflare_record" "web" {
  depends_on = ["helm_release.ingress_controller"]

  domain   = "${var.cloudflare_domain_zone}"
  name     = "*"
  value    = "${data.kubernetes_service.ingress_controller.load_balancer_ingress.0.ip}"
  type     = "A"
  proxied  = false
  priority = 0
}

data "kubernetes_service" "ingress_controller" {
  depends_on = ["helm_release.ingress_controller"]

  metadata {
    name = "my-ingress-controller-nginx-ingress-controller"
  }
}
