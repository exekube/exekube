# [TBD]
# Has fatal bugs
# See https://github.com/ilyasotkov/exekube/issues/44

release_spec = {
  enabled        = false
  release_name   = "concourse"
  release_values = "values.yaml"

  chart_repo    = "private"
  chart_name    = "concourse"
  chart_version = "1.0.0"

  domain_name = "ci.swarm.pw"
}
