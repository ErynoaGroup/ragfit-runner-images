# erynoa.md — project agent doctrine (RagFit | Runner Images)

<!-- AGENT-PLANNER:BEGIN -->
## Agent planner (self-orchestration)

> **Read this first.** Humans: [README.md](./README.md) · Architecture: [docs/ARCHITECTURE.md](./docs/ARCHITECTURE.md).  
> **Law R2 · DynHom:** maximal **homogen** (gleiche Homes/Verträge) · maximal **dynamisch** (signal-gebundene Tiefe). `rule-01-dynamic-homogeneous.md`

| | |
|--|--|
| **Mission** | Öffentliche, reproduzierbare OCI-Image-Fabrik (`RagFit \| Runner Images`, Schicht L5 Orchestration, Multi-Agents & Execution): Keyless Cosign-signierte Container-Job-Images (`node`, `rust`, `go`, `nix`) mit SPDX-SBOM-Attestation sowie leichtgewichtige Nix-OCI-Images (`base`, `agent-worker`, `container`) für `RagFit \| Runner` |
| **Session goal** | orient + `just doctor` + `just ci-quick` |
| **Success** | `just doctor` grün · `just ci-quick` grün · `just boundary-worktree` grün · `nix flake show` valide · `images` Workflow grün auf `main` |
| **DX** | `nix develop` · `just` · `just doctor` · `just image` · `just ci-quick` |
| **Work-root** | `docs/work/` |
| **Branching** | trunk-based · pull requests (PR) → `main` |
| **Erynoa First** | Remote **must** be `ErynoaGroup/*` — not personal org |
| **Paths** | `$AGENT_SURFACE_ROOT` / `$REPO_INDEX_ROOT` / git — keine lokalen Benutzerpfade in Doktrin |
| **Repo-index** | MUST register in `https://github.com/ErynoaGroup/.repo-index.git` · skill `repo-index` |

**Read order:** (1) this planner (2) `justfile` (3) [README.md](./README.md) (4) [docs/ARCHITECTURE.md](./docs/ARCHITECTURE.md) (5) sections below as needed (6) `docs/README.md`

**Do first:** branch → `nix develop` → `just doctor` → change → `just ci-quick` → pull request (PR)

**Orchestration**

| Task | Route |
|------|--------|
| Orient | M0 · planner + `just doctor` |
| Doctrine missing/thin | `erynoa-md` M1–M2 |
| Docs / SPEC·PLAN | `erynoa-docs` |
| Quality | `erynoa-md` M3 |
| Feature / image update | **`erynoa-project` primary · `pipeline=vp-<id>`** (R9) → `docs/work/` + branch + implement + `just ci-quick` |
| Ship gate | M5 |

**DynHom:** gleiche Form überall; Tiefe/Packs/Fan-out nur signal-gebunden (Law R2).

**Do not:** skip planner · add private hostnames, IPs, e-mails, mentions or credentials · publish images outside CI on `main` · use `:latest` tags
<!-- AGENT-PLANNER:END -->

---

## Identity

| Field | Value |
|-------|--------|
| **Project** | RagFit \| Runner Images (`ErynoaGroup/ragfit-runner-images`, öffentlich) |
| **Plattform-Scope (W8)** | **Plattform-Dienstfamilie `RagFit \| *`** · Schicht `L5` Orchestration, Multi-Agents & Execution in der 7-Schichten-Gesamtarchitektur (`L0`–`L6`) |
| **Layer** | Schicht `L5` Orchestration, Multi-Agents & Execution (Reproducible OCI Job & Agent Image Factory) |
| **Purpose** | Öffentliche OCI-Container-Images (`node`, `rust`, `go`, `nix` via Dockerfile-CI sowie `base` und `agent-worker` via Nix `dockerTools.buildLayeredImage`), veröffentlicht auf GHCR mit Keyless Cosign-Signaturen und SPDX-SBOM-Attestationen |
| **Status / tier** | active · tier-2 · RA0 (Stamp + Allowlist Boundary-Guard + Nix OCI Container Build) |
| **Stack** | Nix Flake (`dockerTools.buildLayeredImage`), Dockerfiles, GitHub Actions CI (`images.yml`, `guard.yml`, `flake-lock.yml`), cosign, syft, hadolint, shellcheck |
| **Visibility** | public |
| **License** | Apache-2.0 (see [LICENSE](./LICENSE) and [NOTICE](./NOTICE)) |
| **last_reviewed** | 2026-10-15 |

