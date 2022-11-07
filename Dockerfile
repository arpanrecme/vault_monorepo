# docker build . -t arpanrecme/vaultmonorepo:9
FROM debian

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends -y python3-pip \
    npm jq gnupg software-properties-common wget curl git openssh-client && \
    apt-get clean all && rm -rf /var/cache/apt

RUN npm install -g @bitwarden/cli

COPY requirements.txt /tmp/requirements.txt

RUN python3 -m pip install -r /tmp/requirements.txt --no-cache-dir --upgrade && \
    rm -rf /tmp/requirements.txt

RUN wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    tee /etc/apt/sources.list.d/hashicorp.list

RUN apt-get update && apt-get install --no-install-recommends terraform -y && \
    apt-get clean all && rm -rf /var/cache/apt
