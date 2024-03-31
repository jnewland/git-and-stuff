# Requires https://salsa.debian.org/apt-team/apt/-/merge_requests/291
FROM debian:trixie-slim@sha256:09dd559ab7f61df3bfb5daa5e1ec6066e87c9b0baee5b2e6dc932e194d303155
ENV DEBIAN_FRONTEND=noninteractive
# from https://github.com/reproducible-containers
RUN \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  : "${SOURCE_DATE_EPOCH:=$(stat --format=%Y /etc/apt/sources.list.d/debian.sources)}" && \
  snapshot="$(/bin/bash -euc "printf \"%(%Y%m%dT%H%M%SZ)T\n\" \"${SOURCE_DATE_EPOCH}\"")" && \
  : "Enabling snapshot" && \
  sed -i -e '/URIs: http:\/\/deb.debian.org\/debian/ a\Snapshot: true' /etc/apt/sources.list.d/debian.sources && \
  : "Enabling cache" && \
  rm -f /etc/apt/apt.conf.d/docker-clean && \
  echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' >/etc/apt/apt.conf.d/keep-cache && \
  : "Fetching the snapshot and installing ca-certificates in one command" && \
  apt-get install --update --snapshot "${snapshot}" -o Acquire::Check-Valid-Until=false -o Acquire::https::Verify-Peer=false -y ca-certificates && \
  : "Installing sorted packages" && \
  apt-get install --snapshot "${snapshot}" -y \
    build-essential \
    curl \
    dnsutils \
    git \
    htop \
    iptables \
    iputils-ping \
    jq \
    lsb-release \
    lsof \
    make \
    netcat-openbsd \
    nmap \
    ntpdate \
    openssh-client \
    postgresql-client \
    procps \
    rsync \
    strace \
    sudo \
    tcpdump \
    telnet \
    util-linux \
    vim-nox \
    wget \
    ;

RUN useradd --create-home app && \
    adduser app sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
WORKDIR /home/app
USER app
