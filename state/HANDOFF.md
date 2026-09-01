# HANDOFF

**One live handoff at a time.** When a session ends, it writes here. When the next session boots,
it reads here. Old handoffs move to the archive section below — they are never deleted.

---

## LIVE

**Surface:** Cowork (Claude) — construction session
**Date:** 2026-09-01
**Status:** Harness constructed. Untested against a live Cursor instance.

**What was done**

Built the Carmen harness from scratch: soul, law, state, `.cursor/` harness, three lanes,
verification scripts, and documentation. Research on Cursor's current behavior (rules, hooks,
commands, skills, local review, MCP, indexing, ignore files) was done first and is recorded with
citations in `docs/CURSOR_RESEARCH.md`.

**What is open**

1. **Open the repo in Cursor and confirm the harness loads.** Specifically: that the three
   `alwaysApply: true` rules appear in the Rules panel, that a globbed rule attaches when a
   matching file is opened, and that `/boot` shows up in the slash-command list.
2. **Decide whether hooks stay enabled.** They are written but unexercised. Cursor staff have
   described project-level hooks as experimental, and `beforeShellExecution` needs
   "Run Everything" enabled to fire. See `docs/CURSOR_RESEARCH.md` §Hooks.
3. **Choose whether a real project lives in this repo or the harness is copied into projects.**
   Both work; `docs/ARCHITECTURE.md` §7 lays out the trade-off. This is David's call.
4. **Name the architecture.** David deferred naming — the repo is `Carmen`, and the harness
   inside it has no formal name yet.

**Nothing is waiting on a bot, a CI run, or another seat.**

---

## ARCHIVE

*(empty — first handoff)*