## Secrets & settings (set by maintainer only)

| Name | Kind | Purpose |
|------|------|---------|
| `BOUNDARY_GUARD_EXTRA` | Actions setting | Newline-separated ERE patterns for internal names that must not appear in git. `boundary-guard.conf` declares `require-extra`, so the guard fails closed (exit 2) until provided. |

Agents never create or change repository settings, and never commit sensitive values.

## Invariants

1. **I-1** — **Main-Only Keyless Publishing:** Nur der Workflow `.github/workflows/images.yml` auf `refs/heads/main` veröffentlicht und signiert GHCR-Images keyless via GitHub OIDC und Rekor; Konsumenten verifizieren exakt diese Workflow-Identität.
2. **I-2** — **Null-Secret- & Public-Hygiene-Garantie:** Keine Schlüssel in Git (Signierung ist 100 % keyless); als öffentliches Repo erzwingt `boundary-guard.conf` eine strikte Pfad-Allowlist sowie das Verbot von internen Hostnamen, IPs, E-Mail-Adressen, Mentions und lokalen Benutzerpfaden.
3. **I-3** — **Digest-Pinning ohne `:latest`:** Alle Basis-Images in `images/*/Dockerfile` sind per `@sha256:`-Digest gepinnt; veröffentlichte Images tragen niemals ein `:latest`-Tag.
4. **I-4** — **Konsistente Nix-OCI-Oberfläche:** `flake.nix` exportiert reproduzierbare Rootless-OCI-Layer-Images (`base`, `agent-worker`, sowie die Standard-Aliase `container`, `image`, `default`) auf Basis von `pkgs.dockerTools.buildLayeredImage` (UID `1000:1000`).

## Forbidden

1. **F-1** — Committen von Zugangsdaten, Tokens, privaten Schlüsseln oder `cosign.key`-Dateien.
2. **F-2** — Aufnehmen von internen Hostnamen, IP-Adressen (RFC1918, CGNAT, ULA), Tailnet-Domains, E-Mail-Adressen, Account-Mentions, privaten Repository-Namen oder lokalen Benutzerpfaden.
3. **F-3** — Veröffentlichen oder Signieren von Container-Images außerhalb des `images.yml`-CI-Workflows auf `main` oder Einführen eines beweglichen `:latest`-Tags.
4. **F-4** — Anlegen von Dateien außerhalb der in `boundary-guard.conf` deklarierten `allow-path`-Regeln ohne gleichzeitige Prüfung des Boundary-Guards.

## How agents work

1. **Agent planner first** → lesen, orientieren, `nix develop` und `just doctor` (`just ci-quick`) ausführen.
2. **Public Boundary-Guard strikt einhalten:** Dieses Repository ist öffentlich (`Apache-2.0`). Vor jedem Commit muss `just boundary-worktree` und `just test` mit 0 Fehlern durchlaufen.
3. **Branch & PR Workflow:** Trunk-based Entwicklung über kurze Topic-Branches und Pull Requests (`PR`) nach `main`; `flake.lock` wird über den CI-Workflow `flake-lock.yml` aktualisiert.
4. **Docs-as-Code:** Änderungen an Image-Profilen, Nix-OCI-Outputs oder Verifikationsregeln synchron in [`README.md`](./README.md), [`docs/ARCHITECTURE.md`](./docs/ARCHITECTURE.md) und [`docs/work/ROADMAP.md`](./docs/work/ROADMAP.md) pflegen.

