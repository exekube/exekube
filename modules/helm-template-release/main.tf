provider "local" {}

# ------------------------------------------------------------------------------
# HELM RELEASE (TILLERLESS)
# ------------------------------------------------------------------------------

// Use `helm template` then `kubectl apply -f` to install a remote chart
resource "null_resource" "helm_template_release" {
  count      = "${var.disable_release ? 0 : 1}"
  depends_on = ["null_resource.kubernetes_yaml"]

  triggers {
    values = "${data.template_file.release_values.rendered}"
  }

  provisioner "local-exec" {
    command = <<EOF
helm fetch \
--untar --version ${var.chart_version} \
${var.chart_repo}/${var.chart_name} \
&& helm template \
--values ${local_file.interpolated_values.filename} \
--name ${var.release_name} \
--namespace ${var.release_namespace} \
${path.root}/${var.chart_name} > ${path.root}/release.yaml \
&& kubectl apply -f ${path.root}/release.yaml
EOF
  }
}

// We use a separate 'null_resource' so that update doesn't cause a destroy
resource "null_resource" "helm_template_release_destroy" {
  count = "${var.prevent_destroy ? 0 : 1}"

  provisioner "local-exec" {
    when    = "destroy"
    command = "kubectl delete -f ${path.root}/release.yaml"
  }
}

// Parsed (interpolated) YAML values file
data "template_file" "release_values" {
  template = "${file("${var.release_values}")}"

  vars {
    domain_name        = "${var.domain_name}"
    load_balancer_ip   = "${var.load_balancer_ip}"
    ingress_basic_auth = "${var.ingress_basic_auth["secret_name"]}"
  }
}

resource "local_file" "interpolated_values" {
  filename = "${path.root}/${var.release_values}"
  content  = "${data.template_file.release_values.rendered}"
}

# ------------------------------------------------------------------------------
# Create a Kubernetes secret before installing the chart
# ------------------------------------------------------------------------------

resource "null_resource" "kubernetes_yaml" {
  count = "${var.disable_release ? 0 : length(var.kubernetes_yaml)}"

  provisioner "local-exec" {
    command = "kubectl apply -f ${element(var.kubernetes_yaml, count.index)}"
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "kubectl delete -f ${element(var.kubernetes_yaml, count.index)}"
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
