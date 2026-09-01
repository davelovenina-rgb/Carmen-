#!/usr/bin/env bash
#
# Carmen — repository verification.
#
# Local checks only. There is deliberately no CI gate and no bot in any gate here
# (law/GOVERNANCE.md §11). This script is what "verified" means in this repository.
#
# Exit 0 = all checks passed. Exit 1 = at least one failed.

set -uo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 1

PASS=0; FAIL=0
ok()   { printf '  \033[32mok\033[0m    %s\n' "$1"; PASS=$((PASS+1)); }
bad()  { printf '  \033[31mFAIL\033[0m  %s\n' "$1"; FAIL=$((FAIL+1)); }
sect() { printf '\n\033[1m%s\033[0m\n' "$1"; }

printf '\033[1mCarmen — repository verification\033[0m\n'

# ── 1. Structure ──────────────────────────────────────────────────────────────
sect '1. Structure'
for f in AGENTS.md soul/CARMEN_SOUL.md soul/VOICE.md soul/BOOT.md \
         law/GOVERNANCE.md law/CONFLICT_AUTHORITY.md law/GATES.md \
         law/AUDIT_SIX_POSTURE.md law/AMENDMENTS.md \
         state/CURRENT_STATE.md state/HANDOFF.md state/DECISIONS.md \
         state/RISKS.md state/LESSONS_LEARNED.md state/TODO.md \
         .cursor/hooks.json .cursor/BUGBOT.md .cursorignore; do
  [ -f "$f" ] && ok "$f" || bad "missing: $f"
done

# ── 2. Cursor rules ───────────────────────────────────────────────────────────
# A .md file in .cursor/rules/ is SILENTLY ignored by Cursor — no error, it just never loads.
# That failure mode is invisible in the editor, which is exactly why it is checked here.
sect '2. Cursor rules'
stray=$(find .cursor/rules -maxdepth 2 -name '*.md' 2>/dev/null)
[ -z "$stray" ] && ok "no .md files in .cursor/rules (they would be silently ignored)" \
                || bad "stray .md in .cursor/rules — rename to .mdc: $stray"

rules=0; always=0
while IFS= read -r f; do
  rules=$((rules+1))
  head3=$(head -1 "$f")
  [ "$head3" = "---" ] || { bad "$f: does not open with YAML frontmatter"; continue; }

  fm=$(sed -n '2,/^---$/p' "$f" | sed '$d')
  bad_key=$(printf '%s' "$fm" | grep -E '^[a-zA-Z_-]+:' | grep -vE '^(description|globs|alwaysApply):' || true)
  [ -n "$bad_key" ] && bad "$f: unknown frontmatter key(s): $(printf '%s' "$bad_key" | tr '\n' ' ')"

  printf '%s' "$fm" | grep -q '^alwaysApply:' \
    || bad "$f: alwaysApply not written explicitly (never omit it)"

  printf '%s' "$fm" | grep -qE '^globs:\s*\[' \
    && bad "$f: globs is a comma-separated string, not a YAML list"

  printf '%s' "$fm" | grep -q '^alwaysApply: true' && always=$((always+1))

  lines=$(wc -l < "$f")
  [ "$lines" -gt 500 ] && bad "$f: $lines lines — Cursor's guidance is to stay under 500"
done < <(find .cursor/rules -name '*.mdc' 2>/dev/null | sort)

ok "$rules rule file(s) parsed"
if [ "$always" -le 3 ]; then
  ok "$always always-on rule(s) — every request pays for these, so the budget is 3"
else
  bad "$always always-on rules — over the budget of 3 (docs/ARCHITECTURE.md §3)"
fi

# ── 3. AGENTS.md ──────────────────────────────────────────────────────────────
# Cursor 3.6+ discovers nested AGENTS.md across the whole repo and loads each in FULL on every
# request. One root file is a deliberate decision (state/DECISIONS.md D-004).
sect '3. AGENTS.md'
count=$(find . -name 'AGENTS.md' -not -path './.git/*' | wc -l | tr -d ' ')
[ "$count" = "1" ] && ok "exactly one AGENTS.md, at the root" \
                   || bad "$count AGENTS.md files — nested ones load in full on every request (D-004)"

