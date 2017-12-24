# Use Google Cloud SDK image from Docker Hub as our base
FROM google/cloud-sdk:183.0.0-alpine

# Install openssl (for kubectl), kubectl binary, helm binary, and terraform binary
RUN apk add --no-cache \
        openssl \
        && gcloud components install kubectl alpha beta \
        && curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash \
        && curl -o ./terraform.zip https://releases.hashicorp.com/terraform/0.11.1/terraform_0.11.1_linux_amd64.zip \
        && unzip terraform.zip \
        && mv terraform /usr/bin
