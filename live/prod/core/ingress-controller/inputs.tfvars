cluster_dns_zones = [
  "swarm.pw",
]

release_spec = {
  enabled        = true
  release_name   = "ingress-controller"
  release_values = "values.yaml"

  chart_repo    = "stable"
  chart_name    = "nginx-ingress"
  chart_version = "0.8.23"

  post_hook = <<-EOF
              kubectl apply -f /exekube/backup/tls/secret.yaml \
              && kubectl create secret generic drone-drone \
              --from-file=/exekube/live/prod/ci/drone/secrets/
              EOF
}
