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
            --from-file=/exekube/live/prod/kube/ci/concourse/secrets/ || true \
            && cd /exekube/charts/concourse/ \
            && bash push.sh \
            && helm repo update
            EOF
}
