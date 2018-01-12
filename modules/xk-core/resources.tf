# ------------------------------------------------------------------------------
# Create a Kubernetes namespace [TBD]
# ------------------------------------------------------------------------------

resource "kubernetes_namespace" "core" {
  count = 0

  metadata {
    name = "terraform-xk-core-namespace"
  }
}

# ------------------------------------------------------------------------------
# Use LoadBalancer IP to create a CloudFlare DNS record
# ------------------------------------------------------------------------------

resource "cloudflare_record" "web" {
  depends_on = ["helm_release.ingress_controller"]
  count      = "${length(var.cluster_dns_zones)}"

  domain   = "${element(var.cluster_dns_zones, count.index)}"
  name     = "*"
  value    = "${data.kubernetes_service.ingress_controller.load_balancer_ingress.0.ip}"
  type     = "A"
  ttl      = 120
  proxied  = false
  priority = 0
}

data "kubernetes_service" "ingress_controller" {
  depends_on = ["helm_release.ingress_controller"]

  metadata {
    name = "cluster-proxy-nginx-ingress-controller"
  }
}

# ------------------------------------------------------------------------------
# Install core Helm charts
# ------------------------------------------------------------------------------

resource "helm_release" "ingress_controller" {
  count = "${var.ingress_controller["enabled"]}"

  name       = "cluster-proxy"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart      = "nginx-ingress"
  values     = "${file("${format("%s/%s", path.module, var.ingress_controller["values_file"])}")}"

  provisioner "local-exec" {
    command = "sleep 15"
  }
}

resource "helm_release" "kube_lego" {
  depends_on = ["helm_release.ingress_controller"]
  count      = "${var.kube_lego["enabled"]}"

  name       = "kube-lego"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart      = "kube-lego"
  values     = "${file("${format("%s/%s", path.module, var.kube_lego["values_file"])}")}"

  provisioner "local-exec" {
    command = "sleep 30"
  }
}
