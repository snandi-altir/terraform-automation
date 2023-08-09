FROM 523530352396.dkr.ecr.us-west-2.amazonaws.com/hyperian-jenkins:2.375.2

USER root

ENV TERRAFORM_VERSION=1.3.6

RUN pip install --upgrade pip setuptools

RUN pip install yq

RUN curl https://storage.googleapis.com/kubernetes-release/release/v1.26.0/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl

RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && chmod +x get_helm.sh && ./get_helm.sh

RUN curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip '*.zip' -d /usr/local/bin \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* *.zip

RUN curl --silent --location --remote-name \
    "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/v3.2.3/kustomize_kustomize.v3.2.3_linux_amd64" && \
    chmod a+x kustomize_kustomize.v3.2.3_linux_amd64 && \
    mv kustomize_kustomize.v3.2.3_linux_amd64 /usr/local/bin/kustomize

RUN apt-get update \
    && apt-get install openjdk-17-jdk openjdk-17-jre -y
