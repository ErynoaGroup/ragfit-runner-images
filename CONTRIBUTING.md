# Contributing

## Boundary guard is fail-closed

The boundary guard (`scripts/boundary-guard.sh`, configured by `boundary-guard.conf`) is **fail-closed by design**:

- Internal patterns are not stored in the repository. They come from the CI secret `BOUNDARY_GUARD_EXTRA`. If it is missing or empty, the guard exits with code 2 and the check is red. This is intended.
- **Pull requests from forks stay red.** GitHub does not pass secrets to fork pull requests, so `BOUNDARY_GUARD_EXTRA` is never available there. `pull_request_target` is deliberately **not** used, because it would run untrusted code with secrets and write access.
- There is **no warn-only variant** and no bypass in CI. `BOUNDARY_GUARD_ALLOW_NO_EXTRA` is never set in workflows.
- A maintainer can take over an outside change onto a branch in this repository, where the check can run with the secret.
- Locally, run the tests with a placeholder pattern, for example `BOUNDARY_GUARD_EXTRA=placeholder-no-match tests/boundary-guard.test.sh`. Never commit real patterns.
