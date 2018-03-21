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
    common_name  = "helm-tiller-ca"
    organization = "helm-tiller"
  }
}

/*
resource "local_file" "ca_key" {
  filename = "${var.secrets_dir}/${var.tiller_namespace}/helm-tiller/ca.key.pem"
  content  = "${tls_private_key.root.private_key_pem}"
}
*/

resource "local_file" "ca_cert" {
  filename = "${var.secrets_dir}/${var.tiller_namespace}/helm-tiller/ca.cert.pem"
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
  filename = "${var.secrets_dir}/${var.tiller_namespace}/helm-tiller/tiller.key.pem"
  content  = "${tls_private_key.tiller_server.private_key_pem}"
}

resource "local_file" "tiller_cert" {
  filename = "${var.secrets_dir}/${var.tiller_namespace}/helm-tiller/tiller.cert.pem"
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
    organization = "helm-tiller"
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
  filename = "${var.secrets_dir}/${var.tiller_namespace}/helm-tiller/helm.key.pem"
  content  = "${tls_private_key.helm_client.private_key_pem}"
}

resource "local_file" "helm_cert" {
  filename = "${var.secrets_dir}/${var.tiller_namespace}/helm-tiller/helm.cert.pem"
  content  = "${tls_locally_signed_cert.helm_client.cert_pem}"
}
