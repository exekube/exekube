# Use Google Cloud SDK image from Docker Hub as our base
FROM google/cloud-sdk:183.0.0-alpine

# Install openssl (for kubectl), gcloud alpha and beta extensions,
# kubectl binary, helm binary, and terraform binary
RUN apk add --no-cache \
        openssl \
        && gcloud components install alpha beta kubectl \
        && curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash \
        && curl -o ./terraform.zip https://releases.hashicorp.com/terraform/0.11.2/terraform_0.11.2_linux_amd64.zip \
        && unzip terraform.zip \
        && mv terraform /usr/bin \
        && curl -L -o ./terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v0.13.23/terragrunt_linux_amd64 \
        && chmod 0700 terragrunt \
        && mv terragrunt /usr/bin

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT [ "docker-entrypoint.sh" ]

COPY vendor/terraform-provider-helm_linux_amd64 /root/.terraform.d/plugins/terraform-provider-helm_v0.6.0
