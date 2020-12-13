FROM debian:stable-slim@sha256:2b2450dd709e858ef5e518f9c78c1f3f0638db73fe41c387217465b1f2f2bd83
COPY Aptfile* /
RUN apt-get update -qq && apt-get -y install $(cat ./Aptfile | grep -v -s -e '^#' | grep -v -s -e "^:repo:" | tr '\n' ' ') && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    dpkg -l | grep ii | awk '{print $2 "=" $3}' > /Aptfile.lock

RUN useradd --create-home app && \
    adduser app sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
WORKDIR /home/app
USER app
