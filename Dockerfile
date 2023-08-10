FROM jenkins/jenkins:2.418-jdk17
# if we want to install via apt
USER root

ARG DOCKER_GID=996

# installing docker
# Install the latest Docker CE binaries and add user `jenkins` to the docker group
RUN groupadd -g ${DOCKER_GID} docker 
RUN apt-get update && \
    apt-get install ca-certificates curl gnupg && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    chmod a+r /etc/apt/keyrings/docker.gpg && \
    echo \
      "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
      "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
      tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y && \
    usermod -aG docker jenkins

# Install node
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
RUN export NVM_DIR="$HOME/.nvm"

# install maven
RUN apt-get update && apt-get install -y maven 


# install boto3
RUN apt-get update && \
    apt-get install python3 python3-pip -y && \
    pip3 install boto3
# install aws cli
RUN pip3 install awscli --upgrade
 
#CMD [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
#CMD [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

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

# Cleanup
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*
