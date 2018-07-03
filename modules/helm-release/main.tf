# ------------------------------------------------------------------------------
# PROVIDER
# ------------------------------------------------------------------------------

provider "helm" {
  namespace  = "${var.tiller_namespace}"
  enable_tls = true
  insecure   = false
  debug      = true

  ca_certificate     = "${file("${var.client_auth}/ca.cert.pem")}"
  client_certificate = "${file("${var.client_auth}/helm.cert.pem")}"
  client_key         = "${file("${var.client_auth}/helm.key.pem")}"
}

# ------------------------------------------------------------------------------
# HELM RELEASE
# ------------------------------------------------------------------------------

resource "helm_release" "release" {
  count      = "${var.disable_release ? 0 : 1}"
  depends_on = ["null_resource.kubernetes_yaml"]

  repository = "${var.chart_repo}"
  chart      = "${var.chart_name}"
  version    = "${var.chart_version}"

  name      = "${var.release_name}"
  namespace = "${var.release_namespace}"

  values = [
    "${data.template_file.release_values.rendered}",
    "${var.extra_values == "" ? "" : file(coalesce(var.extra_values,"/dev/null"))}",
  ]

  force_update     = false
  devel            = true
  disable_webhooks = false
  timeout          = 500
  reuse            = true
  recreate_pods    = false
}

# Parsed (interpolated) YAML values file
data "template_file" "release_values" {
  template = "${file("${var.release_values}")}"

  vars {
    project_id         = "${var.project_id}"
    domain_name        = "${var.domain_name}"
    load_balancer_ip   = "${var.load_balancer_ip}"
    ingress_basic_auth = "${var.ingress_basic_auth["secret_name"]}"
  }
}

# ------------------------------------------------------------------------------
# Create a Kubernetes secret before installing the chart
# ------------------------------------------------------------------------------

resource "null_resource" "kubernetes_yaml" {
  count = "${var.disable_release ? 0 : length(var.kubernetes_yaml)}"

  provisioner "local-exec" {
    command = <<EOF
kubectl --namespace ${var.release_namespace} \
apply -f ${element(var.kubernetes_yaml, count.index)}
EOF
  }

  provisioner "local-exec" {
    when = "destroy"

    command = <<EOF
kubectl --namespace ${var.release_namespace} \
delete -f ${element(var.kubernetes_yaml, count.index)}
EOF
  }
}

# ------------------------------------------------------------------------------
# Create a Kubernetes secret for ingress basic authentication (htpasswd)
# ------------------------------------------------------------------------------

resource "null_resource" "ingress_basic_auth" {
  count = "${var.disable_release || var.ingress_basic_auth["secret_name"] == "" ? 0 : 1}"

  provisioner "local-exec" {
    command = <<EOF
kubectl --namespace ${var.release_namespace} \
create secret generic \
${var.ingress_basic_auth["secret_name"]} \
--from-literal=auth=$(echo -n ${file("${var.ingress_basic_auth["password"]}")} \
| htpasswd -i -n ${file("${var.ingress_basic_auth["username"]}")})
EOF
  }

  provisioner "local-exec" {
    when = "destroy"

    command = <<EOF
kubectl --namespace ${var.release_namespace} \
delete secret ${var.ingress_basic_auth["secret_name"]}
EOF
  }
}
