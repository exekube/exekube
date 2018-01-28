# Use Google Cloud SDK image from Docker Hub as our base
FROM google/cloud-sdk:183.0.0-alpine

# Install openssl (used for kubectl), tar, gcloud alpha and beta extensions,
# kubectl, helm, terraform, terragrunt, ark, and terraform-provider-helm plugin
RUN apk add --no-cache \
        openssl \
        tar \
        ca-certificates \
        apache2-utils

RUN gcloud components install alpha beta kubectl \
        && gcloud components update

RUN curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash \
        && curl -o ./terraform.zip https://releases.hashicorp.com/terraform/0.11.2/terraform_0.11.2_linux_amd64.zip \
        && unzip terraform.zip \
        && mv terraform /usr/bin \
        && rm -rf terraform.zip

RUN curl -L -o ./terragrunt \
        https://github.com/gruntwork-io/terragrunt/releases/download/v0.13.23/terragrunt_linux_amd64 \
        && chmod 0700 terragrunt \
        && mv terragrunt /usr/bin

RUN curl -L -o ./ark.tar.gz \
        https://github.com/heptio/ark/releases/download/v0.6.0/ark-v0.6.0-linux-amd64.tar.gz \
        && tar -xvzf ark.tar.gz \
        && rm -rf ark.tar.gz \
        && chmod 0700 ark \
        && mv ark /usr/bin

RUN curl -L -o ./terraform-provider-helm_v0.6.0 \
        https://github.com/burdiyan/terraform-provider-helm/releases/download/v0.6.0/terraform-provider-helm_linux_amd64 \
        && chmod 0700 terraform-provider-helm_v0.6.0 \
        && mkdir -p /root/.terraform.d/plugins/ \
        && mv terraform-provider-helm_v0.6.0 /root/.terraform.d/plugins/

RUN curl -L https://releases.hashicorp.com/vault/0.9.2/vault_0.9.2_linux_amd64.zip -o vault.zip \
  && unzip vault.zip \
  && rm vault.zip \
  && chmod +x vault \
  && mv vault /usr/bin

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT [ "docker-entrypoint.sh" ]
