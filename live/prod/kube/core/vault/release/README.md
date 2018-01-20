# Vault Helm release

## Kubernetes Auth Backend

<https://www.hashicorp.com/blog/hashicorp-vault-0-8-3>

> Vault 0.8.3 introduces native Kubernetes auth backend that allows Kubernetes pods to directly receive and use Vault auth tokens without additional integration components.

Prior to 0.8.3, a user accessing Vault via a pod required significant preparation work using an init pod or other custom interface. With the release of the Kubernetes auth backend, Vault now provides a production-ready interface for Kubernetes that allows a pod to authenticate with Vault via a JWT token from a pod’s service account.

View the documentation for more information on the Kubernetes auth backend.

For more information on the collaboration between Google and HashiCorp Vault, check out “Secret and infrastructure management made easy with HashiCorp and Google Cloud” and “Authenticating to Hashicorp Vault using GCE Signed Metadata” published by Google.

# Test connection

```sh
xk kubectl port-forward <vault-pod-name> 443:8200 &>/dev/null &
```

## Use HTTP (cURL)

https://www.vaultproject.io/api/

```sh
docker ps

docker exec <local-container-id> curl -k -vv https://localhost/v1/sys/seal-status/

# add payload.json to root repo to access via curl
# https://www.vaultproject.io/api/system/init.html
docker exec <local-container-id> curl --request PUT -s -k --data @payload.json https://localhost/v1/sys/init
```

## Use Vault CLI

```sh
docker exec <local-container-id> vault init
```