# ── 4. Hooks ──────────────────────────────────────────────────────────────────
sect '4. Hooks'
if [ -f .cursor/hooks.json ]; then
  grep -q '"version": *1' .cursor/hooks.json && ok "hooks.json declares version 1" \
                                             || bad "hooks.json missing \"version\": 1"
  hooks_ok=1
  while IFS= read -r s; do
    [ -x "$s" ] || { bad "hook not executable: $s (chmod +x)"; hooks_ok=0; }
    bash -n "$s" 2>/dev/null || { bad "hook has a syntax error: $s"; hooks_ok=0; }
  done < <(find .cursor/hooks -name '*.sh' | sort)
  [ "$hooks_ok" = "1" ] && ok "all hook scripts executable and syntactically valid"
fi

# ── 5. Secrets ────────────────────────────────────────────────────────────────
sect '5. Secrets'
leaked=$(find . \( -name '*.keystore' -o -name '*.jks' -o -name '*.pem' -o -name '*.key' \
                   -o -name '.env' -o -name '.env.*' -o -name 'credentials.json' \) \
              -not -path './.git/*' -not -name '*.example' 2>/dev/null)
[ -z "$leaked" ] && ok "no secret, key, or keystore in the tree" \
                 || bad "secret material present: $leaked"

[ -f .cursor/mcp.json ] && bad ".cursor/mcp.json exists — it is gitignored, confirm it is not staged" \
                        || ok "no live .cursor/mcp.json (only the .example is tracked)"

# ── 6. No stamps ──────────────────────────────────────────────────────────────
# law/GOVERNANCE.md §10 — only David seals, in his own words.
sect '6. No-stamp rule'
stamped=$(grep -rlE '^\s*(\*\*)?(SEALED|APPROVED|VERIFIED BY)\b' \
           --include='*.md' --include='*.mdc' . 2>/dev/null | grep -v '/law/GOVERNANCE.md' || true)
[ -z "$stamped" ] && ok "no seal or approval stamps written" \
                  || bad "stamp found (GOVERNANCE §10): $stamped"

# ── 7. Internal links ─────────────────────────────────────────────────────────
sect '7. Internal links'
broken=0
while IFS= read -r hit; do
  f="${hit%%::*}"; target="${hit##*::}"
  case "$target" in http*|"#"*|mailto:*|"") continue;; esac
  t="${target%%#*}"
  [ -z "$t" ] && continue
  d=$(dirname "$f")
  if [ ! -e "$d/$t" ]; then bad "broken link in $f -> $t"; broken=$((broken+1)); fi
done < <(grep -rEoh --include='*.md' --include='*.mdc' '' /dev/null 2>/dev/null; \
         grep -rEn --include='*.md' --include='*.mdc' '\]\([^)]+\)' . 2>/dev/null \
         | sed -E 's/^([^:]+):[0-9]+:.*/\1/;' > /dev/null; \
         for f in $(find . -name '*.md' -o -name '*.mdc' | grep -v '/.git/'); do \
           grep -Eo '\]\([^)]+\)' "$f" 2>/dev/null | sed -E 's/^\]\((.*)\)$/\1/' \
           | while read -r tgt; do printf '%s::%s\n' "$f" "$tgt"; done; \
         done)
[ "$broken" = "0" ] && ok "no broken relative links"

# ── Result ────────────────────────────────────────────────────────────────────
printf '\n────────────────────────────────────\n'
if [ "$FAIL" -eq 0 ]; then
  printf '\033[32mPASS\033[0m  %d checks\n\n' "$PASS"
  exit 0
else
  printf '\033[31mFAIL\033[0m  %d passed, %d failed\n\n' "$PASS" "$FAIL"
  exit 1
fi
