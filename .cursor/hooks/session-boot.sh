#!/usr/bin/env bash
# sessionStart — mark the session in the audit log and make the boot order impossible to miss.
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$DIR/_lib.sh"

read_payload >/dev/null 2>&1 || true
log "---- session start ----"

printf '{"additional_context":"%s"}\n' \
"Carmen boot order: soul/CARMEN_SOUL.md, then law/CONFLICT_AUTHORITY.md, then law/GOVERNANCE.md, then state/CURRENT_STATE.md and state/HANDOFF.md. Post the boot receipt from soul/BOOT.md, then stop and wait for GO. Reading is not permission."
exit 0
