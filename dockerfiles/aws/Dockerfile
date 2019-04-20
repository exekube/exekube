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

ENV AWS_CLI_VERSION 1.15.41
ENV S3CMD_VERSION 2.0.1
ENV HEPTIO_AUTHENTICATOR_AWS_VERSION 0.3.0
ENV KUBECTL_VERSION 1.10.5
ENV HELM_VERSION 2.9.1
ENV TERRAFORM_VERSION 0.11.7
ENV TERRAGRUNT_VERSION 0.14.10
ENV TERRAFORM_PROVIDER_HELM_VERSION 0.6.0

RUN apk --no-cache add \
        curl \
        python \
        py-crcmod \
        py-pip \
        bash \
        libc6-compat \
        openssh-client \
        git \
        openssl \
        tar \
        ca-certificates \
        apache2-utils \
        tzdata \
        jq

RUN pip install --upgrade \
        awscli==${AWS_CLI_VERSION} \
        s3cmd==${S3CMD_VERSION} \
        python-magic

RUN curl -L -o kubectl \
        https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
        && chmod 0700 kubectl \
        && mv kubectl /usr/bin

RUN curl -L -o heptio-authenticator-aws \
        https://github.com/heptio/aws-iam-authenticator/releases/download/v${HEPTIO_AUTHENTICATOR_AWS_VERSION}/heptio-authenticator-aws_${HEPTIO_AUTHENTICATOR_AWS_VERSION}_linux_amd64 \
        && chmod 0700 heptio-authenticator-aws \
        && mv heptio-authenticator-aws /usr/bin

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

COPY modules /exekube-modules/
COPY --from=builder /build/bin/xk /usr/local/bin/
ENV PATH /exekube-modules/gcp-project-init:/exekube-modules/gcp-secret-mgmt/scripts:$PATH

ENTRYPOINT ["/usr/local/bin/xk"]
