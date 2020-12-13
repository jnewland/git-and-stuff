FROM debian:stable-slim@sha256:28d81da3f6685d971688ce7efe3c990d9ffe4039ffeae81f5b47c6cdcc3dd585
COPY Aptfile* /
RUN apt-get update -qq && apt-get -y install $(cat ./Aptfile | grep -v -s -e '^#' | grep -v -s -e "^:repo:" | tr '\n' ' ') && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    dpkg -l | grep ii | awk '{print $2 "=" $3}' > /Aptfile.lock

RUN useradd --create-home app && \
    adduser app sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
WORKDIR /home/app
USER app
