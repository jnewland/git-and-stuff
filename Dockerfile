FROM debian:stable-slim@sha256:f8d3f188cb883482e7dd4edf92f03c130094e36b8e35315e319f27b0e51394dd
COPY Aptfile* /
RUN apt-get update -qq && \
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
