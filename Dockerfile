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

ARG JAVA17_DIR='/home/java/jdk-17'

ARG JAVA17_URL='https://download.oracle.com/java/17/latest'

RUN set -eux; \
    ARCH=$(uname -m) && \
    # Java uses just x64 in the name of the tarball
    if [ "$ARCH" = "x86_64" ]; \
    then ARCH="x64"; \
    fi && \
    JAVA_PKG="$JAVA17_URL/jdk-17_linux-${ARCH}_bin.tar.gz" ; \
    JAVA_SHA256=$(curl "$JAVA_PKG".sha256) ; \ 
    curl --output /tmp/jdk.tgz "$JAVA_PKG" && \
    echo "$JAVA_SHA256 */tmp/jdk.tgz" | sha256sum -c; \
    mkdir -p "$JAVA17_DIR"; \
    tar --extract --file /tmp/jdk.tgz --directory "$JAVA17_DIR" --strip-components 1    
