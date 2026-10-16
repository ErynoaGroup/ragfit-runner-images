# Command surface. Enter tools with: nix develop
set shell := ["bash", "-euo", "pipefail", "-c"]

# list recipes
default:
    @just --list

# stamp, boundary guard and guard tests
doctor: stamp boundary-worktree test
    @echo "ok: doctor"

# fast CI gate (alias for doctor)
ci-quick: doctor
    @echo "ok: ci-quick"

# build default Nix OCI container image (.#container)
image:
    nix build .#container

# alias for Nix OCI container image build
build-image: image

# build agent-worker Nix OCI container image (.#agent-worker)
build-agent-worker:
    nix build .#agent-worker

# repository stamp present
stamp:
    @test -f erynoa.md && grep -q 'AGENT-PLANNER:BEGIN' erynoa.md
    @test -f flake.nix && test -f justfile && test -f growth-budget.toml
    @grep -q 'erynoa.md' AGENTS.md CLAUDE.md .claude/CLAUDE.md .github/copilot-instructions.md
    @test -d docs/decisions && test -d docs/work
    @echo "ok: stamp"

# boundary guard on the staged content (as in pre-commit)
boundary:
    BOUNDARY_GUARD_ALLOW_NO_EXTRA="${BOUNDARY_GUARD_ALLOW_NO_EXTRA:-1}" BOUNDARY_GUARD_CACHED=1 ./scripts/boundary-guard.sh

# boundary guard on the working tree
boundary-worktree:
    BOUNDARY_GUARD_ALLOW_NO_EXTRA="${BOUNDARY_GUARD_ALLOW_NO_EXTRA:-1}" ./scripts/boundary-guard.sh

# lint and test the guard
test:
    if command -v shellcheck >/dev/null 2>&1; then shellcheck scripts/boundary-guard.sh tests/boundary-guard.test.sh tests/rn-c1/verify-digests.test.sh; fi
    BOUNDARY_GUARD_ALLOW_NO_EXTRA="${BOUNDARY_GUARD_ALLOW_NO_EXTRA:-1}" tests/boundary-guard.test.sh
    tests/rn-c1/verify-digests.test.sh
