# Make sure to create the "concourse-concourse" secret
# Files in secrets directory must NOT have a trailing newline!

pre_hook = {
  command = <<-EOF
            sleep 15 \
            && kubectl create secret generic concourse-concourse \
            --from-file=/exekube/live/prod/ci/concourse/secrets/ \
            || true \
            && cd /exekube/charts/concourse/ \
            && bash push.sh \
            && helm repo update
            EOF
}

release_spec = {
  enabled        = false
  release_name   = "concourse"
  release_values = "values.yaml"

  chart_repo    = "private"
  chart_name    = "concourse"
  chart_version = "1.0.0"

  domain_name = "ci.swarm.pw"
}
