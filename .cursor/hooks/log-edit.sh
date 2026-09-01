#!/usr/bin/env bash
# afterFileEdit — append an audit trail of every file the agent changed.
#
# This hook fires after the fact and cannot block anything. Its job is memory: at Gate 4 it is the
# independent record of what was actually touched, next to what the delivery note claims.
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$DIR/_lib.sh"

payload="$(read_payload)"
file="$(printf '%s' "$payload" | json_str file_path)"
[ -n "$file" ] || exit 0

log "EDIT  $file"

if printf '%s' "$file" | grep -Eq "$GOVERNED_RE"; then
  log "WARN  governance file edited: $file"
fi
exit 0
