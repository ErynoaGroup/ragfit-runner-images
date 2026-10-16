# Project agent rules — RagFit | Runner Images

All eight Erynoa consumers—Claude, Grok, Codex, Copilot, Hermes, OpenClaw, Kimi, and Cursor—must follow the same rules in this repository.

**Canonical project doctrine:** [`erynoa.md`](./erynoa.md) — find or create via skill **`erynoa-md`**.  
**System & layer architecture:** [`docs/ARCHITECTURE.md`](./docs/ARCHITECTURE.md) — RagFit v4.0 Layer 4 Reproducible OCI Image Factory (`RagFit | Runner Images`).

<!-- ERYNOA-DOCTRINE:BEGIN -->
## Erynoa Agent Law & Doctrine (R0–R10 · Law R2 DynHom)

- **Law R2 · DynHom (Dynamic Homogeneity):** Maximal homogen in der Form (gleiche Homes, Verträge, `erynoa.md`, `flake.nix`, `justfile`), maximal dynamisch in der signalgebundenen Tiefe.
- **Agent Law R0–R10:** Die generierte Always-On-Law-Card (`R0`–`R10`) aus `ErynoaGroup/.law` (`$ERYNOA_LAW_ROOT/law/FULL.md`) ist für alle Konsumenten verbindlich:
  - **R0–R3:** Kanonische Projektdoktrin [`erynoa.md`](./erynoa.md) zuerst lesen, Pflichtregistrierung in `https://github.com/ErynoaGroup/.repo-index.git` (`$REPO_INDEX_ROOT`), portable Pfade (`$AGENT_SURFACE_ROOT`).
  - **R4–R7:** Deterministische Nix/just-Oberfläche (`nix develop`, `just doctor`, `just image`, `just ci-quick`), öffentlicher Fail-Closed Boundary-Guard (`scripts/boundary-guard.sh` mit `boundary-guard.conf`), keine internen Hostnamen, IPs, E-Mail-Adressen oder Geheimnisse.
  - **R8–R10:** Trunk-based Entwicklung gegen `main`, Keyless Cosign Signierung ausschließlich in CI auf `main`, Architektur-Wahrheit in [`docs/ARCHITECTURE.md`](./docs/ARCHITECTURE.md).
<!-- ERYNOA-DOCTRINE:END -->

**Org registry (mandatory):**  
`https://github.com/ErynoaGroup/.repo-index.git` · **`$REPO_INDEX_ROOT`** · skill **`repo-index`**.

This project **must** use an **ErynoaGroup** remote and appear in `repos.yaml`. Unregistered → register or STOP.

<!-- AGENT-SURFACE-SSOT:BEGIN -->
## Agent Surface (global skills SSOT)

**Portable skills and plugins are centralized for all providers — not per-app copies.**

| | |
|--|--|
| **SSOT remote** | `https://github.com/ErynoaGroup/.ai-harness.git` |
| **Local root** | `$AGENT_SURFACE_ROOT` / `$AI_HARNESS_ROOT` (host-set; never a fixed user path in docs) |
| **Edit skills/plugins** | Only inside the SSOT (`skills/`, `plugins/`, `hooks/`, `justfile`) |
| **Never** | Treat home skill directories as the source of truth (derived symlinks) |
| **Never** | Absolute Mac/Linux home paths as SSOT in `.md` |
| **Install / health** | `cd "$AGENT_SURFACE_ROOT" && just install && just doctor` |
| **Docs / index** | `just index` → `docs/SKILLS.md` |
| **Handbook** | Skill **`agent-surface`** (`/agent-surface`) |
| **Repo doctrine** | Skill **`erynoa-md`** · file **`erynoa.md`** |
| **Architecture** | [`docs/ARCHITECTURE.md`](./docs/ARCHITECTURE.md) |
| **Large multi-skill work** | **`ultracode`** · **`task-intake`** |

| Provider | Also reads in this repo |
|----------|-------------------------|
| All | **`erynoa.md` (canonical)** · **[`docs/ARCHITECTURE.md`](./docs/ARCHITECTURE.md)** |
| Claude | `CLAUDE.md`, `.claude/CLAUDE.md` |
| Grok | `AGENTS.md`, `CLAUDE.md` |
| OpenAI Codex | `AGENTS.md` |
| GitHub Copilot | `AGENTS.md` + `.github/copilot-instructions.md` |
| Hermes | `erynoa.md`, `AGENTS.md` |
| OpenClaw | `erynoa.md`, workspace `AGENTS.md` |
| Kimi Code | `AGENTS.md` |
| Cursor | `erynoa.md`, `AGENTS.md` |

<!-- AGENT-SURFACE-SSOT:END -->

<!-- ERYNOA-POINTER:BEGIN -->
## Erynoa project doctrine (canonical)

**Full agent handbook for this repository:** [`erynoa.md`](./erynoa.md)  
**Architecture & OCI Image Factory specification:** [`docs/ARCHITECTURE.md`](./docs/ARCHITECTURE.md)

Every coding agent **MUST** find or create `erynoa.md` when interacting with this repo, then follow it.
Load skill **`erynoa-md`** (`/erynoa-md`) to create, deepen, audit, or sync mirrors.
<!-- ERYNOA-POINTER:END -->
