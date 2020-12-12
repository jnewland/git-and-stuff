ARG TARGETPLATFORM=linux/amd64
FROM --platform=$TARGETPLATFORM debian:stable-slim
ARG TARGETPLATFORM=linux
ARG TARGETARCH=amd64
ARG TARGETVARIANT=
COPY Aptfile* /
ARG UPDATE_APTFILE=true
RUN TARGET="${TARGETARCH}${TARGETVARIANT}" && \
    test -n "$TARGET" && \
    cat /Aptfile > /Aptfile.merged && echo "" >> /Aptfile.merged && \
    touch /Aptfile.$TARGET && cat /Aptfile.$TARGET >> /Aptfile.merged && echo "" >> /Aptfile.merged && \
    apt-get update -qq && apt-get -y install $(cat /Aptfile.merged | grep -v -s -e '^#' | grep -v -s -e "^:repo:" | tr '\n' ' ') && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    dpkg -l | grep ii | awk '{print $2 "=" $3}' > /Aptfile.$TARGET.actual && \
    diff -u /Aptfile.$TARGET.lock /Aptfile.$TARGET.actual && diff=$? || diff=$? && \
    if [ "${UPDATE_APTFILE}" = "true" ]; then \
        exit $diff; \
    else \
        cp /Aptfile.$TARGET.actual /Aptfile.$TARGET.lock; \
    fi

RUN useradd --create-home app && \
    adduser app sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
WORKDIR /home/app
USER app
