# Files in ./secrets directory must NOT have a trailing newline!

release_spec = {
  enabled        = true
  release_name   = "concourse"
  release_values = "values.yaml"

  chart_repo    = "private"
  chart_name    = "concourse"
  chart_version = "1.0.0"

  domain_name = "ci.swarm.pw"
}

pre_hook = {
  command = <<-EOF
            kubectl create secret generic concourse-concourse \
            --from-file=$XK_LIVE_DIR/kube/ci/concourse/secrets/ || true \
            && cd $XK_LIVE_DIR/../../charts/concourse/ \
            && bash push.sh \
            && helm repo update
            EOF
}
