variable "chartmuseum" {
  type = "map"
}

variable "rails_app" {
  type = "map"

  default = {
    enabled = false
    values_file = "values/rails-app.yaml"
    release_name = "app"
    domain_name = ""
  }
}
