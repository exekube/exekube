# ------------------------------------------------------------------------------
# PROVIDER
# ------------------------------------------------------------------------------

# Following code loads Helm certificates from files into Terraform data object.
# In case there are no certificate files, data will be populated with empty values
# so provider configuration can still be successful.
# This helps to achieve idempotence for destroy operation.
data "external" "client_auth" {
  program = [
    "sh",
    "-c",
    <<EOF
      ca_cert=$(cat ${var.client_auth}/ca.cert.pem 2>/dev/null)
      helm_cert=$(cat ${var.client_auth}/helm.cert.pem 2>/dev/null)
      helm_key=$(cat ${var.client_auth}/helm.key.pem 2>/dev/null)
      jq -n \
        --arg ca_cert "$ca_cert" \
        --arg helm_cert "$helm_cert" \
        --arg helm_key "$helm_key" \
        '{"ca_cert":$ca_cert,"helm_cert":$helm_cert,"helm_key":$helm_key}'
    EOF
    ,
  ]
}

provider "helm" {
  namespace      = "${var.tiller_namespace}"
  enable_tls     = true
  insecure       = false
  debug          = true
  install_tiller = false

  ca_certificate     = "${data.external.client_auth.result.ca_cert}"
  client_certificate = "${data.external.client_auth.result.helm_cert}"
  client_key         = "${data.external.client_auth.result.helm_key}"
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
    "${var.release_values_rendered}",
    "${data.template_file.release_values.rendered}",
    "${var.extra_values == "" ? "" : file(coalesce(var.extra_values,"/dev/null"))}",
  ]

  force_update     = "${var.force_update}"
  devel            = true
  disable_webhooks = false
  timeout          = 500
  reuse            = true
  recreate_pods    = false
}

# Parsed (interpolated) YAML values file
data "template_file" "release_values" {
  template = "${var.release_values == "" ? "" : file(coalesce(var.release_values,"/dev/null"))}"

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
