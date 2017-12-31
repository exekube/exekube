# Use Google Cloud SDK image from Docker Hub as our base
FROM google/cloud-sdk:183.0.0-alpine

# Install openssl (for kubectl), gcloud alpha and beta extensions,
# kubectl binary, helm binary, and terraform binary
RUN apk add --no-cache \
        openssl \
        && gcloud components install alpha beta kubectl \
        && curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash \
        && curl -o ./terraform.zip https://releases.hashicorp.com/terraform/0.11.1/terraform_0.11.1_linux_amd64.zip \
        && unzip terraform.zip \
        && mv terraform /usr/bin

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT [ "docker-entrypoint.sh" ]

COPY vendor/terraform-provider-helm_linux_amd64 /root/.terraform.d/plugins/terraform-provider-helm_v0.5.0
