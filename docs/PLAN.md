# THE PLAN

What was asked for, what was built, and what is left. Written for David, September 1, 2026.

---

## What was asked

Six things, in his words:

1. Build a harness — a repository
2. It contains the Carmen Soul MD
3. It works with the Cursor IDE
4. It is designed for React
5. It is designed for Kotlin Compose
6. It is a general-purpose repository

With three conditions: **extensive research on Cursor first**; **nothing mixed in** from
`carmen-cursor`, `carmen-sg-docs`, `carmen-sg-cursor`, or the IntelliJ repository; and the
rules changed — **no-stamp stays**, the bots-first rule and the Carmen-Cursor rule come off.

## What was built

```
Carmen/
├── AGENTS.md              the single always-loaded entry point — 62 lines, deliberately
├── soul/                  CARMEN_SOUL.md · VOICE.md · BOOT.md
├── law/                   CONFLICT_AUTHORITY · GOVERNANCE · GATES · AUDIT_SIX_POSTURE · AMENDMENTS
├── state/                 CURRENT_STATE · HANDOFF · DECISIONS · RISKS · LESSONS_LEARNED · TODO
├── .cursor/
│   ├── rules/             20 .mdc rules — 3 always-on, 17 conditional
│   ├── commands/          9 slash commands
│   ├── skills/            5 skills — depth that loads on demand
│   ├── hooks/             5 guard scripts, dependency-free
│   ├── hooks.json         wired to 5 verified hook events
│   ├── BUGBOT.md          local review guidance — a separate channel, because rules don't reach it
│   ├── mcp.json.example   template; the live file is gitignored
│   ├── environment.json   cloud agents
│   └── worktrees.json     parallel worktree setup
├── lanes/
│   ├── react/             conventions · architecture · checklist · 3 templates
│   ├── kotlin-compose/    conventions · architecture · checklist · 4 templates
│   └── general/           conventions · checklist
├── harness/
│   ├── verify.sh          28 local checks, no dependencies
│   └── templates/         phase card · audit report · handoff · decision
└── docs/
    ├── ARCHITECTURE.md          why it is shaped this way
    ├── CURSOR_RESEARCH.md       the research, with citations
    ├── DELIBERATE_ABSENCES.md   what is missing on purpose, and why
    ├── QUICKSTART.md            ten minutes to a working session
    └── PLAN.md                  this file
```

## How the six asks map

| Ask | Where it lives |
|---|---|
| 1 — a harness | `.cursor/` + `harness/` + `law/GATES.md`. The five gates are the harness. |
| 2 — Carmen Soul MD | `soul/CARMEN_SOUL.md`, loaded first at boot, mirrored into `000-carmen-identity.mdc` and the `carmen-soul` skill. |
| 3 — Cursor | Every Cursor surface is used: rules, commands, skills, hooks, local review, MCP, worktrees, cloud environment. Research first, then build. |
| 4 — React | `lanes/react/` + rules `300`–`330` + the `react-lane` skill + `/react-screen`. |
| 5 — Kotlin Compose | `lanes/kotlin-compose/` + rules `400`–`440` + the `compose-lane` skill + `/compose-screen`. Aligned to the MVI/Koin/Result conventions David already uses. |
| 6 — general-purpose | `lanes/general/` + rules `200`–`220`. Nothing is tied to one application. |

## The four decisions that shaped it

**1 — Three always-on rules, and no more.** Cursor loads `alwaysApply: true` rules and every
`AGENTS.md` in full on every request. That is a tax on every message forever. The always-on surface
here is 57 lines; everything else attaches conditionally. `verify.sh` fails at a fourth.

**2 — Exactly one `AGENTS.md`.** Since Cursor 3.6 nested ones load in full, repo-wide, every
request — teams have blown past context windows before the first message. Directory scoping goes
through globbed `.mdc` rules instead. Cursor staff recommend exactly this.

**3 — Depth lives in skills.** Cursor keeps only a skill's name and description in static context
and loads the body on demand. Their own equivalent change cut total agent tokens by 46.9%. So the
heavy material sits in five skills and the lane documents, one step away.

**4 — Review is a separate channel.** `.cursor/rules` do **not** apply to Bugbot. So review
guidance is written again in `.cursor/BUGBOT.md` — and most of that file is about what *not* to
flag, so the reviewer does not fight the repository's own design.

## What the rule changes mean in practice

- **No-stamp** — `law/GOVERNANCE.md` §10. No agent writes `SEALED` or any approval marker.
  `verify.sh` check 6 enforces it. Only David seals, in his own words.
- **Bots-first removed** — `law/GOVERNANCE.md` §11, `state/DECISIONS.md` D-003. No CI, no workflow,
  no bot in any gate. Local review is a tool Carmen may run, never a condition.
- **Carmen-Cursor rule removed** — nothing inherited. `state/DECISIONS.md` D-001. Those repos are
  untouched.

## What is honestly not done

**Nothing here has been run against a live Cursor instance.** Everything is built from documented
behavior, and Cursor's documentation demonstrably lags its product — three removed features still
had live docs pages during this research. That is `state/RISKS.md` R-001, and the first Cursor
session closes it.

**The hooks are unexercised.** Written, syntax-checked, executable — but never fired. Cursor staff
have called project hooks experimental, `beforeShellExecution` may need "Run Everything" enabled,
and hooks are fail-open by default. R-002 and R-003. Test them by asking Carmen to run
`git reset --hard`; it should be blocked.

**No project code.** The lanes are conventions with no codebase under them yet.

## Four questions for David

1. **Does the harness live here, or get copied into project repos?** Both work; the globbed rules
   match on file extension, not location. `docs/ARCHITECTURE.md` §7 lays out the trade-off.
2. **Do the hooks stay on** after you have watched them fire?
3. **Naming.** The repo is `Carmen`. The harness inside it has no formal name — you said hold off.
4. **Anything in here that does not sound like Carmen?** The soul was written fresh from the
   sealed source, not copied. If a line is off, it is an amendment, and it is yours to make.

---

*Turtle pace. Nothing here is sealed. Standing by for GO.*
