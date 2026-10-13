# Agent rules

Rules for any automated agent or assistant working in this repository.

- Read [`erynoa.md`](./erynoa.md) first; it is the canonical project doctrine.
- This repository is **public**. Never add internal host names, IP addresses, e-mail addresses,
  account mentions, private repository names, local paths or secrets.
- Only image sources, their CI and the repository stamp belong here (enforced by
  `scripts/boundary-guard.sh` with `boundary-guard.conf`).
- Images are built, pushed and signed only by CI on `main`. No local builds are published.
- Run `just doctor` before opening a pull request.
