# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.245.2/containers/debian/.devcontainer/base.Dockerfile

# [Choice] Debian version (use bullseye on local arm64/Apple Silicon): bullseye, buster
ARG VARIANT="bullseye"
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
     && apt-get -y install python3-pip iputils-ping
RUN apt-get -y install npm

RUN npm install -g @bitwarden/cli

# RUN python3 -m pip install -r requirements.txt --upgrade
