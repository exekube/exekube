release_spec = {
  enabled     = true
  domain_name = "registry.swarm.pw"

  release_name   = "docker-registry"
  release_values = "values.yaml"

  chart_repo    = "stable"
  chart_name    = "docker-registry"
  chart_version = "1.0.1"
}

pre_hook = {
  command = <<EOF
mkdir -p tmp \
&& echo -n registry-new-admin > tmp/docker-registry-username \
&& echo -n $(openssl rand -hex 18) > tmp/docker-registry-password
EOF
}

post_hook = {
  command = "rm -rf tmp"
}

basic_auth = {
  username_file = "tmp/docker-registry-username"
  password_file = "tmp/docker-registry-password"
  secret_name   = "registry-htpasswd"
}
