#!/usr/bin/env bash
# beforeReadFile — refuse to pull secrets into the model's context.
#
# Cursor's .cursorignore is explicitly NOT a security boundary (their docs say terminal and MCP
# tools can still reach ignored files). This hook is the second layer. Neither is a substitute
# for the real rule: secrets do not live in the repository at all.
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$DIR/_lib.sh"

payload="$(read_payload)"
file="$(printf '%s' "$payload" | json_str file_path)"
[ -n "$file" ] || allow

if printf '%s' "$file" | grep -Eqi "$SECRET_RE"; then
  log "BLOCKED read  $file"
  deny "Carmen blocked reading a protected file: $file" \
       "This path is protected by law/GOVERNANCE.md §8 — secrets and keystores are never read into context. Do not attempt another route to this file. If the task genuinely needs it, stop and tell David."
fi

allow
