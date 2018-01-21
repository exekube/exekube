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
}

post_hook = {
  command = <<-EOF
            kubectl apply -f /exekube/backup/tls/secret.yaml
            EOF
}
