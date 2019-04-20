# ------------------------------------------------------------------------------
# TERRAFORM / PROVIDERS CONFIG
# ------------------------------------------------------------------------------

terraform {
  backend "gcs" {}
}

provider "local" {}
provider "tls" {}

# ------------------------------------------------------------------------------
# CA / ROOT CERTIFICATE
# ------------------------------------------------------------------------------

locals {
  tls_dir       = "${var.custom_tls_dir == "" ? var.tiller_namespace : var.custom_tls_dir}"
  rbac_filename = "${var.tiller_namespace == "kube-system" ? "rbac-cluster.yaml" : "rbac-ns.yaml"}"
}

data "template_file" "tiller_rbac" {
  template = "${file("${format("%s/%s", path.module, local.rbac_filename)}")}"

  vars {
    tiller_namespace = "${var.tiller_namespace}"
  }
}

# tiller_status is introduced as a way to to make sure helm is reinstalled if
# the cluster is recreated and/or tiller is broken or not present
#
# This introduces undesired behavior that tiller will be deployed twice,
# as the trigger mechanism is not based on the state, but rather on the change
# of the state. So:
# - 1st run: resource does not exist, the trigger is evaluated to random number
#   -> resource is created
# - 2nd run: resource does exist, but the trigger changed to "1" -> resource
#   is recreated
# - 3rd and subsequent runs: resource does exist, trigger stays "1" -> no
#   changes unless the tiller is deleted or stops working, if that happens
#   the trigger changes and cycle described above will repeat once more

data "external" "tiller_status" {
  program = [
    "bash",
    "-c",
    "REPLICAS=$$(kubectl get deploy tiller-deploy -n ${var.tiller_namespace} -o jsonpath='{.status.readyReplicas}'); [ \"$$REPLICAS\" != \"1\" ] && REPLICAS=\"$$RANDOM\"; jq -n --arg replicas \"$$REPLICAS\" '{readyReplicas:$$replicas}'",
  ]
}

resource "null_resource" "install_tiller" {
  triggers {
    tiller_ready_replicas = "${data.external.tiller_status.result.readyReplicas}"
  }

  provisioner "local-exec" {
    command = <<EOF
      echo '${data.template_file.tiller_rbac.rendered}' | kubectl apply -f - \
      && helm init \
        --tiller-namespace ${var.tiller_namespace} \
        --service-account tiller \
        --tiller-tls \
        --tiller-tls-verify \
        --tls-ca-cert=${local_file.ca_cert.filename} \
        --tiller-tls-cert=${local_file.tiller_cert.filename} \
        --tiller-tls-key=${local_file.tiller_key.filename} \
        --override 'spec.template.spec.containers[0].command'='{/tiller,--storage=secret}'
      RETRIES=10
      RETRY_COUNT=1
      TILLER_READY="false"
      while [ "$TILLER_READY" != "true" ]; do
        echo "[Try $RETRY_COUNT of $RETRIES] Waiting for Tiller..."
        helm version \
          --tls --tls-verify \
          --tls-ca-cert=${local_file.ca_cert.filename} \
          --tls-cert=${local_file.helm_cert.filename} \
          --tls-key=${local_file.helm_key.filename} \
          --tiller-connection-timeout ${var.tiller_connection_timeout} > /dev/null 2> /dev/null
        if [ "$?" == "0" ]; then
          TILLER_READY="true"
        fi
        if [ "$RETRY_COUNT" == "$RETRIES" ] && [ "$TILLER_READY" != "true" ]; then
          echo "Retry limit reached, giving up!"
          exit 1
        fi
        if [ "$TILLER_READY" != "true" ]; then
          sleep 10
        fi
        RETRY_COUNT=$(($RETRY_COUNT+1))
      done
      helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com \
      && helm repo update
    EOF
  }

  provisioner "local-exec" {
    when = "destroy"

    command = <<EOF
      helm reset --force \
        --tiller-namespace ${var.tiller_namespace} \
        --tls --tls-verify \
        --tls-ca-cert=${local_file.ca_cert.filename} \
        --tls-cert=${local_file.helm_cert.filename} \
        --tls-key=${local_file.helm_key.filename} \
        --tiller-connection-timeout ${var.tiller_connection_timeout}
    EOF
  }
}

