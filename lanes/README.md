# LANES

A lane is a body of convention for one kind of work. Three exist:

| Lane | For | Cursor rules |
|---|---|---|
| [`react/`](react/) | React, TypeScript, web UI | `300`–`330` |
| [`kotlin-compose/`](kotlin-compose/) | Kotlin, Jetpack Compose, Android/KMP | `400`–`440` |
| [`general/`](general/) | Everything else — scripts, tooling, data, docs | `200`–`220` |

Each lane holds the same four documents:

- **`CONVENTIONS.md`** — the rules, with the reasoning behind them
- **`ARCHITECTURE.md`** — how a project in this lane is laid out
- **`CHECKLIST.md`** — what to confirm before saying a change is done
- **`templates/`** — starting points that already follow the conventions

## How a lane reaches the agent

Two paths, deliberately:

1. **Automatically** — a `.cursor/rules/*.mdc` file with a `globs` pattern attaches the lane's
   core rules the moment a matching file enters context. Open a `.kt` file and the Kotlin rules
   are simply there.
2. **On demand** — `.cursor/skills/<lane>/SKILL.md` holds the fuller working reference. Only its
   name and description sit in context until the agent decides it needs the body.

That split is the whole design: the always-loaded surface stays small, and the depth stays one
step away. See `docs/ARCHITECTURE.md` §3.

## Picking a lane

A session states its lane at boot. Most work has an obvious one. Work that spans two — a Kotlin
backend serving a React frontend — uses both; the globs handle it per file with no ceremony.

## Adding a lane

1. Create `lanes/<name>/` with the four documents.
2. Add `.cursor/rules/<N>00-<name>-*.mdc` with a `globs` pattern for that lane's file types.
3. Add `.cursor/skills/<name>-lane/SKILL.md` for the on-demand depth.
4. Record it in `state/DECISIONS.md`.

Keep the always-on rules untouched. A new lane must not add anything to the three
`alwaysApply: true` files — that is the budget the whole design protects.
