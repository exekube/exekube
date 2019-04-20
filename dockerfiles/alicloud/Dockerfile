# First stage -- compiling Exekube CLI
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

# Second stage -- getting all runtime deps
FROM alpine:3.7

ENV ALIYUN_VERSION 3.0.0
ENV HELM_VERSION 2.8.2
ENV KUBECTL_VERSION 1.9.3
ENV TERRAFORM_VERSION 0.11.5
ENV TERRAGRUNT_VERSION 0.14.6
ENV TERRAFORM_PROVIDER_HELM_VERSION 0.6.0
ENV TERRAFORM_PROVIDER_ALICLOUD_VERSION 1.9.1

RUN apk --no-cache add \
        curl \
        bash \
        libc6-compat \
        openssh-client \
        git \
        openssl \
        tar \
        ca-certificates \
        apache2-utils \
        jq \
        tzdata

RUN curl -L -o kubectl \
        https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
        && chmod 0700 kubectl \
        && mv kubectl /usr/bin

# Alibaba Cloud CLI
RUN curl -L -o aliyun.tgz \
        http://aliyun-cli.oss-cn-hangzhou.aliyuncs.com/aliyun-cli-linux-${ALIYUN_VERSION}-amd64.tgz \
        && tar xzf aliyun.tgz \
        && rm -f aliyun.tgz \
        && chmod 0700 aliyun \
        && mv aliyun /usr/bin

# Alibaba Cloud terraform provider
RUN curl -L -o tpa.tgz \
        https://github.com/alibaba/terraform-provider/releases/download/V${TERRAFORM_PROVIDER_ALICLOUD_VERSION}/terraform-provider-alicloud_linux-amd64.tgz \
        && tar -xvzf tpa.tgz \
        && rm -f tpa.tgz \
        && chmod 0700 bin/terraform-provider-alicloud \
        && mv bin/terraform-provider-alicloud bin/terraform-provider-alicloud_v${TERRAFORM_PROVIDER_ALICLOUD_VERSION} \
        && mkdir -p /root/.terraform.d/plugins \
        && mv bin/terraform-provider-alicloud_v${TERRAFORM_PROVIDER_ALICLOUD_VERSION} /root/.terraform.d/plugins

RUN curl -L -o helm.tar.gz \
        https://kubernetes-helm.storage.googleapis.com/helm-v${HELM_VERSION}-linux-amd64.tar.gz \
        && tar -xvzf helm.tar.gz \
        && rm -f helm.tar.gz \
        && chmod 0700 linux-amd64/helm \
        && mv linux-amd64/helm /usr/bin

RUN curl -o ./terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
        && unzip terraform.zip \
        && mv terraform /usr/bin \
        && rm -f terraform.zip

RUN curl -L -o ./terragrunt \
        https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 \
        && chmod 0700 terragrunt \
        && mv terragrunt /usr/bin

RUN curl -L -o ./tph.tar.gz \
        https://github.com/mcuadros/terraform-provider-helm/releases/download/v${TERRAFORM_PROVIDER_HELM_VERSION}/terraform-provider-helm_v${TERRAFORM_PROVIDER_HELM_VERSION}_linux_amd64.tar.gz \
        && tar -xvzf tph.tar.gz \
        && rm -f tph.tar.gz \
        && cd terraform-provider-helm_linux_amd64 \
        && mv terraform-provider-helm terraform-provider-helm_v${TERRAFORM_PROVIDER_HELM_VERSION} \
        && chmod 0700 terraform-provider-helm_v${TERRAFORM_PROVIDER_HELM_VERSION} \
        && mkdir -p /root/.terraform.d/plugins/ \
        && mv terraform-provider-helm_v${TERRAFORM_PROVIDER_HELM_VERSION} /root/.terraform.d/plugins/

COPY modules /exekube-modules/
COPY --from=builder /build/bin/xk /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/xk"]
