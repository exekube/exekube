# Files in ./secrets directory must NOT have a trailing newline!

release_spec = {
  enabled        = false
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
            --from-file=$XK_LIVE_DIR/kube/ci/drone/secrets/ || true \
            && cd $XK_LIVE_DIR/../../charts/drone/ \
            && bash push.sh \
            && helm repo update
            EOF
}
