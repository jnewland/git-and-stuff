FROM debian:sid-slim
RUN apt-get update && apt-get install -y \
  curl \
  jq \
  git-core \
  openssh-client \
  vim-nox && \
  rm -rf /var/lib/apt/lists/*
