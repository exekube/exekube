# gke-network module

> According to https://cloud.google.com/solutions/prep-kubernetes-engine-for-prod:
>
> By default, you will have a network created in your project but it is recommended that you create and configure your own network to map to your existing IP address management (IPAM) convention. Firewall rules can then be applied with this network to filter traffic ingressing or egressing your Kubernetes Engine nodes. By default all internet traffic to your Kubernetes Engine nodes is denied.

This module creates networking resources for a GKE cluster.

By default, a regional static IP address will be reserved for use with a `LoadBalancer` type of Kubernetes service (usually for an ingress controller like nginx-ingress, traefic, gce-ingress, Istio / Envoy, etc.)

## Usage

```tf
provider "google" {
  project     = "${var.project_id}"
  credentials = "${var.serviceaccount_key}"
}

module "gke_network" {
  source = "/exekube-modules/gke-network"

  cluster_subnets = {
    # index = "region,nodes-subnet,pods-subnet,services-subnet"
    "0" = "europe-west1,10.16.0.0/20,10.17.0.0/16,10.18.0.0/16"
  }

  create_static_ip_address = true
  static_ip_region         = "europe-west1"

  dns_zones = {
    "prod-internal-zone" = "prod.example.com."
  }

  dns_records = {
    "prod-internal-zone" = "mydomain.prod.example.com."
  }
}
```

All module input variables and variable descriptions can be found in [variables.tf](https://github.com/exekube/exekube/blob/master/modules/gke-network/variables.tf).

## Resources created

By default:

- [`google_compute_network`](https://www.terraform.io/docs/providers/google/r/compute_network.html).`network`
- [`google_compute_subnetwork`](https://www.terraform.io/docs/providers/google/r/compute_subnetwork.html).`subnets`
- [`google_compute_firewall`](https://www.terraform.io/docs/providers/google/r/compute_firewall.html).`allow_nodes_internal`
- [`google_compute_firewall`](https://www.terraform.io/docs/providers/google/r/compute_firewall.html).`allow_pods_internal`
- [`null_resource`](https://www.terraform.io/docs/provisioners/null_resource.html).`delete_default_network`
- [`google_compute_address`](https://www.terraform.io/docs/providers/google/r/compute_address.html).`ingress_controller_ip`

If you configure the `dns_zones` and `dns_records` input variables, also these resources will be created:

- [`google_dns_managed_zone`](https://www.terraform.io/docs/providers/google/r/dns_managed_zone.html).`dns_zones`
- [`google_dns_record_set`](https://www.terraform.io/docs/providers/google/r/dns_record_set.html).`dns_records`
