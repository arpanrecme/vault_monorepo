# docker build . -t arpanrec/vaultmonorepo:6
FROM debian:11

ENV DEBIAN_FRONTEND=noninteractive

# trunk-ignore(hadolint/DL3008)
RUN apt-get update && \
    apt-get install --no-install-recommends -y python3-pip \
    npm jq gnupg software-properties-common wget curl git && \
    apt-get clean all && rm -rf /var/cache/apt

RUN npm install -g @bitwarden/cli@2022.10.0

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

RUN apt-get update && apt-get install --no-install-recommends terraform=1.3.3 -y && \
    apt-get clean all && rm -rf /var/cache/apt
