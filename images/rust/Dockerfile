# syntax=docker/dockerfile:1
FROM docker.io/library/rust:1-slim-bookworm@sha256:2c3a22f0a5533ea2dd5a16627bc841228151faa2d4de2644ac9987e4a2f1f2fa
# Common runner basics: git, curl, CA certificates, Node (for JS actions such as actions/checkout).
RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates curl git jq tar xz-utils zstd unzip openssh-client \
 && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y --no-install-recommends nodejs pkg-config libssl-dev build-essential \
 && rm -rf /var/lib/apt/lists/* \
 && rustup component add clippy rustfmt
LABEL org.opencontainers.image.version="1-stable"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.source="https://github.com/ErynoaGroup/ragfit-runner-images" \
      org.opencontainers.image.description="Runner job image for Gitea Actions: Rust stable"
