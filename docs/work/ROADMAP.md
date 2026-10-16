# Work ROADMAP — RagFit | Runner Images

**Standard:** Erynoa Docs **v1** · Status: `draft` · `active` · `done` · `dropped` (frozen).  
Trunk-based integration → merge to **`main`**. IDs never reused.  
Architektur-Referenz: [`../ARCHITECTURE.md`](../ARCHITECTURE.md) · Vertrag: [`./RN-C1-images-contract.md`](./RN-C1-images-contract.md).

## Meilensteine (`RA*` & `RN*`)

| ID | Title | Status | Path / Evidence | Notes |
|----|-------|--------|-----------------|-------|
| **RN3** | Öffentliche OCI-Job-Images (`node`, `rust`, `go`, `nix`) mit Keyless Cosign & SPDX-SBOM | `done` | [`images/`](../../images/), [`.github/workflows/images.yml`](../../.github/workflows/images.yml) | Main-only Publish & OIDC Signatur, Basis-Images per `@sha256:` gepinnt |
| **RA0** | Erynoa Repo-Stamp, Allowlist Boundary-Guard, Nix OCI Container Build (`base` & `agent-worker`) & v4.0 Architektur | `done` | [`flake.nix`](../../flake.nix), [`justfile`](../../justfile), [`boundary-guard.conf`](../../boundary-guard.conf), [`docs/ARCHITECTURE.md`](../ARCHITECTURE.md) | `packages.<system>.{base,agent-worker,container,image,default}` via `dockerTools.buildLayeredImage` |
| **RN-C1** | Image-Vertrag & automatisierte Digest-Verifikation für `RagFit \| Runner` (`lib.images`) | `active` | [`docs/work/RN-C1-images-contract.md`](./RN-C1-images-contract.md), [`tests/rn-c1/verify-digests.test.sh`](../../tests/rn-c1/verify-digests.test.sh) | Exakte OIDC-Zertifikatsidentität auf `refs/heads/main` |
| **RN-M1** | Multi-Arch OCI-Veröffentlichung (`linux/amd64` + `linux/arm64`) | `draft` | [`docs/ARCHITECTURE.md`](../ARCHITECTURE.md) §2 | Nix-Flake unterstützt bereits `x86_64-linux` und `aarch64-linux` |
