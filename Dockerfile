# docker build . -t arpanrec/vaultmonorepo:2
FROM debian

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

COPY requirements.txt /tmp/requirements.txt

RUN python3 -m pip install -r /tmp/requirements.txt --upgrade

RUN rm -rf /tmp/requirements.txt

RUN wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    tee /etc/apt/sources.list.d/hashicorp.list

RUN apt update && apt-get install terraform -y

RUN apt-get install -y git

# RUN useradd -d /home/vault-mono -m -s /bin/bash vault-mono

# USER vault-mono

# WORKDIR /home/vault-mono
