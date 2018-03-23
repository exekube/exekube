# ------------------------------------------------------------------------------
# REQUIRED VARIABLES
# ------------------------------------------------------------------------------

variable "project_id" {
  description = "Project where resources will be created"
}

variable "serviceaccount_key" {
  description = "Service account key for the project"
}

# ------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# ------------------------------------------------------------------------------

variable "project_services" {
  type        = "list"
  description = "The APIs to enable for the project"

  default = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "containerregistry.googleapis.com",
    "cloudkms.googleapis.com",
    "dns.googleapis.com",
  ]
}

variable "cluster_subnets" {
  type        = "map"
  description = "A map of index to a comma separated list of `region,nodes-subnet,pods-subnet,services-subnet` string."

  default = {
    # index = "region,nodes-subnet,pods-subnet,services-subnet"
    "0" = "europe-west1,10.16.0.0/20,10.17.0.0/16,10.18.0.0/16"
  }
}

variable "create_static_ip_address" {
  default = true
}

variable "dns_zones" {
  type        = "map"
  description = "External DNS zones that will be used for this environment"

  # Example: {"prod-internal-zone" = "prod.example.com."}
  default = {}
}

variable "dns_records" {
  type = "map"

  # Example: {"prod-internal-zone" = "*.prod.example.com."}
  default = {}
}
