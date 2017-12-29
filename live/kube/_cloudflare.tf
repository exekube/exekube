provider "cloudflare" {
  email = "${var.cloudflare_email}"
  toke = "${var.cloudflare_token}"
}

resource "cloudflare_record" "c6ns_pw" {
  domain     = "${var.cloudflare_domain}"
  name       = "*"
  value      = "${data.kubernetes_service.ingress_controller.load_balancer_ingress.0.ip}"
  type       = "A"
  proxied    = false
  priority   = 1
  depends_on = ["helm_release.ingress_controller"]
}

data "kubernetes_service" "ingress_controller" {
  metadata {
    name = "my-ingress-controller-nginx-ingress-controller"
  }

  depends_on = ["helm_release.ingress_controller"]
}
