# docker build . -t arpanrec/vaultmonorepo:5
FROM debian

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y apt-utils && apt-get upgrade -y && \
    apt-get install -y python3-pip npm jq gnupg software-properties-common wget curl git

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

RUN apt-get update && apt-get install terraform -y

RUN apt-get clean all && rm -rf /var/cache/apt
