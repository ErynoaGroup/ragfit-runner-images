# syntax=docker/dockerfile:1
FROM docker.io/library/golang:1.25-bookworm@sha256:3b4a11519ad929d1e1d261a12cff056f0c85b735253d7d861346b9c6f8b36437
# Common runner basics: git, curl, CA certificates, Node (for JS actions such as actions/checkout).
RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates curl git jq tar xz-utils zstd unzip openssh-client \
 && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y --no-install-recommends nodejs \
 && rm -rf /var/lib/apt/lists/*
LABEL org.opencontainers.image.version="1.25"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.source="https://github.com/ErynoaGroup/ragfit-runner-images" \
      org.opencontainers.image.description="Runner job image for Gitea Actions: Go 1.25"
