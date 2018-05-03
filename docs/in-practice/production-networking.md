# Configure production-grade networking

!!! warning
    This article is incomplete

## Purpose: securely expose a public service / application

At the end of the [Getting started with Exekube](https://docs.exekube.com/in-practice/getting-started) tutorial , we used `kubectl proxy` to access our services in the cluster. It is indeed the preferred method for private services, but what if we want to expose a web application or web API to the public?

## Resources we'll add to base-project

In order to set up secure discoverability for our public services, we'll do the following:

- Create a static IP address
- Set up a custom DNS zone
- Create DNS A-records that will point to the static IP address
- Add a Kubernetes ingress controller as the gateway to our public services
- Create *cert-manager* Issuer and Certificate resources to enable TLS-encrypted communication with clients
- Add `kind: Ingress` resources for each of our public services

## Tutorial

There's no tutorial yet. See these modules in example projects below:

- gke-network
- cert-manager
- nginx-ingress

Don't forget to configure

- Project modules in the `modules/<module-name>` directory
- Live modules in `live/<env>` directory

## Example projects

These Exekube example projects have services that are exposed publicly:

- [exekube/demo-apps-project](https://github.com/exekube/demo-apps-project): Project with generic web applications (Ruby on Rails, React)
- [exekube/demo-grpc-project](https://github.com/exekube/demo-grpc-project): Project for using `NetworkPolicy` resources to secure namespaces for a gRPC server app and its REST client app
- [exekube/demo-ci-project](https://github.com/exekube/demo-ci-project): Project for  private CI tools (Concourse, Docker Registry, ChartMuseum)
- [exekube/demo-istio-project](https://github.com/exekube/demo-istio-project): Playground for getting to know the Istio mesh framework
