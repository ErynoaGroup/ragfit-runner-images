# Documentation map — RagFit | Runner Images

**Standard:** Erynoa Docs **v1** · skill **`erynoa-docs`**.

| Path | Purpose |
|------|---------|
| [`../README.md`](../README.md) | Product overview, W8 disambiguation, verification commands & quickstart |
| [`../erynoa.md`](../erynoa.md) | Canonical agent doctrine & planner (`Law R2 DynHom`) |
| **[`./ARCHITECTURE.md`](./ARCHITECTURE.md)** | **Normative Schicht-4-Architektur (Reproducible OCI Image Factory, Cosign Keyless Supply-Chain, Digest-Pinning)** |
| [`./decisions/`](./decisions/) | Architecture Decision Records (ADRs) |
| **[`./work/`](./work/)** | Work-root: [`work/ROADMAP.md`](./work/ROADMAP.md), [`work/RN-C1-images-contract.md`](./work/RN-C1-images-contract.md), `work/specs/`, `work/plans/`, `work/notes/` |

**Work-root:** `docs/work/`

**Branching:** Trunk-based · `main` · short-lived PRs ·  
`<type>/spec-NN/…` when spec-bound, else `<type>/<slug>`.  
→ **`erynoa-docs`** / **`using-spec-driven-git`**

## Workstream

1. [`work/ROADMAP.md`](./work/ROADMAP.md)  
2. [`ARCHITECTURE.md`](./ARCHITECTURE.md)  
3. `work/specs/SPEC-NN-slug.md`  
4. `work/plans/PLAN-NN-slug.md`  
5. Branch → implement → `just ci-quick` → PR into `main` (docs-as-code)  
