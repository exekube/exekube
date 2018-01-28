# Vault on Kubernetes

## Test access to Vault from local machine

```sh
xk kubectl port-forward <vault-pod-name> 443:8200

docker ps
```

### Use HTTP (cURL)

https://www.vaultproject.io/api/

```sh
docker exec <local-container-id> curl -k -vv https://localhost/v1/sys/seal-status/

# https://www.vaultproject.io/api/system/init.html
docker exec <local-container-id> curl --request PUT -s -k --data '{"secret_shares": 5, "secret_threshold": 3}' https://localhost/v1/sys/init
```

### Use Vault CLI

```sh
docker exec -it <local-container-id> bash

bash-4.3# vault init
```

### Test access to Vault from a cluster pod

```bash
xk kubectl run my-shell --rm -i --tty --image ubuntu -- bash

apt-get update
apt-get install curl
curl -k --request PUT --data '{"secret_shares": 5, "secret_threshold": 3}' https://vault-vault:8200/v1/sys/init
```

## Notes and links

### Example implementation by CoreOS Tectonic

https://coreos.com/tectonic/docs/latest/account/create-account.html

### Kubernetes Auth Backend

<https://www.hashicorp.com/blog/hashicorp-vault-0-8-3>

> tl;dr; Every Kubernetes pod gets a Service Account token that is automatically mounted at /var/run/secrets/kubernetes.io/serviceaccounts/token Now, you can use that token (JWT token) to also log into vault, if you enable the Kubernetes auth module and configure a Vault role for your Kubernetes service account.

> Vault 0.8.3 introduces native Kubernetes auth backend that allows Kubernetes pods to directly receive and use Vault auth tokens without additional integration components.

Prior to 0.8.3, a user accessing Vault via a pod required significant preparation work using an init pod or other custom interface. With the release of the Kubernetes auth backend, Vault now provides a production-ready interface for Kubernetes that allows a pod to authenticate with Vault via a JWT token from a pod’s service account.

View the documentation for more information on the Kubernetes auth backend.

For more information on the collaboration between Google and HashiCorp Vault, check out “Secret and infrastructure management made easy with HashiCorp and Google Cloud” and “Authenticating to Hashicorp Vault using GCE Signed Metadata” published by Google.
