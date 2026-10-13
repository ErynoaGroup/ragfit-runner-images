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
public Rekor transparency log) and carry an SPDX SBOM attestation.

```sh
cosign verify \
  --certificate-identity-regexp '^https://github\.com/ErynoaGroup/ragfit-runner-images/\.github/workflows/images\.yml@refs/heads/main$' \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com \
  ghcr.io/erynoagroup/ragfit-runner-node@sha256:<digest>

cosign verify-attestation --type spdxjson \
  --certificate-identity-regexp '^https://github\.com/ErynoaGroup/ragfit-runner-images/\.github/workflows/images\.yml@refs/heads/main$' \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com \
  ghcr.io/erynoagroup/ragfit-runner-node@sha256:<digest>
```

## Build

Pull requests build the images without pushing. Pushes to `main`, `v*` tags and manual
dispatches build, push, sign and attest.

## License

Apache License 2.0, see [LICENSE](LICENSE) and [NOTICE](NOTICE).
