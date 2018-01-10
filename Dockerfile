FROM debian:sid-slim
RUN apt-get update && apt-get install -y \
  curl \
  dnsutils \
  git-core \
  iptables \
  iputils-ping \
  jq \
  ntpdate \
  openssh-client \
  procps \
  strace \
  telnet \
  vim-nox && \
  rm -rf /var/lib/apt/lists/*
