#!/usr/bin/env bash
# boundary-guard: enforces which files and contents a repository may hold.
# Same script in every runner repository; only boundary-guard.conf differs per repo.
# Exit codes: 0 = clean, 1 = violation, 2 = configuration or runtime error (fail closed).
#
# Config lines (boundary-guard.conf, '#' starts a comment):
#   deny-path <glob>              tracked path must not match
#   allow-path <glob>             if present at all: every tracked path must match one (allowlist)
#   deny-content <ERE>            no tracked text file may match
#   deny-content-in <glob> <ERE>  files matching <glob> must not match <ERE>
#   legacy <path>                 known misplacement, exempt from path rules; must still exist
#   exclude <glob>                path not scanned for content
#   require-extra                 BOUNDARY_GUARD_EXTRA (newline-separated ERE, kept outside git, e.g. a
#                                 CI secret) must provide extra deny-content patterns; unset or empty
#                                 fails unless BOUNDARY_GUARD_ALLOW_NO_EXTRA=1 (logged warning)
# Globs: bash patterns, '*' also matches '/'; a leading '**/' also matches at the root.
# BOUNDARY_GUARD_CACHED=1 checks the staged index content (pre-commit), else the worktree.
set -euo pipefail

root="$(git rev-parse --show-toplevel)" || exit 2
cd "$root"
conf="${BOUNDARY_GUARD_CONF:-boundary-guard.conf}"
[[ -r "$conf" ]] || { echo "::error::boundary-guard: $conf missing" >&2; exit 2; }

deny_path=() allow_path=() deny_content=() in_glob=() in_re=() legacy=() exclude=()
exclude+=("$conf" scripts/boundary-guard.sh scripts/boundary-guard.sha256 tests/boundary-guard.test.sh)
require_extra=0
lineno=0
while IFS= read -r line || [[ -n "$line" ]]; do
  lineno=$((lineno + 1))
  line="${line%%$'\r'}"
  [[ "$line" =~ ^[[:space:]]*(#|$) ]] && continue
  kind="${line%% *}"; rest="${line#* }"
  if [[ "$kind" == "require-extra" ]]; then require_extra=1; continue; fi
  [[ "$kind" == "$line" ]] && { echo "::error::$conf:$lineno: missing argument" >&2; exit 2; }
  case "$kind" in
    deny-path) deny_path+=("$rest") ;;
    allow-path) allow_path+=("$rest") ;;
    deny-content) deny_content+=("$rest") ;;
    deny-content-in) in_glob+=("${rest%% *}"); in_re+=("${rest#* }")
      [[ "${rest%% *}" == "$rest" ]] && { echo "::error::$conf:$lineno: deny-content-in needs <glob> <ERE>" >&2; exit 2; } ;;
    legacy) legacy+=("$rest") ;;
    exclude) exclude+=("$rest") ;;
    require-extra) require_extra=1 ;;
    *) echo "::error::$conf:$lineno: unknown rule '$kind'" >&2; exit 2 ;;
  esac
done <"$conf"
extra_n=0
if [[ -n "${BOUNDARY_GUARD_EXTRA:-}" ]]; then
  while IFS= read -r p; do
    if [[ -n "$p" ]]; then deny_content+=("$p"); extra_n=$((extra_n + 1)); fi
  done <<<"$BOUNDARY_GUARD_EXTRA"
  echo "boundary-guard: $extra_n extra patterns from BOUNDARY_GUARD_EXTRA"
fi
if (( require_extra && extra_n == 0 )); then
  if [[ "${BOUNDARY_GUARD_ALLOW_NO_EXTRA:-0}" == "1" ]]; then
    echo "::warning::boundary-guard: BOUNDARY_GUARD_EXTRA missing; extra patterns NOT checked (explicitly allowed)" >&2
  else
    echo "::error::boundary-guard: $conf requires BOUNDARY_GUARD_EXTRA (or BOUNDARY_GUARD_ALLOW_NO_EXTRA=1)" >&2
    exit 2
  fi
fi
if (( ${#deny_path[@]} + ${#allow_path[@]} + ${#deny_content[@]} + ${#in_glob[@]} == 0 )); then
  echo "::error::boundary-guard: $conf defines no rules" >&2; exit 2
fi

match() { # path glob
  local p="$1" g="$2"
  # shellcheck disable=SC2053
  [[ "$p" == $g ]] && return 0
  if [[ "$g" == '**/'* ]]; then
    # shellcheck disable=SC2053
    [[ "$p" == ${g#'**/'} ]] && return 0
  fi
  return 1
}
any_match() { local p="$1"; shift; local g; for g in "$@"; do match "$p" "$g" && return 0; done; return 1; }

mapfile -d '' files < <(git ls-files -z) || exit 2
fail=0

for l in "${legacy[@]}"; do
  printf '%s\n' "${files[@]}" | grep -qxF -- "$l" || {
    echo "::error::boundary-guard: legacy entry '$l' is not tracked anymore; remove it from $conf" >&2; fail=1; }
done

# The guard's own files are always allowed (they are excluded from content scans above).
self_files=("$conf" scripts/boundary-guard.sh scripts/boundary-guard.sha256 tests/boundary-guard.test.sh)

for f in "${files[@]}"; do
  if printf '%s\n' "${self_files[@]}" | grep -qxF -- "$f"; then continue; fi
  if (( ${#legacy[@]} )) && printf '%s\n' "${legacy[@]}" | grep -qxF -- "$f"; then continue; fi
  if (( ${#deny_path[@]} )) && any_match "$f" "${deny_path[@]}"; then
    echo "::error::boundary-guard: path not allowed in this repo: $f" >&2; fail=1
  fi
  if (( ${#allow_path[@]} )) && ! any_match "$f" "${allow_path[@]}"; then
    echo "::error::boundary-guard: path outside allowlist: $f" >&2; fail=1
  fi
done

scope=()
[[ "${BOUNDARY_GUARD_CACHED:-0}" == "1" ]] && scope=(--cached)
pathspec=(-- .)
for e in "${exclude[@]}"; do pathspec+=(":(exclude,glob)$e"); done

grep_rc() { # extra-args...
  local rc=0
  git grep "${scope[@]}" -nIE "$@" || rc=$?
  return "$rc"
}

if (( ${#deny_content[@]} )); then
  args=(); for r in "${deny_content[@]}"; do args+=(-e "$r"); done
  rc=0; grep_rc "${args[@]}" "${pathspec[@]}" || rc=$?
  case "$rc" in
    0) echo "::error::boundary-guard: forbidden content (see above)" >&2; fail=1 ;;
    1) ;;
    *) echo "::error::boundary-guard: content scan failed (git grep exit $rc)" >&2; exit 2 ;;
  esac
fi

for i in "${!in_glob[@]}"; do
  rc=0; grep_rc -e "${in_re[$i]}" -- ":(glob)${in_glob[$i]}" || rc=$?
  case "$rc" in
    0) echo "::error::boundary-guard: forbidden content in ${in_glob[$i]} (see above)" >&2; fail=1 ;;
    1) ;;
    *) echo "::error::boundary-guard: content scan failed (git grep exit $rc)" >&2; exit 2 ;;
  esac
done

if (( fail )); then exit 1; fi
echo "boundary-guard: clean (${#files[@]} files, ${#legacy[@]} legacy exemptions)"