# Root CA Key
resource "tls_private_key" "root" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P521"
}

# Root CA cert
resource "tls_self_signed_cert" "root" {
  key_algorithm   = "ECDSA"
  private_key_pem = "${tls_private_key.root.private_key_pem}"

  validity_period_hours = 26280
  early_renewal_hours   = 8760

  is_ca_certificate = true

  allowed_uses = ["cert_signing"]

  subject {
    common_name  = "Helm CA"
    organization = "Helm"
  }
}

/*
resource "local_file" "ca_key" {
  filename = "${var.secrets_dir}/${local.tls_dir}/${var.helm_dir_name}/ca.key.pem"
  content  = "${tls_private_key.root.private_key_pem}"
}
*/

resource "local_file" "ca_cert" {
  filename = "${var.secrets_dir}/${local.tls_dir}/${var.helm_dir_name}/ca.cert.pem"
  content  = "${tls_self_signed_cert.root.cert_pem}"
}

# ------------------------------------------------------------------------------
# TILLER SERVER CERTIFICATE
# ------------------------------------------------------------------------------

# Tiller server key
resource "tls_private_key" "tiller_server" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P521"
}

# Tiller server cert request
resource "tls_cert_request" "tiller_server" {
  key_algorithm   = "${tls_private_key.tiller_server.algorithm}"
  private_key_pem = "${tls_private_key.tiller_server.private_key_pem}"

  ip_addresses = [
    "127.0.0.1",
  ]

  dns_names = [
    "localhost",
  ]

  subject {
    common_name = "tiller-server"
  }
}

# Tiller server cert
resource "tls_locally_signed_cert" "tiller_server" {
  cert_request_pem = "${tls_cert_request.tiller_server.cert_request_pem}"

  ca_key_algorithm   = "${tls_private_key.root.algorithm}"
  ca_private_key_pem = "${tls_private_key.root.private_key_pem}"
  ca_cert_pem        = "${tls_self_signed_cert.root.cert_pem}"

  validity_period_hours = 17520
  early_renewal_hours   = 8760

  allowed_uses = ["server_auth"]
}

resource "local_file" "tiller_key" {
  filename = "${var.secrets_dir}/${local.tls_dir}/${var.helm_dir_name}/tiller.key.pem"
  content  = "${tls_private_key.tiller_server.private_key_pem}"
}

resource "local_file" "tiller_cert" {
  filename = "${var.secrets_dir}/${local.tls_dir}/${var.helm_dir_name}/tiller.cert.pem"
  content  = "${tls_locally_signed_cert.tiller_server.cert_pem}"
}

# ------------------------------------------------------------------------------
# HELM CLIENT CERTIFICATE
# ------------------------------------------------------------------------------

# Helm client key
resource "tls_private_key" "helm_client" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P521"
}

# Helm client cert request
resource "tls_cert_request" "helm_client" {
  key_algorithm   = "${tls_private_key.helm_client.algorithm}"
  private_key_pem = "${tls_private_key.helm_client.private_key_pem}"

  subject {
    common_name  = "helm-client"
    organization = "Helm"
  }
}

# Helm client self-signed cert
resource "tls_locally_signed_cert" "helm_client" {
  cert_request_pem = "${tls_cert_request.helm_client.cert_request_pem}"

  ca_key_algorithm   = "${tls_private_key.root.algorithm}"
  ca_private_key_pem = "${tls_private_key.root.private_key_pem}"
  ca_cert_pem        = "${tls_self_signed_cert.root.cert_pem}"

  validity_period_hours = 17520
  early_renewal_hours   = 8760

  allowed_uses = ["client_auth"]
}

resource "local_file" "helm_key" {
  filename = "${var.secrets_dir}/${local.tls_dir}/${var.helm_dir_name}/helm.key.pem"
  content  = "${tls_private_key.helm_client.private_key_pem}"
}

resource "local_file" "helm_cert" {
  filename = "${var.secrets_dir}/${local.tls_dir}/${var.helm_dir_name}/helm.cert.pem"
  content  = "${tls_locally_signed_cert.helm_client.cert_pem}"
}
