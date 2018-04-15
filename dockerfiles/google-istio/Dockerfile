FROM exekube/exekube:0.3.0-google

ENV ISTIO_VERSION 0.7.1

RUN curl -L -o istioctl.tar.gz \
        https://github.com/istio/istio/releases/download/${ISTIO_VERSION}/istio-${ISTIO_VERSION}-linux.tar.gz \
        && tar -xvzf istioctl.tar.gz \
        && rm -rf istioctl.tar.gz \
        && chmod 0700 istio-${ISTIO_VERSION}/bin/istioctl \
        && mv istio-${ISTIO_VERSION}/bin/istioctl /usr/bin \
        && rm -rf istio-${ISTIO_VERSION}
