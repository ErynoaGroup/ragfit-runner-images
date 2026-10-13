#!/usr/bin/env bash
# Shell tests for scripts/boundary-guard.sh (temporary git repos, no network, no nix).
set -euo pipefail
here="$(cd "$(dirname "$0")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
fail=0
n=0

# case <name> <want_rc> <conf> <file=content>... ; content "\n"-free single line
case_() {
  local name="$1" want="$2" conf="$3"; shift 3
  n=$((n + 1))
  local d="$tmp/$n"
  mkdir -p "$d/scripts"
  cp "$here/scripts/boundary-guard.sh" "$d/scripts/"
  git -C "$d" init -q
  printf '%b\n' "$conf" >"$d/boundary-guard.conf"
  local kv
  for kv in "$@"; do
    mkdir -p "$d/$(dirname "${kv%%=*}")"
    printf '%s\n' "${kv#*=}" >"$d/${kv%%=*}"
  done
  git -C "$d" add -A
  local rc=0
  (cd "$d" && env -u BOUNDARY_GUARD_EXTRA -u BOUNDARY_GUARD_ALLOW_NO_EXTRA ./scripts/boundary-guard.sh >/dev/null 2>&1) || rc=$?
  if [[ "$rc" == "$want" ]]; then echo "ok   $name"; else echo "FAIL $name (rc=$rc, want=$want)"; fail=1; fi
}

case_ clean                 0 'deny-path hosts/*' README.md=hi
case_ deny-path             1 'deny-path hosts/*' hosts/a/b.nix=x
case_ deny-root-doublestar  1 'deny-path **/Dockerfile' Dockerfile=x
case_ deny-nested           1 'deny-path **/Dockerfile' a/b/Dockerfile=x
case_ deny-ext              1 'deny-path *.age' secrets/x.age=x
case_ allowlist-ok          0 'allow-path images/*\nallow-path README.md' README.md=x images/n/Dockerfile=x
case_ allowlist-violation   1 'allow-path images/*\nallow-path README.md' README.md=x hosts/x=y
case_ legacy-exempt         0 'deny-path hosts/*\nlegacy hosts/a.nix' hosts/a.nix=x
case_ legacy-stale          1 'deny-path hosts/*\nlegacy hosts/gone.nix' README.md=x
case_ legacy-only-listed    1 'deny-path hosts/*\nlegacy hosts/a.nix' hosts/a.nix=x hosts/b.nix=y
case_ content               1 'deny-content BEGIN [A-Z ]*PRIVATE KEY' k.txt="-----BEGIN ""RSA PRIVATE KEY-----"
case_ content-clean         0 'deny-content BEGIN [A-Z ]*PRIVATE KEY' k.txt=harmless
case_ content-in            1 'deny-content-in flake.nix nixosConfigurations' flake.nix="nixos""Configurations.x = 1;"
case_ content-in-other-file 0 'deny-content-in flake.nix nixosConfigurations' docs.md="nixos""Configurations"
case_ exclude               0 'deny-content forbidden\nexclude docs/*' docs/a.md=forbidden
case_ bad-regex             2 'deny-content (' a.txt=x
case_ unknown-rule          2 'deny-paths x' a.txt=x
case_ no-rules              2 '# nothing' a.txt=x
case_ missing-arg           2 'deny-path' a.txt=x

case_ require-extra-missing 2 'deny-path x/*\nrequire-extra' a.txt=x
n=$((n + 1)); d="$tmp/$n"; mkdir -p "$d/scripts"; cp "$here/scripts/boundary-guard.sh" "$d/scripts/"
git -C "$d" init -q; printf 'deny-path x/*\nrequire-extra\n' >"$d/boundary-guard.conf"; echo "secret-name" >"$d/a"; git -C "$d" add -A
rc=0; (cd "$d" && env -u BOUNDARY_GUARD_ALLOW_NO_EXTRA BOUNDARY_GUARD_EXTRA=secret-name ./scripts/boundary-guard.sh >/dev/null 2>&1) || rc=$?
if [[ "$rc" == 1 ]]; then echo "ok   extra-match"; else echo "FAIL extra-match (rc=$rc)"; fail=1; fi
rc=0; (cd "$d" && env -u BOUNDARY_GUARD_EXTRA BOUNDARY_GUARD_ALLOW_NO_EXTRA=1 ./scripts/boundary-guard.sh >/dev/null 2>&1) || rc=$?
if [[ "$rc" == 0 ]]; then echo "ok   extra-opt-out"; else echo "FAIL extra-opt-out (rc=$rc)"; fail=1; fi
rc=0; (cd "$d" && env -u BOUNDARY_GUARD_ALLOW_NO_EXTRA BOUNDARY_GUARD_EXTRA=$'\n' ./scripts/boundary-guard.sh >/dev/null 2>&1) || rc=$?
if [[ "$rc" == 2 ]]; then echo "ok   extra-blank"; else echo "FAIL extra-blank (rc=$rc)"; fail=1; fi

# missing conf
n=$((n + 1)); d="$tmp/$n"; mkdir -p "$d/scripts"; cp "$here/scripts/boundary-guard.sh" "$d/scripts/"
git -C "$d" init -q; echo x >"$d/a"; git -C "$d" add -A
rc=0; (cd "$d" && ./scripts/boundary-guard.sh >/dev/null 2>&1) || rc=$?
if [[ "$rc" == 2 ]]; then echo "ok   missing-conf"; else echo "FAIL missing-conf (rc=$rc)"; fail=1; fi

# cached: staged leak found although worktree is clean
n=$((n + 1)); d="$tmp/$n"; mkdir -p "$d/scripts"; cp "$here/scripts/boundary-guard.sh" "$d/scripts/"
git -C "$d" init -q; echo 'deny-content forbidden' >"$d/boundary-guard.conf"
echo forbidden >"$d/a"; git -C "$d" add -A; echo fine >"$d/a"
rc=0; (cd "$d" && BOUNDARY_GUARD_CACHED=1 ./scripts/boundary-guard.sh >/dev/null 2>&1) || rc=$?
if [[ "$rc" == 1 ]]; then echo "ok   cached-staged"; else echo "FAIL cached-staged (rc=$rc)"; fail=1; fi

# the repo's own config must pass on the repo itself
rc=0; (cd "$here" && BOUNDARY_GUARD_ALLOW_NO_EXTRA="${BOUNDARY_GUARD_ALLOW_NO_EXTRA:-0}" ./scripts/boundary-guard.sh >/dev/null 2>&1) || rc=$?
if [[ "$rc" == 0 ]]; then echo "ok   self"; else echo "FAIL self (rc=$rc)"; fail=1; fi

# script must match the recorded source hash (sync check, RR1)
if [[ -f "$here/scripts/boundary-guard.sha256" ]]; then
  if (cd "$here" && sha256sum --quiet -c scripts/boundary-guard.sha256); then echo "ok   sync-hash"; else echo "FAIL sync-hash"; fail=1; fi
fi

exit "$fail"
