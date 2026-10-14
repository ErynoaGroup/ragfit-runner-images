# RN-C1 – image contract (preparation)

Status: **prepared.** The service module in the runner service repository (RN-C1) will consume the images
from this repository through `lib.images`. This document only fixes what this repository has to provide.

## Scope

- Every published image is referenced by digest, never by a moving tag.
- Every image carries a keyless cosign signature and an SBOM attestation from `images.yml` on `main`.
- Verification uses the exact certificate identity
  `https://github.com/ErynoaGroup/ragfit-runner-images/.github/workflows/images.yml@refs/heads/main`
  and the issuer `https://token.actions.githubusercontent.com`.
- Out of scope: host configuration, runner registration, secrets.

## Prerequisites

- GHCR packages are public, so consumers can verify without credentials (pending, maintainer decision).
- The service module and its host side are not ready yet; the host side is blocked.

## Acceptance criteria

1. A digest list for node, rust, go and nix can be produced from `main` without credentials.
2. `cosign verify` with the exact identity succeeds for each digest.
3. An image without a valid signature is rejected by the consumer (fail-closed).

## Test scaffolding

`tests/rn-c1/verify-digests.test.sh` is a disabled stub. It exits with code 0 and prints `skip` unless
`RN_C1_VERIFY=1` is set, and it is not wired into any workflow.
