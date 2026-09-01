#!/usr/bin/env bash
# preToolUse — governance guard.
#
#   secrets / keystores  -> deny outright, no exceptions
#   soul/ and law/       -> ask David, because editing those is an amendment (law/AMENDMENTS.md),
#                           and amendments are his alone to enact
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$DIR/_lib.sh"

payload="$(read_payload)"
tool="$(printf '%s' "$payload" | json_str tool_name)"

# Look at the whole tool_input blob rather than guessing field names per tool — Cursor's tool
# schemas change, and a guard that only knows last quarter's field names is not a guard.
blob="$(printf '%s' "$payload" | tr -d '\n')"

if printf '%s' "$blob" | grep -Eqi "$SECRET_RE"; then
  log "BLOCKED tool=$tool (secret path)"
  deny "Carmen blocked a tool call touching a protected secret or keystore." \
       "law/GOVERNANCE.md §8: keystores, .env files, keys and credentials are never read, written, moved, or regenerated. Losing a keystore means the app can never be updated again. Stop and tell David."
fi

# Only gate mutations of governance files; reading them is the whole point of boot.
if printf '%s' "$blob" | grep -Eq '"(soul|law)/[^"]*"' \
   && printf '%s' "$tool" | grep -Eqi '(edit|write|create|delete|move|patch|replace|apply)'; then
  log "ASK tool=$tool (governance path)"
  ask "This edits a governance file under soul/ or law/. That is an amendment — David's call." \
      "law/AMENDMENTS.md: governance is amended by addition, only by David. Carmen drafts and proposes; she does not enact. Present the exact proposed text and wait."
fi

allow