## Architecture map

```text
┌───────────────────────────────────────────────────────────────────────────────────┐
│            RagFit | Runner Images (ErynoaGroup/ragfit-runner-images)              │
│                Schicht L5 · Reproducible OCI Job & Agent Image Factory             │
│                                                                                   │
│  ┌────────────────────────────────────┐   ┌────────────────────────────────────┐  │
│  │   Nix OCI Layer Build (flake.nix)  │   │   CI Matrix Build (images/*/...)   │  │
│  │   pkgs.dockerTools.buildLayeredImage│   │   GitHub Actions (.github/workflows│  │
│  │                                    │   │   /images.yml on refs/heads/main)  │  │
│  │   • packages.<sys>.base            │   │   • images/node/Dockerfile         │  │
│  │     (container / image / default)  │   │   • images/rust/Dockerfile         │  │
│  │   • packages.<sys>.agent-worker    │   │   • images/go/Dockerfile           │  │
│  │     (gitMinimal, cacert, curl,     │   │   • images/nix/Dockerfile          │  │
│  │      jq, ripgrep · UID 1000:1000)  │   │     (Base images pinned by sha256) │  │
│  └─────────────────┬──────────────────┘   └─────────────────┬──────────────────┘  │
│                    └───────────────────┬────────────────────┘                     │
│                                        ▼                                          │
│  ┌─────────────────────────────────────────────────────────────────────────────┐  │
│  │        Keyless Cosign Signing (GitHub OIDC + Fulcio + Rekor) & Syft         │  │
│  │        + SPDX SBOM Attestation (cosign attest --type spdxjson)              │  │
│  └─────────────────────────────────────┬───────────────────────────────────────┘  │
│                                        │                                          │
│                                        ▼  image@sha256:<digest> (kein :latest)    │
│  ┌─────────────────────────────────────────────────────────────────────────────┐  │
│  │   Downstream Consumers (Fail-Closed Digest & Certificate Verification)      │  │
│  │   • RagFit | Runner (60 % CI act_runner + 40 % NATS Agent-Worker Sandbox)   │  │
│  │   • RunnerOS Host Substrate (Rootless Podman / Kata Containers)             │  │
│  └─────────────────────────────────────────────────────────────────────────────┘  │
└───────────────────────────────────────────────────────────────────────────────────┘
```

| Pfad / Modul | Verantwortung | Abhängigkeiten |
|---|---|---|
| `flake.nix` | Baut `packages.<system>.{base,agent-worker,container,image,default}` via `pkgs.dockerTools.buildLayeredImage` sowie `devShells` und `formatter` | `nixpkgs` |
| `images/{node,rust,go,nix}/Dockerfile` | Digest-gepinnte OCI-Job-Images für klassische CI/CD-Workflows (`linux/amd64`) | Gepinnte Upstream-Basis-Digests |
| `.github/workflows/images.yml` | Baut, veröffentlicht (nur auf `main`), signiert keyless mit Cosign und hängt SPDX-SBOM-Attestationen an | GitHub OIDC, GHCR, `cosign`, `syft` |
| `.github/workflows/guard.yml` | Führt `boundary-guard.sh`, ShellCheck, Unit-Tests und `gitleaks` in CI aus | `scripts/boundary-guard.sh` |
| `scripts/boundary-guard.sh` + `boundary-guard.conf` | Erzwingt Pfad-Allowlist und verhindert jeglichen Leak interner Namen, IPs, E-Mails oder Secrets | `git`, `bash` |
| `docs/ARCHITECTURE.md` | Normative Architekturbeschreibung der Schicht-4-Image-Fabrik, Signaturkette und Digest-Verträge | — |

## Domain language

