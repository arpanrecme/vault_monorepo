# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.245.2/containers/debian/.devcontainer/base.Dockerfile

# [Choice] Debian version (use bullseye on local arm64/Apple Silicon): bullseye, buster
ARG VARIANT="bullseye"
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update

RUN apt-get install -y apt-utils

RUN apt-get upgrade -y

RUN apt-get install -y python3-pip

RUN apt-get install -y npm

RUN apt-get install -y jq

RUN apt-get install -y gnupg

RUN apt-get install -y software-properties-common

RUN apt-get install -y wget

RUN apt-get install -y curl

RUN npm install -g @bitwarden/cli

RUN wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    tee /etc/apt/sources.list.d/hashicorp.list

RUN apt-get update && apt-get install terraform -y

RUN apt-get install -y git

RUN apt-get clean all && rm -rf /var/cache/apt
