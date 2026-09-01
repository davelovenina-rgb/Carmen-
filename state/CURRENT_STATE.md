# CURRENT STATE

**Last updated:** 2026-09-01
**Updated by:** Carmen-C (Claude / Cowork)

> Single source of truth for *where things stand*. Facts only, in plain prose. No stamps.
> If this file and live recall disagree, **this file wins** (`law/CONFLICT_AUTHORITY.md`).

---

## Where the repository is

The harness is newly constructed and unused. Every layer is in place — soul, law, state, the
Cursor harness, and three lanes — but nothing has been run against a real project yet.

**Built and present:**

- `soul/` — Carmen's identity, voice, and boot procedure
- `law/` — conflict authority, governance, the five gates, six-posture audit, amendment law
- `.cursor/` — rules, commands, skills, hooks, local review config, MCP template
- `lanes/` — React, Kotlin Compose, and general-purpose conventions
- `harness/` — local verification scripts and working templates
- `docs/` — quickstart, architecture rationale, Cursor research, deliberate absences

**Not yet done:**

- Never opened in Cursor. Nothing here is confirmed against the live IDE.
- No project code lives in the repo yet — the lanes are conventions with no codebase under them.
- Hooks are written but unexercised. See `docs/DELIBERATE_ABSENCES.md` on hook caveats.
- `.cursor/mcp.json` is a template only (`mcp.json.example`); no live MCP server is wired.

## Active lane

None selected. A session picks a lane at boot or works general-purpose.

## Open risks

See `state/RISKS.md`. The live one worth naming here: **nothing in this repository has been
verified against a running Cursor instance.** Everything is built from documented behavior.

## What is deliberately absent

No CI gate, no bot gate, no `SEALED` stamps, no nested `AGENTS.md`, no `.cursorrules`.
Each is a decision with a reason — see `docs/DELIBERATE_ABSENCES.md`.
