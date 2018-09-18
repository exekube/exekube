# ------------------------------------------------------------------------------
# First stage: compiling Exekube CLI
# ------------------------------------------------------------------------------
FROM golang:1.9-alpine AS builder

RUN apk add --no-cache \
        git

ENV GOPATH /build
WORKDIR /build

RUN go get \
        github.com/urfave/cli \
        github.com/sirupsen/logrus

ADD ./cli ./src/github.com/exekube/exekube/cli

RUN go build -o ./bin/xk github.com/exekube/exekube/cli

# ------------------------------------------------------------------------------
# Second stage: getting all runtime deps
# ------------------------------------------------------------------------------
FROM alpine:3.7

ENV CLOUD_SDK_VERSION 208.0.2
ENV KUBECTL_VERSION 1.10.5
ENV HELM_VERSION 2.9.1
ENV TERRAFORM_VERSION 0.11.7
ENV TERRAGRUNT_VERSION 0.14.10
ENV TERRAFORM_PROVIDER_HELM_VERSION 0.5.1

RUN apk --no-cache add \
        curl \
        python \
        py-crcmod \
        bash \
        libc6-compat \
        openssh-client \
        git \
        openssl \
        tar \
        ca-certificates \
        apache2-utils \
        tzdata \
        jq \
        ruby \
        ruby-json

RUN gem install --no-ri --no-rdoc rake

ENV PATH /google-cloud-sdk/bin:$PATH
RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz \
        && tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz \
        && rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz \
        && ln -s /lib /lib64 \
        && gcloud config set core/disable_usage_reporting true \
        && gcloud config set component_manager/disable_update_check true \
        && gcloud config set metrics/environment github_docker_image \
        && gcloud --version \
        && gcloud components install alpha beta \
        && gcloud components update \
        && gcloud config set component_manager/disable_update_check true

RUN curl -L -o kubectl \
        https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
        && chmod 0700 kubectl \
        && mv kubectl /usr/bin

RUN curl -L -o helm.tar.gz \
        https://kubernetes-helm.storage.googleapis.com/helm-v${HELM_VERSION}-linux-amd64.tar.gz \
        && tar -xvzf helm.tar.gz \
        && rm -rf helm.tar.gz \
        && chmod 0700 linux-amd64/helm \
        && mv linux-amd64/helm /usr/bin

RUN curl -o ./terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
        && unzip terraform.zip \
        && mv terraform /usr/bin \
        && rm -rf terraform.zip

RUN curl -L -o ./terragrunt \
        https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 \
        && chmod 0700 terragrunt \
        && mv terragrunt /usr/bin

RUN curl -L -o ./tph.tar.gz \
        https://github.com/mcuadros/terraform-provider-helm/releases/download/v${TERRAFORM_PROVIDER_HELM_VERSION}/terraform-provider-helm_v${TERRAFORM_PROVIDER_HELM_VERSION}_linux_amd64.tar.gz \
        && tar -xvzf tph.tar.gz \
        && rm -rf tph.tar.gz \
        && cd terraform-provider-helm_linux_amd64 \
        && mv terraform-provider-helm terraform-provider-helm_v${TERRAFORM_PROVIDER_HELM_VERSION} \
        && chmod 0700 terraform-provider-helm_v${TERRAFORM_PROVIDER_HELM_VERSION} \
        && mkdir -p /root/.terraform.d/plugins/ \
        && mv terraform-provider-helm_v${TERRAFORM_PROVIDER_HELM_VERSION} /root/.terraform.d/plugins/

COPY terraform-plugins /terraform-plugins/

RUN cd /terraform-plugins \
    && terraform init \
    && find /terraform-plugins \
    && cp /terraform-plugins/.terraform/plugins/linux_amd64/terraform-provider* /root/.terraform.d/plugins/ \
    && cd \
    && rm -fr /terraform-plugins

COPY modules /exekube-modules/
COPY --from=builder /build/bin/xk /usr/local/bin/
ENV PATH /exekube-modules/gcp-project-init:/exekube-modules/gcp-secret-mgmt/scripts:$PATH

ENTRYPOINT ["/usr/local/bin/xk"]
