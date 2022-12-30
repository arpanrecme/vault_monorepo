# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.245.2/containers/debian/.devcontainer/base.Dockerfile

# [Choice] Debian version (use bullseye on local arm64/Apple Silicon): bullseye, buster
ARG VARIANT="bullseye"
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

ENV DEBIAN_FRONTEND=noninteractive

# trunk-ignore(hadolint/DL3009)
RUN apt-get update
# trunk-ignore(hadolint/DL3008)
# trunk-ignore(hadolint/DL3015)
# trunk-ignore(hadolint/DL3059)
RUN apt-get install -y apt-utils
# trunk-ignore(hadolint/DL3059)
RUN apt-get upgrade -y
# trunk-ignore(hadolint/DL3059)
# trunk-ignore(hadolint/DL3015)
# trunk-ignore(hadolint/DL3008)
RUN apt-get install -y python3-pip \
    npm jq gnupg software-properties-common wget curl git openssh-client

RUN apt-get autopurge -y && \
    apt-get clean all && rm -rf /var/cache/apt

# trunk-ignore(hadolint/DL3016)
RUN npm install -g @bitwarden/cli

COPY requirements.txt /tmp/requirements.txt

RUN python3 -m pip install -r /tmp/requirements.txt --no-cache-dir --upgrade && \
    rm -rf /tmp/requirements.txt

# trunk-ignore(hadolint/DL4006)
# trunk-ignore(hadolint/DL3047)
RUN wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

# trunk-ignore(hadolint/DL4006)
RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    tee /etc/apt/sources.list.d/hashicorp.list

# trunk-ignore(hadolint/DL3015)
# trunk-ignore(hadolint/DL3008)
RUN apt-get update && apt-get install terraform -y && \
    apt-get clean all && rm -rf /var/cache/apt
