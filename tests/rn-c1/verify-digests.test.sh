#!/usr/bin/env bash
# RN-C1 stub: verify published image digests with the exact keyless identity.
# Disabled by default and not wired into any workflow (docs/work/RN-C1-images-contract.md).
set -euo pipefail
if [[ "${RN_C1_VERIFY:-0}" != "1" ]]; then
  echo "skip: RN-C1 digest verification is not enabled"
  exit 0
fi
echo "::error::RN-C1 digest verification is not implemented yet" >&2
exit 2
