# syntax=docker/dockerfile:1
FROM docker.io/library/node:22-bookworm-slim@sha256:c3de60bf2f9dd0ac6370e6117950ff62d6e339527e7472301c9c78a017978392
# Common runner basics: git, curl, CA certificates, Node (for JS actions such as actions/checkout).
RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates curl git jq tar xz-utils zstd unzip openssh-client \
 && rm -rf /var/lib/apt/lists/*
RUN corepack enable
LABEL org.opencontainers.image.version="22"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.source="https://github.com/ErynoaGroup/ragfit-runner-images" \
      org.opencontainers.image.description="Runner job image for Gitea Actions: Node 22"
