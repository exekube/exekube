# We need to input ChartMuseum credentials to be able to pull the app Helm chart from ChartMuseum
variable "chartmuseum" {
  type = "map"

  default = {
    username    = ""
    password    = ""
    domain_name = ""
  }
}

# App (Helm release) inputs
variable "rails_app" {
  type = "map"

  default = {
    enabled      = false
    values_file  = "values/rails-app.yaml"
    release_name = "app"
    domain_name  = ""
  }
}
