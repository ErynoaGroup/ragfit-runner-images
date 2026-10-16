<!-- AGENT-SURFACE-SSOT:BEGIN -->
# GitHub Copilot — repository instructions (RagFit | Runner Images)

You are working in a public repository that uses the **Erynoa Agent Surface SSOT** for portable skills and plugins shared across eight consumers: Claude, Grok, Codex, Copilot, Hermes, OpenClaw, Kimi, and Cursor.

## Mandatory — project doctrine & architecture

- **Read and follow** root **[`erynoa.md`](../erynoa.md)** (canonical agent handbook for this repo).
- **Read** **[`docs/ARCHITECTURE.md`](../docs/ARCHITECTURE.md)** for the RagFit v4.0 Layer 4 Reproducible OCI Image Factory specification.
- Do **not** invent a second full doctrine only in this file — keep this file thin; depth lives in `erynoa.md`.

## Mandatory — Erynoa First + portable paths

- Erynoa remotes live under **`github.com/ErynoaGroup/*`** only.
- **Never** hardcode local user paths, internal hostnames, IP addresses, or e-mail addresses into doctrine as SSOT.
- Global skills/plugins live only in the Agent Surface clone pointed to by **`$AGENT_SURFACE_ROOT`** / **`$AI_HARNESS_ROOT`**:
  - remote: `https://github.com/ErynoaGroup/.ai-harness.git`
- Edit skills/plugins **only** in that SSOT; then operators run `just install` + `just doctor`.

## Also read

- Root **[`erynoa.md`](../erynoa.md)** (full doctrine)
- **[`docs/ARCHITECTURE.md`](../docs/ARCHITECTURE.md)** (system architecture)
- Root [`AGENTS.md`](../AGENTS.md) / [`CLAUDE.md`](../CLAUDE.md)
<!-- AGENT-SURFACE-SSOT:END -->

<!-- ERYNOA-DOCTRINE:BEGIN -->
## Erynoa Agent Law & Doctrine (R0–R10 · Law R2 DynHom)

- **Law R2 · DynHom (Dynamic Homogeneity):** Maximal homogen in der Form, maximal dynamisch in der signalgebundenen Tiefe.
- **Agent Law R0–R10:** Alle Regeln `R0`–`R10` aus `ErynoaGroup/.law` (`$ERYNOA_LAW_ROOT/law/FULL.md`) gelten verbindlich (`nix develop`, `just doctor`, `just image`, `just ci-quick`, Fail-Closed Boundary-Guard).
<!-- ERYNOA-DOCTRINE:END -->

<!-- ERYNOA-POINTER:BEGIN -->
## Erynoa project doctrine (canonical)

**Full agent handbook for this repository:** [`../erynoa.md`](../erynoa.md)  
**Architecture & OCI Image Factory specification:** [`../docs/ARCHITECTURE.md`](../docs/ARCHITECTURE.md)

Every coding agent **MUST** find or create `erynoa.md` when interacting with this repo, then follow it.
Load skill **`erynoa-md`** (`/erynoa-md`) to create, deepen, audit, or sync mirrors.
<!-- ERYNOA-POINTER:END -->
