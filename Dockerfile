# Debian 11.2 20220418, see https://hub.docker.com/_/debian
FROM debian:stable-slim@sha256:6e6da916a82e394647b7a4353d3894fcf15b1e0888b29e12aa411377b5647d9c
COPY Aptfile* /
RUN apt-get clean && apt-get update -qq && \
    : install the packages in the lockfile && \
    apt-get -y install $(cat ./Aptfile.lock | sed 's/#.*//' | grep -v -s -e "^:repo:" | tr '\n' ' ') || true && \
    : install the packages in the request file, should be a noop && \
    apt-get -y install $(cat ./Aptfile | sed 's/#.*//' | grep -v -s -e "^:repo:" | tr '\n' ' ') && \
    : generate an updated lockfile && \
    dpkg -l | grep ii | awk '{print $2 "=" $3}' > /Aptfile.lock && \
    : cleanup && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home app && \
    adduser app sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
WORKDIR /home/app
USER app
