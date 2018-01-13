release_spec = {
  enabled     = true
  domain_name = "registry.swarm.pw"

  release_name   = "registry"
  release_values = "values.yaml"

  chart_repo    = "stable"
  chart_name    = "docker-registry"
  chart_version = "1.0.1"

  basic_auth = "registry.htpasswd"

  post_hook = <<-EOF
              sleep 5 && helm repo update
              EOF
}
