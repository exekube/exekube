release_spec = {
  enabled        = true
  release_name   = "vault"
  release_values = "values.yaml"

  chart_repo    = "incubator"
  chart_name    = "vault"
  chart_version = "0.3.0"
}

pre_hook = {
  command = <<-EOF
            kubectl create secret generic gcp-credentials-vault \
            --from-file=/exekube/live/prod/core/vault/secrets/gcp-credentials/ || true \
            && kubectl create secret generic vault-tls \
            --from-file=/exekube/live/prod/core/vault/secrets/vault-tls/ || true
            EOF
}

post_hook = {
  command = "echo kubectl port-forward"
}
