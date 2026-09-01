# QUICKSTART

Ten minutes from clone to a working Carmen session in Cursor.

---

## 1. Clone and open

```bash
git clone https://github.com/davelovenina-rgb/Carmen.git
cd Carmen
```

**Open the folder in Cursor, not a single file.** Hooks only load for a project — open one file
and they never activate.

## 2. Verify it landed intact

```bash
./harness/verify.sh
```

Expect `PASS`. If anything fails, fix that before working — a failing check here means part of the
harness is not loaded, and Cursor will not tell you.

## 3. Confirm Cursor sees the harness

- **Customize → Rules** — three always-on rules (`000`, `010`, `020`) plus the conditional ones.
  If a rule is missing, check it is `.mdc` and not `.md`.
- Type `/` in the agent input — `/boot`, `/phase-card`, `/verify`, `/audit`, `/handoff`, and the
  rest should appear.
- Open a `.kt` or `.tsx` file and ask what rules are active. The matching lane rules should attach.

## 4. Boot

```
/boot
```

Carmen reads soul → law → state, posts a boot receipt, and **stops**. That stop is the design, not
a hesitation: boot is not permission to act.

## 5. Start a unit of work

```
/phase-card
```

She drafts the scope card, presents it, and stops. Read it. Say **GO** when it is right.

Then: `/verify` any time · `/audit` at Gate 4 · `/handoff` at the end of the session.

---

## MCP (optional)

```bash
cp .cursor/mcp.json.example .cursor/mcp.json
```

Edit it. Every secret stays as `${env:VAR}` — never paste a literal token. `.cursor/mcp.json` is
gitignored on purpose.

## Hooks (optional but recommended)

The five hooks in `.cursor/hooks.json` activate automatically. Two things to know:

- `beforeShellExecution` may need **Settings → Chat → "Run Everything"** enabled to fire.
- Hooks reportedly do not activate over Remote-SSH.

**Test that the guards actually work** before trusting them — ask Carmen to run
`git reset --hard`. It should be blocked. If it is not, the hooks are not loading, and
`state/RISKS.md` R-002 is still open.

To disable them, rename `.cursor/hooks.json` — do not delete it.

---

## The five gates

```
SCOPE  →  DESIGN  →  BUILD  →  AUDIT  →  DAVID
```

Full text in [`law/GATES.md`](../law/GATES.md). Nothing skips a gate; a skipped gate is declared
out loud rather than passed quietly.

## Where to look

| Question | File |
|---|---|
| Who is Carmen? | [`soul/CARMEN_SOUL.md`](../soul/CARMEN_SOUL.md) |
| What are the rules? | [`law/GOVERNANCE.md`](../law/GOVERNANCE.md) |
| What wins a conflict? | [`law/CONFLICT_AUTHORITY.md`](../law/CONFLICT_AUTHORITY.md) |
| Where do things stand? | [`state/CURRENT_STATE.md`](../state/CURRENT_STATE.md) |
| How do I write React here? | [`lanes/react/CONVENTIONS.md`](../lanes/react/CONVENTIONS.md) |
| How do I write Compose here? | [`lanes/kotlin-compose/CONVENTIONS.md`](../lanes/kotlin-compose/CONVENTIONS.md) |
| Why is it built this way? | [`ARCHITECTURE.md`](ARCHITECTURE.md) |
| What did Cursor research find? | [`CURSOR_RESEARCH.md`](CURSOR_RESEARCH.md) |
| Why is X missing? | [`DELIBERATE_ABSENCES.md`](DELIBERATE_ABSENCES.md) |

## Three things that will save you an afternoon

1. **A `.md` file in `.cursor/rules/` is silently ignored.** It must be `.mdc`. No error appears.
2. **Never add a second `AGENTS.md`.** Nested ones load in full on every request.
3. **Never add a fourth always-on rule** without moving something out. `verify.sh` will stop you.
