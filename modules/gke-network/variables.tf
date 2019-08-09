# ------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# ------------------------------------------------------------------------------

variable "cluster_subnets" {
  type        = "map"
  description = "A map of index to a comma separated list of `region,nodes-subnet,pods-subnet,services-subnet` string."

  default = {
    # index = "region,nodes-subnet,pods-subnet,services-subnet"
    "0" = "europe-north1,10.16.0.0/20,10.17.0.0/16,10.18.0.0/16"
  }
}

variable "create_static_ip_address" {
  default = true
}

variable "delete_default_network" {
  default = true
}

variable "static_ip_region" {
  default = "europe-north1"
}

variable "dns_zones" {
  type        = "map"
  description = "Add DNS zones that will be used for this environment"

  # Example: {"prod-internal-zone" = "prod.example.com."}
  default = {}
}

variable "dns_records" {
  description = "Add DNS A-records pointing to our static IP address"
  type        = "map"

  # Example: {"prod-internal-zone" = "*.prod.example.com."}
  default = {}
}
