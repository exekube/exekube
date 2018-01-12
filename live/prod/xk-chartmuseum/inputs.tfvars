release = {
  enabled        = true
  release_name   = "chartmuseum"
  release_values = "values.yaml"

  chart_repo    = "https://kubernetes-charts-incubator.storage.googleapis.com"
  chart_name    = "chartmuseum"
  chart_version = "0.3.1"

  domain_name = "charts.sotkov.pw"

  basic_auth = "chartrepo.htpasswd"

  post_hook = <<-EOF
              sleep 15 && helm repo update
              EOF
}
