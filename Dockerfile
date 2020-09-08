FROM debian:sid-slim
RUN apt-get update && apt-get install -y \
  curl \
  dnsutils \
  git-core \
  iptables \
  iputils-ping \
  jq \
  lsof \
  netcat \
  nmap \
  ntpdate \
  openssh-client \
  postgresql-client \
  procps \
  strace \
  telnet \
  tcpdump \
  vim-nox && \
  rm -rf /var/lib/apt/lists/*
