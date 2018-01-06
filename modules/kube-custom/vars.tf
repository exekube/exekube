variable "chartmuseum" {
  type = "map"
}

variable "cloudflare_dns_zones" {
  default = []
}

variable "rails_app" {
  type = "map"

  default = {
    enabled = false
    values_file = "values/rails-app.yaml"
    release_name = "app"
    domain_name = "app"
  }
}