| Term | Bedeutung |
|------|-----------|
| **`RagFit \| *` (`W8`)** | Souveräne 7-schichtige (`L0`–`L6`) Agent-First-Plattform-Dienstfamilie der ErynoaGroup |
| **`base` (`container` / `image`)** | Leichtgewichtiges, reproduzierbares Nix-OCI-Basis-Image (`bashInteractive`, `coreutils`, `gitMinimal`, `cacert`, `curl`, `jq`, UID `1000:1000`) |
| **`agent-worker`** | Spezialisiertes Nix-OCI-Sandbox-Image für autonome Agenten-Läufe (`ragfit-agent`) und Graph-Ingest (`atlasd`) inkl. `gitMinimal`, `cacert`, `curl`, `jq`, `ripgrep` |
| **Keyless Identity** | Exakte OIDC-Zertifikatsidentität `https://github.com/ErynoaGroup/ragfit-runner-images/.github/workflows/images.yml@refs/heads/main` beim Issuer `https://token.actions.githubusercontent.com` |
| **SPDX Attestation** | Per `syft` erzeugte und mit `cosign attest --type spdxjson` signierte Software Bill of Materials jedes veröffentlichten Digests |
| **Allowlist Guard** | Öffentliches Schutzprofil in `boundary-guard.conf` (`allow-path`), das ausschließlich explizit freigegebene Dateien zulässt |

## Tooling & commands

```bash
nix develop                # devShell mit just, git, shellcheck, gitleaks, hadolint, cosign, jq
just doctor                # Stamp + Boundary-Guard + ShellCheck + Unit-Tests
just ci-quick              # Schnelles lokales CI-Gate (Alias auf doctor)
just image                 # Baut das Standard-Nix-OCI-Image (nix build .#container)
just build-image           # Alias für just image
just build-agent-worker    # Baut das Nix-OCI-Agent-Worker-Image (nix build .#agent-worker)
just boundary              # Boundary-Guard über den gestagten Index (pre-commit)
just boundary-worktree     # Boundary-Guard über den gesamten Arbeitsbaum
just test                  # ShellCheck + boundary-guard.test.sh + verify-digests.test.sh
nix flake show             # Prüft und zeigt alle Flake-Outputs
```

## Skills & surface

| Area | Skill / Surface |
|------|-----------------|
| Doctrine + planner | `erynoa-md` (`$AGENT_SURFACE_ROOT/skills/erynoa-md`) |
| Docs / README / ADR style | `erynoa-docs` (`$AGENT_SURFACE_ROOT/skills/erynoa-docs`) |
| Global skills SSOT | `agent-surface` (`ErynoaGroup/.ai-harness`) |
| Org repository registry | `repo-index` (`ErynoaGroup/.repo-index`) |

## Provider adapters

Alle vier Provider-Einstiegsdateien sind im Repository vorhanden, in `boundary-guard.conf` freigegeben, enthalten den `ERYNOA-DOCTRINE`-Block (`R0`–`R10`, `Law R2 DynHom`) und verweisen auf [`erynoa.md`](./erynoa.md) sowie [`docs/ARCHITECTURE.md`](./docs/ARCHITECTURE.md):

- [`AGENTS.md`](./AGENTS.md)
- [`CLAUDE.md`](./CLAUDE.md) und [`.claude/CLAUDE.md`](./.claude/CLAUDE.md)
- [`.github/copilot-instructions.md`](./.github/copilot-instructions.md)

## Open questions

- [ ] **RN-C1 Live-Digest-Verify:** Aktivierung von `RN_C1_VERIFY=1` in `tests/rn-c1/verify-digests.test.sh`, sobald der erste automatisierte `images.lock`-Release-Zyklus auf `main` abgeschlossen ist (siehe [`docs/work/RN-C1-images-contract.md`](./docs/work/RN-C1-images-contract.md)).
- [ ] **Multi-Arch (`linux/arm64`):** Ausweitung des CI-Publish-Workflows auf `aarch64-linux`-Artefakte analog zu den bereits für `x86_64-linux` und `aarch64-linux` deklarierten Nix-OCI-Paketen in `flake.nix`.
