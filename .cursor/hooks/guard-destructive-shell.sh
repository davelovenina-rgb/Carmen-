#!/usr/bin/env bash
# beforeShellExecution — block the commands that cannot be undone.
#
# Every pattern here corresponds to a real, expensive way to lose work. A blocked command is the
# system working; the answer is to bring it to David, not to reword it until it slips through.
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$DIR/_lib.sh"

payload="$(read_payload)"
cmd="$(printf '%s' "$payload" | json_str command)"
[ -n "$cmd" ] || allow

block() { log "BLOCKED shell: $cmd"; deny "Carmen blocked a destructive command: $1" "$2"; }

case "$cmd" in
  *"rm -rf /"*|*"rm -fr /"*|*"rm -rf ~"*|*"rm -rf \$HOME"*)
    block "recursive delete of a root or home path" \
          "Refuse this. Narrow the target to an explicit relative path inside the project and ask David first." ;;
esac

# Unrecoverable git — uncommitted work does not come back.
printf '%s' "$cmd" | grep -Eq 'git[[:space:]]+(reset[[:space:]]+--hard|clean[[:space:]]+-[a-z]*f|checkout[[:space:]]+--?[[:space:]]*\.)' \
  && block "git command that discards uncommitted work" \
           "law/GOVERNANCE.md §7. Uncommitted work is not recoverable. Show David 'git status' and let him decide."

printf '%s' "$cmd" | grep -Eq 'git[[:space:]]+push.*(--force|-f)([[:space:]]|$)' \
  && block "force push" \
           "Never force-push a shared branch or rewrite published history. If history truly must change, that is David's call."

printf '%s' "$cmd" | grep -Eq 'git[[:space:]]+(merge|rebase)' \
  && block "merge or rebase" \
           "Carmen never merges. David alone merges — law/GOVERNANCE.md §7, no exceptions. Open the PR and hand it to him."

# Keystores: losing one means the app can never be updated again, by anyone, forever.
printf '%s' "$cmd" | grep -Eqi '(keytool|\.keystore|\.jks)' \
  && block "keystore operation" \
           "law/GOVERNANCE.md §8. Never generate, move, overwrite, or read a keystore. Stop and tell David."

# Piping the internet straight into a shell.
printf '%s' "$cmd" | grep -Eq '(curl|wget)[^|]*\|[[:space:]]*(sudo[[:space:]]+)?(ba)?sh' \
  && block "piping a downloaded script into a shell" \
           "Download it, read it, then run it deliberately — or ask David to install it himself."

printf '%s' "$cmd" | grep -Eq '(^|[;&|[:space:]])sudo([[:space:]]|$)' \
  && block "sudo" \
           "Nothing in this workspace needs root. If it genuinely does, that is a conversation with David, not a command."

allow
