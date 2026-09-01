# Carmen

**A Cursor-native harness for Carmen — soul, law, and craft, in one repository.**

Built fresh, September 2026. Nothing inherited from any prior Carmen repository.

---

## What this is

Not a template. Not a rules file. A working harness: an agent that boots with an identity, moves
through gates, verifies before it claims, and never acts without David's word — carrying
conventions for React, Kotlin Compose, and general-purpose work.

```
SOUL       who Carmen is
LAW        how work moves, and who decides
STATE      where things stand right now
LANES      how to build well in React, Kotlin Compose, or anything else
HARNESS    the machinery that carries all of it into Cursor
```

## Layout

| Path | What lives there |
|---|---|
| [`AGENTS.md`](AGENTS.md) | The single always-loaded entry point. 62 lines, deliberately. |
| [`soul/`](soul/) | Identity, voice, boot procedure |
| [`law/`](law/) | Conflict authority · governance · the five gates · six-posture audit · amendment law |
| [`state/`](state/) | Current state · handoff · decisions · risks · lessons · todo |
| [`.cursor/`](.cursor/) | 20 rules · 9 commands · 5 skills · 5 hooks · review config · MCP template |
| [`lanes/`](lanes/) | [React](lanes/react/) · [Kotlin Compose](lanes/kotlin-compose/) · [general](lanes/general/) |
| [`harness/`](harness/) | `verify.sh` and the working templates |
| [`docs/`](docs/) | Architecture · Cursor research · deliberate absences · quickstart · plan |

## Start here

```bash
git clone https://github.com/davelovenina-rgb/Carmen.git
cd Carmen
./harness/verify.sh          # expect PASS — 28 checks
```

Open the **folder** in Cursor (not a single file — hooks only load for a project), then:

```
/boot
```

Carmen reads soul → law → state, posts a receipt, and stops. That stop is the design.

Full walkthrough: [`docs/QUICKSTART.md`](docs/QUICKSTART.md).

## The five gates

```
SCOPE  →  DESIGN  →  BUILD  →  AUDIT  →  DAVID
```

Nothing skips a gate. A skipped gate is declared out loud, never passed quietly.
[`law/GATES.md`](law/GATES.md)

## Commands

| | |
|---|---|
| `/boot` | Read soul, law, state; post the receipt; stop |
| `/phase-card` | Open Gate 1 — scope in, scope out, done, risk |
| `/verify` | Run the local checks and report what was actually found |
| `/audit` | Gate 4 — all six postures |
| `/handoff` | Close the session; write what is open |
| `/decide` | Record a decision with its reasoning |
| `/react-screen` | Scaffold a React feature to the lane conventions |
| `/compose-screen` | Scaffold a Compose screen to the lane conventions |
| `/stop` | Something needs David before anything else happens |

## What is always true

1. **Nothing happens until David says GO.** Technical access is never permission.
2. **Verify from source or say "I don't know."**
3. **Turtle pace.** Scope first, trace the wires, zero regressions.
4. **David's flags are earned.** Stop and investigate. Never argue first.
5. **Carmen never merges and never seals.**

## Built on research, not assumption

The harness was designed after reading Cursor's current behavior — rules, hooks, commands, skills,
local review, MCP, indexing — with citations in
[`docs/CURSOR_RESEARCH.md`](docs/CURSOR_RESEARCH.md). Three findings shaped the whole structure:

- **A `.md` file in `.cursor/rules/` is silently ignored.** It must be `.mdc`. No error appears.
- **Nested `AGENTS.md` files load in full on every request** since Cursor 3.6. There is exactly
  one here, at the root.
- **`.cursor/rules` do not apply to Bugbot.** Review guidance is a separate channel,
  `.cursor/BUGBOT.md`.

Cursor's documentation lags its product — three removed features still had live docs pages during
this research. Verify against the changelog, not the docs page alone.

## Deliberately absent

No CI, no bot gate, no `SEALED` stamps, no nested `AGENTS.md`, no `.cursorrules`, no live
`mcp.json`. Each is a decision with a reason: [`docs/DELIBERATE_ABSENCES.md`](docs/DELIBERATE_ABSENCES.md).

## Status

Newly built. **Never opened in Cursor** — everything is from documented behavior, and that is
open risk R-001. See [`state/CURRENT_STATE.md`](state/CURRENT_STATE.md) and
[`docs/PLAN.md`](docs/PLAN.md).

---

***Amor Est Architectura · Veritas Formae***
*Love is Architecture · Truth of Form*
