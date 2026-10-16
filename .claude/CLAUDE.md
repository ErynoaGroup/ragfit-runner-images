# Project rules (Claude-compatible) — RagFit | Runner Images

Claude-compatible adapter for the same eight-consumer contract as [`../AGENTS.md`](../AGENTS.md).

**Canonical project doctrine:** [`../erynoa.md`](../erynoa.md) — skill **`erynoa-md`**.  
**System & layer architecture:** [`../docs/ARCHITECTURE.md`](../docs/ARCHITECTURE.md) — RagFit v4.0 Layer 4 Reproducible OCI Image Factory.

<!-- ERYNOA-DOCTRINE:BEGIN -->
## Erynoa Agent Law & Doctrine (R0–R10 · Law R2 DynHom)

- **Law R2 · DynHom (Dynamic Homogeneity):** Maximal homogen in der Form (gleiche Homes, Verträge, `erynoa.md`, `flake.nix`, `justfile`), maximal dynamisch in der signalgebundenen Tiefe.
- **Agent Law R0–R10:** Verbindliche Einhaltung von `R0`–`R10` (`$ERYNOA_LAW_ROOT/law/FULL.md`):
  - **R0–R3:** Kanonische Projektdoktrin [`../erynoa.md`](../erynoa.md) zuerst lesen, Pflichtregistrierung in `.repo-index`, portable Pfade.
  - **R4–R7:** Deterministische Nix/just-Oberfläche (`nix develop`, `just doctor`, `just image`, `just ci-quick`), öffentlicher Fail-Closed Boundary-Guard (`scripts/boundary-guard.sh`).
  - **R8–R10:** Trunk-based Entwicklung gegen `main`, Architektur-Spezifikation in [`../docs/ARCHITECTURE.md`](../docs/ARCHITECTURE.md).
<!-- ERYNOA-DOCTRINE:END -->

<!-- AGENT-SURFACE-SSOT:BEGIN -->
## Agent Surface (global skills SSOT)

**Portable skills and plugins are centralized for all providers — not per-app copies.**

| | |
|--|--|
| **SSOT remote** | `https://github.com/ErynoaGroup/.ai-harness.git` |
| **Local root** | `$AGENT_SURFACE_ROOT` / `$AI_HARNESS_ROOT` |
| **Edit skills/plugins** | Only inside the SSOT (`skills/`, `plugins/`, `hooks/`, `justfile`) |
| **Never** | Treat home skill directories as the source of truth (derived symlinks) |
| **Never** | Absolute Mac/Linux home paths as SSOT in `.md` |
| **Install / health** | `cd "$AGENT_SURFACE_ROOT" && just install && just doctor` |
| **Docs / index** | `just index` → `docs/SKILLS.md` |
| **Handbook** | Skill **`agent-surface`** (`/agent-surface`) |
| **Repo doctrine** | Skill **`erynoa-md`** · file **`erynoa.md`** |
| **Architecture** | [`../docs/ARCHITECTURE.md`](../docs/ARCHITECTURE.md) |
| **Large multi-skill work** | **`ultracode`** · **`task-intake`** |
<!-- AGENT-SURFACE-SSOT:END -->

<!-- ERYNOA-POINTER:BEGIN -->
## Erynoa project doctrine (canonical)

**Full agent handbook for this repository:** [`../erynoa.md`](../erynoa.md)  
**Architecture & OCI Image Factory specification:** [`../docs/ARCHITECTURE.md`](../docs/ARCHITECTURE.md)

Every coding agent **MUST** find or create `erynoa.md` when interacting with this repo, then follow it.
Load skill **`erynoa-md`** (`/erynoa-md`) to create, deepen, audit, or sync mirrors.
<!-- ERYNOA-POINTER:END -->
