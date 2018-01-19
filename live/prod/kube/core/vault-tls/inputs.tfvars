ca_public_key_file_path = "/exekube/live/prod/kube/core/vault/secrets/vault-tls/ca.crt"

public_key_file_path = "/exekube/live/prod/kube/core/vault/secrets/vault-tls/server.crt"

private_key_file_path = "/exekube/live/prod/kube/core/vault/secrets/vault-tls/server.key"

owner = "root"

organization_name = "MY_ORG"

ca_common_name = "Cluster certs"

common_name = "Vault server"

dns_names = ["vault.local"]

ip_addresses = ["127.0.0.1"]

validity_period_hours = 6

# ca_allowed_uses = default = [
#    "cert_signing",
#    "key_encipherment",
#    "digital_signature",
#  ]
# allowed_uses = [
#    "key_encipherment",
#    "digital_signature",
#  ]
# permissions = "0600"
# private_key_algorithm = "RSA"
# private_key_ecdsa_curve = "P256"
# private_key_rsa_bits = "2048"
