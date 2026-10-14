# erynoa.md — project doctrine

<!-- AGENT-PLANNER:BEGIN -->
## Agent planner

| | |
|--|--|
| **Mission** | Public, keyless-signed container job images for Gitea Actions runners |
| **Success** | `just doctor` green · `images` workflow green on `main` |
| **DX** | `nix develop` · `just` · `just doctor` |
| **Work-root** | `docs/work/` |
| **Branching** | trunk-based · pull requests → `main` |

**Read order:** (1) this planner (2) `justfile` (3) README (4) `docs/`

**Do first:** branch → `just doctor` → change → `just doctor` → pull request
<!-- AGENT-PLANNER:END -->

## Identity

| Field | Value |
|-------|--------|
| **Project** | ragfit-runner-images |
| **Purpose** | Runner job images (node, rust, go, nix), published to GHCR with cosign keyless signatures and SPDX SBOM attestations |
| **Status** | active |
| **Stack** | Dockerfiles, GitHub Actions (GitHub-hosted runners), cosign, syft |
| **Visibility** | public |
| **License** | Apache-2.0 |
| **last_reviewed** | 2026-10-14 |

## Secrets & settings (set by Niklas only)

| Name | Kind | Purpose |
|------|------|---------|
| `BOUNDARY_GUARD_EXTRA` | Actions secret | Newline-separated ERE patterns for internal names that must not appear in git. `boundary-guard.conf` declares `require-extra`, so the guard fails closed (exit 2) until it is set. |

Agents never create or change secrets, variables or repository settings, and never set `BOUNDARY_GUARD_ALLOW_NO_EXTRA`.

## Invariants

1. **I-1** — Only `main` publishes and signs; verification uses the exact workflow identity.
2. **I-2** — No secrets in git; signing is keyless.
3. **I-3** — Base images are pinned by digest; there is no `latest` tag.
4. **I-4** — The repository holds only what `boundary-guard.conf` allows.

## Forbidden

1. **F-1** — Secrets, tokens, private keys.
2. **F-2** — Internal host names, IP addresses, e-mail addresses, mentions, private repository names, local paths.
3. **F-3** — Publishing images from anywhere but CI on `main`.

## Tooling & commands

```bash
nix develop      # just, git, shellcheck
just doctor      # stamp + boundary guard + guard tests
```

## Specs & plans

`docs/work/` · decisions in `docs/decisions/`.
