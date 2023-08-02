FROM jenkins/inbound-agent:latest-jdk11

ENV TERRAFORM_VERSION=1.3.6

USER root

RUN set -ex && apt update && \
               apt install -y build-essential \
                       apt-transport-https \
                       ca-certificates \
                       curl \
                       gnupg2 \
                       software-properties-common \
                       tar \
                       zip \
                       unzip \
                       git \
                       maven \
                       dnsutils \
                       awscli \
                       python3-pip


RUN pip install --upgrade pip setuptools

RUN pip install yq

RUN curl -fsSL https://get.docker.com -o get-docker.sh \
    && sh get-docker.sh

RUN curl https://storage.googleapis.com/kubernetes-release/release/v1.26.0/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl

RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && chmod +x get_helm.sh && ./get_helm.sh

RUN curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip '*.zip' -d /usr/local/bin \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* *.zip

RUN curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash    

USER root
ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
