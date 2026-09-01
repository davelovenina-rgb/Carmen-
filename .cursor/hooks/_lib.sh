#!/usr/bin/env bash
# Shared helpers for Carmen's Cursor hooks.
# Deliberately dependency-free: no jq, no python. These must run on any machine, always.
set -uo pipefail

# Read all of stdin, stripping a UTF-8 BOM if Cursor prepended one.
# (A known Windows issue: a BOM breaks naive JSON parsing and silently degrades guards.)
read_payload() { tr -d '\r' | sed '1s/^\xEF\xBB\xBF//'; }

# Crude single-key string extractor. Good enough for flat fields like file_path and command,
# and it cannot itself fail in a way that lets something through unnoticed.
json_str() { # json_str <key> <<< "$payload"
  sed -n "s/.*\"$1\"[[:space:]]*:[[:space:]]*\"\(\([^\"\\\\]\|\\\\.\)*\)\".*/\1/p" | head -1
}

allow() { printf '{"permission":"allow"}\n'; exit 0; }

deny() { # deny <user message> <agent message>
  printf '{"permission":"deny","user_message":%s,"agent_message":%s}\n' \
    "$(esc "$1")" "$(esc "$2")"
  exit 0
}

ask() { # ask <user message> <agent message>
  printf '{"permission":"ask","user_message":%s,"agent_message":%s}\n' \
    "$(esc "$1")" "$(esc "$2")"
  exit 0
}

esc() { printf '"%s"' "$(printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g' | tr '\n' ' ')"; }

log() { # log <line>
  local dir="${CURSOR_PROJECT_DIR:-.}/.cursor"
  [ -d "$dir" ] || return 0
  printf '%s  %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$1" >> "$dir/audit.log" 2>/dev/null || true
}

# Paths that must never be read, written, or touched by anything.
SECRET_RE='(\.keystore|\.jks|\.pem$|\.p12$|\.pfx$|id_rsa|/\.env|^\.env|\.env\.|secrets?\.(json|ya?ml)|credentials)'

# Governance paths — amendments only, on David's explicit word.
GOVERNED_RE='(^|/)(soul|law)/'
