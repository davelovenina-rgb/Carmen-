# HARNESS

The working machinery: local verification and the templates that carry a unit of work through the
five gates.

## `verify.sh`

```bash
./harness/verify.sh
```

Seven groups of checks, every one of them a real failure mode rather than a hypothetical:

| # | Checks | Why it exists |
|---|---|---|
| 1 | Every governance file present | A missing law file means boot silently reads less than it should |
| 2 | `.mdc` frontmatter valid; ≤ 3 always-on rules | A `.md` in `.cursor/rules/` is **silently ignored** by Cursor — no error, it just never loads |
| 3 | Exactly one `AGENTS.md`, at the root | Nested ones load in **full on every request** (`state/DECISIONS.md` D-004) |
| 4 | Hooks executable and syntactically valid | A hook with a syntax error is a guard that is not guarding |
| 5 | No secret, key, or keystore in the tree | The only real defense; `.cursorignore` is not a security boundary |
| 6 | No seal or approval stamps | `law/GOVERNANCE.md` §10 — only David seals |
| 7 | Internal links resolve | A broken link in governance is documentation drift |

Exit `0` = all passed, `1` = at least one failed. This is what "verified" means here — there is
deliberately no CI gate and no bot in any gate (`law/GOVERNANCE.md` §11).

Run it before every handoff, and at Gate 4 as part of Posture 1.

## Templates

| Template | Gate | Purpose |
|---|---|---|
| [`PHASE_CARD.md`](templates/PHASE_CARD.md) | G1 | Scope in, scope out, done, risk |
| [`AUDIT_REPORT.md`](templates/AUDIT_REPORT.md) | G4 | Six-posture findings by severity |
| [`HANDOFF.md`](templates/HANDOFF.md) | end of session | What was done, what is open |
| [`DECISION.md`](templates/DECISION.md) | any time | A choice worth remembering, with its reasoning |

Commands that use them: `/phase-card`, `/audit`, `/handoff`, `/decide`.

## Adding a check

A new check belongs in `verify.sh` when it catches a **specific mistake that has actually
happened**, not a general good idea. Every existing check corresponds to a real failure mode.

Keep it dependency-free — no `jq`, no `python` — so it runs on any machine, always. A verification
script that needs its own setup is a verification script that stops being run.
