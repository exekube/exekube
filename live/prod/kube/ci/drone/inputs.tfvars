# Files in ./secrets directory must NOT have a trailing newline!

release_spec = {
  enabled        = true
  release_name   = "drone"
  release_values = "values.yaml"

  chart_repo    = "private"
  chart_name    = "drone"
  chart_version = "0.3.0"

  domain_name = "ci.swarm.pw"
}

pre_hook = {
  command = <<-EOF
            kubectl create secret generic drone-drone \
            --from-file=/exekube/live/prod/kube/ci/drone/secrets/ || true \
            && cd /exekube/charts/drone/ \
            && bash push.sh \
            && helm repo update
            EOF
}
