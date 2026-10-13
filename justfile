# Command surface. Enter tools with: nix develop
set shell := ["bash", "-euo", "pipefail", "-c"]

# list recipes
default:
    @just --list

# stamp, boundary guard and guard tests
doctor: stamp boundary-worktree test
    @echo "ok: doctor"

# repository stamp present
stamp:
    @test -f erynoa.md && grep -q 'AGENT-PLANNER:BEGIN' erynoa.md
    @test -f flake.nix && test -f justfile && test -f growth-budget.toml
    @grep -q 'erynoa.md' AGENTS.md
    @test -d docs/decisions && test -d docs/work
    @echo "ok: stamp"

# boundary guard on the staged content (as in pre-commit)
boundary:
    BOUNDARY_GUARD_CACHED=1 ./scripts/boundary-guard.sh

# boundary guard on the working tree
boundary-worktree:
    ./scripts/boundary-guard.sh

# lint and test the guard
test:
    shellcheck scripts/boundary-guard.sh tests/boundary-guard.test.sh
    tests/boundary-guard.test.sh
