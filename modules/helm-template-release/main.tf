provider "local" {}

# INTERPOLATE -> (FETCH) -> TEMPLATE -> INJECT -> APPLY

# ------------------------------------------------------------------------------
# INTERPOLATE VALUES
# ------------------------------------------------------------------------------

data "template_file" "release_values" {
  template = "${file("${var.release_values}")}"

  vars {
    domain_name        = "${var.domain_name}"
    load_balancer_ip   = "${var.load_balancer_ip}"
    ingress_basic_auth = "${var.ingress_basic_auth["secret_name"]}"
  }
}

resource "local_file" "values_file" {
  filename = "${path.root}/${var.release_values}"
  content  = "${data.template_file.release_values.rendered}"
}

# ------------------------------------------------------------------------------
# TEMPLATE HELM CHART INTO YAML MANIFEST FILE
# ------------------------------------------------------------------------------

resource "null_resource" "helm_fetch" {
  count = "${var.chart_repo == "" ? 0 : 1}"

  triggers {
    chart  = "${var.chart_version}"
    values = "${data.template_file.release_values.rendered}"
  }

  provisioner "local-exec" {
    command = <<EOF
helm fetch --untar --version ${var.chart_version} \
${var.chart_repo}/${var.chart_name}
EOF
  }
}

resource "null_resource" "helm_template" {
  depends_on = ["null_resource.helm_fetch"]

  triggers {
    chart  = "${var.chart_version}"
    values = "${data.template_file.release_values.rendered}"
  }

  provisioner "local-exec" {
    command = <<EOF
helm template \
--values ${local_file.values_file.filename} \
--name ${var.release_name} \
--namespace ${var.release_namespace} \
${path.root}/${var.chart_name} > ${path.root}/release.yaml
EOF
  }
}

# ------------------------------------------------------------------------------
# INJECT ISTIO ENVOY SIDECARS INTO WORKLOADS
# ------------------------------------------------------------------------------

resource "null_resource" "istio_inject" {
  count      = "${var.istio_inject ? 1 : 0}"
  depends_on = ["null_resource.helm_template"]

  triggers {
    chart  = "${var.chart_version}"
    values = "${data.template_file.release_values.rendered}"
  }

  provisioner "local-exec" {
    command = <<EOF
istioctl kube-inject \
--filename ${path.root}/release.yaml \
--output ${path.root}/release-injected.yaml
EOF
  }
}

# ------------------------------------------------------------------------------
# APPLY THE FINAL MANIFEST
# ------------------------------------------------------------------------------

resource "null_resource" "kubectl_apply" {
  depends_on = [
    "null_resource.kubernetes_yaml",
    "null_resource.helm_template",
    "null_resource.istio_inject",
  ]

  triggers {
    chart  = "${var.chart_version}"
    values = "${data.template_file.release_values.rendered}"
  }

  provisioner "local-exec" {
    command = <<EOF
kubectl --namespace ${var.release_namespace} \
apply -f \
${path.root}/${var.istio_inject ? "release-injected" : "release"}.yaml
EOF
  }
}

# ------------------------------------------------------------------------------
# DESTROY THE MANIFEST
# ------------------------------------------------------------------------------

resource "null_resource" "kubectl_delete" {
  count = "${var.prevent_destroy ? 0 : 1}"

  provisioner "local-exec" {
    when       = "destroy"
    on_failure = "continue"
    command    = <<EOF
kubectl --namespace ${var.release_namespace} \
delete -f ${path.root}/release.yaml
EOF
  }
}

# ------------------------------------------------------------------------------
# Create a Kubernetes secret before installing the chart
# ------------------------------------------------------------------------------

resource "null_resource" "kubernetes_yaml" {
  count = "${length(var.kubernetes_yaml)}"

  provisioner "local-exec" {
    command = <<EOF
kubectl --namespace ${var.release_namespace} \
apply -f ${element(var.kubernetes_yaml, count.index)}
EOF
  }

  provisioner "local-exec" {
    when    = "destroy"
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
  count = "${var.ingress_basic_auth["secret_name"] == "" ? 0 : 1}"

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
