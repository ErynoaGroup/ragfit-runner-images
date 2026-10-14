# ragfit-runner-images

Container job images for self-hosted runners, intended as runner images for Gitea Actions
(and compatible with GitHub Actions-style workflows).

| Image | Contents |
|---|---|
| `ghcr.io/erynoagroup/ragfit-runner-node` | Node 22, corepack, git, curl, jq |
| `ghcr.io/erynoagroup/ragfit-runner-rust` | Rust stable, clippy, rustfmt, build tools, Node |
| `ghcr.io/erynoagroup/ragfit-runner-go` | Go 1.25, Node |
| `ghcr.io/erynoagroup/ragfit-runner-nix` | Nix with flakes enabled, Node 22 |

All images are `linux/amd64`. Base images are pinned by digest.

## Tags

Each image is published with its version tag (e.g. `22`, `1.25`) and `sha-<commit>`.
There is no `latest` tag; pin images by digest.

## Verification

Images are signed keyless with [cosign](https://github.com/sigstore/cosign) (GitHub OIDC,
public Rekor transparency log) and carry an SPDX SBOM attestation. Only the `images.yml`
workflow on `main` publishes and signs; verify against exactly that identity:

```sh
ID=https://github.com/ErynoaGroup/ragfit-runner-images/.github/workflows/images.yml@refs/heads/main
ISSUER=https://token.actions.githubusercontent.com

cosign verify --certificate-identity "$ID" --certificate-oidc-issuer "$ISSUER" \
  ghcr.io/erynoagroup/ragfit-runner-node@sha256:<digest>

cosign verify-attestation --type spdxjson \
  --certificate-identity "$ID" --certificate-oidc-issuer "$ISSUER" \
  ghcr.io/erynoagroup/ragfit-runner-node@sha256:<digest>
```

## Build

Pushes to `main` and manual dispatches on `main` build, push, sign and attest.
Pull requests, tags and manual dispatches from any other branch build only, without
pushing or signing. Only digests built from `main` are meant to be consumed.

## flake.lock

`flake.lock` is generated in CI only. The manual workflow `flake-lock` runs
`nix flake lock` on a GitHub-hosted runner and pushes exactly one commit to a new
branch `ci/flake-lock-<run id>`. The workflow does not open pull requests
(Actions are not allowed to create them); a maintainer opens the one-commit PR
from that branch manually.

## License

Apache License 2.0, see [LICENSE](LICENSE) and [NOTICE](NOTICE).
