# syntax=docker/dockerfile:1
FROM docker.io/nixos/nix:2.28.4@sha256:85169a7ff4ac6928b70b15ced20c74770e07e8fbc7f97e92f64c1fca47ea9486
RUN mkdir -p /etc/nix \
 && printf 'experimental-features = nix-command flakes\nsandbox = false\n' >> /etc/nix/nix.conf \
 && nix-env -iA nixpkgs.nodejs_22 nixpkgs.jq nixpkgs.gnutar nixpkgs.zstd \
 && nix-collect-garbage -d
LABEL org.opencontainers.image.version="2.28.4"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.source="https://github.com/ErynoaGroup/ragfit-runner-images" \
      org.opencontainers.image.description="Runner job image for Gitea Actions: Nix (flakes)"
