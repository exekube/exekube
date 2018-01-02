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
    name = "cluster-proxy-nginx-ingress-controller"
  }
}
