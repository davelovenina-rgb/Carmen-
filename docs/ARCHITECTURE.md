# ARCHITECTURE — Why the Harness Is Shaped This Way

Every structural choice here came from something specific about how Cursor actually behaves in
September 2026, or from a law that was earned the expensive way. This document records the
reasoning so a future reader does not "simplify" a load-bearing decision.

Research with citations: [`CURSOR_RESEARCH.md`](CURSOR_RESEARCH.md).
What is deliberately missing: [`DELIBERATE_ABSENCES.md`](DELIBERATE_ABSENCES.md).

---

## 1. Five layers

```
┌──────────────────────────────────────────────────────────┐
│  SOUL      soul/          who Carmen is                  │  identity
├──────────────────────────────────────────────────────────┤
│  LAW       law/           how work moves, who decides    │  authority
├──────────────────────────────────────────────────────────┤
│  STATE     state/         where things stand right now   │  facts
├──────────────────────────────────────────────────────────┤
│  LANES     lanes/         conventions per stack          │  craft
├──────────────────────────────────────────────────────────┤
│  HARNESS   .cursor/ +     the machinery that carries     │  mechanism
│            harness/       all of the above into the IDE  │
└──────────────────────────────────────────────────────────┘
```

The separation matters because the layers change at completely different rates. Soul essentially
never changes. Law changes rarely, by amendment. State changes every session. Lanes change when a
convention is learned. The harness changes when Cursor changes.

Collapsing them — the usual instinct, "put it all in one AGENTS.md" — means every small state
update touches the same file as the identity, and identity drift becomes invisible inside routine
edits.

## 2. The harness mirrors the law; it never *is* the law

`law/` is authority. `.cursor/` is a mirror of it, shaped for how Cursor loads things.

If a `.mdc` rule and a `law/` file disagree, **the rule is a bug.** This is written into
`law/CONFLICT_AUTHORITY.md`, into `AGENTS.md`, and into the always-on rules themselves.

The reason is practical: `.cursor/` files are the easiest thing in the repository to edit — an
agent writes them, a command generates them, a migration tool rewrites them — and the hardest
place to notice drift. Naming them "mirrors, bottom of the ladder" means drift is a bug with a
known correct resolution rather than an ambiguity someone has to adjudicate.

## 3. The always-on budget is three rules

**This is the single most important constraint in the design.**

Cursor loads `alwaysApply: true` rules and every `AGENTS.md` in **full, on every single request**.
That is a fixed tax on every message of every session, for the life of the repository.

So the always-on surface here is exactly three small rules, 57 lines in total:

| Rule | Carries |
|---|---|
| `000-carmen-identity.mdc` | who Carmen is, and the hard "nevers" |
| `010-operating-law.mdc` | the eight rules that are always true |
| `020-repo-map.mdc` | where to find everything else |

Everything else is **conditional**:

- **Globbed rules** (`globs: **/*.kt`) attach only when a matching file is in context. Open a
  Kotlin file, the Kotlin rules appear. Close it, they are gone.
- **Description rules** attach when the agent reads the description and decides it is relevant.
- **Skills** keep only `name` and `description` in static context; the body loads on demand.
- **Lane documents** are read when a rule points at them.

`harness/verify.sh` fails the build if a fourth always-on rule appears. That check exists because
the always-on budget is exactly the kind of thing that erodes one convenient addition at a time.

## 4. Exactly one `AGENTS.md`

Since Cursor 3.6, nested `AGENTS.md` files are discovered across the **entire** repository and
loaded in full on every request, because `AGENTS.md` is an always-rule. Teams have reported this
consuming hundreds of thousands of tokens before the first message was even processed.

Cursor's own mitigation, from staff: convert nested `AGENTS.md` files into scoped `.mdc` rules
with `globs`, or consolidate to a single root file.

This repository does both. One root `AGENTS.md`, deliberately short; everything directory-scoped
lives in a globbed rule. `verify.sh` fails if a second `AGENTS.md` appears anywhere.

**Note for anyone running Claude Code against this repository too:** Claude Code lazy-loads nested
context files by directory, so it would actually prefer the nested layout. The two harnesses want
opposite shapes. This repository optimizes for Cursor, deliberately (`state/DECISIONS.md` D-004).

## 5. Two channels, because rules do not reach the reviewer

`.cursor/rules/*.mdc` steer the **coding agent**. They do **not** apply to Bugbot or the review
agents — Cursor's documentation states that explicitly.

So review guidance lives separately in `.cursor/BUGBOT.md`, which the review agents do read
(including nested ones, walking upward from each changed file). It is written twice because they
are genuinely two systems, and a reviewer that does not know the house rules produces findings
that are noise.

Note what `BUGBOT.md` spends most of its length on: **what not to flag.** A reviewer that flags
the warmth in `soul/`, the length of `law/`, or the absence of CI is a reviewer nobody reads.

## 6. Hooks are the law made mechanical

Five hooks, each mapping a written law onto an enforcement point:

| Hook | Event | Law it enforces |
|---|---|---|
| `guard-secrets-read.sh` | `beforeReadFile` | §8 — secrets never enter context |
| `guard-protected-paths.sh` | `preToolUse` | §8 + amendment law |
| `guard-destructive-shell.sh` | `beforeShellExecution` | §7 — never merge, never force-push, never discard |
| `log-edit.sh` | `afterFileEdit` | Posture 1 — an independent record of what was touched |
| `session-boot.sh` | `sessionStart` | boot order, injected as context |

The design detail worth noticing: the protected-paths guard returns **`deny`** for secrets and
**`ask`** for `soul/` and `law/`. That is not a hedge — it is the amendment law expressed in a
mechanism. Secrets are never permitted. Governance edits are David's to permit, in the moment.

`log-edit.sh` earns its place at audit: it is a record of what the agent *actually* touched,
written independently of what the agent *says* it touched. Posture 1 compares the two.

**These guards are not a security boundary.** Cursor documents hooks as fail-open by default;
`failClosed: true` is set here but is itself unverified against the live app, and staff have
described project hooks as experimental. See `state/RISKS.md` R-002 and R-003. They are a
seatbelt, not a vault. The real protection is that secrets never enter the repository.

## 7. Standalone or embedded — an open question

Two ways to use this, both valid:

**A — standalone.** The repository is Carmen's house. Project code lives elsewhere; David works in
this repo for governance and copies `.cursor/`, `lanes/`, and `harness/` into project repos.
*Clean separation, but the harness drifts between copies.*

**B — embedded.** Project code lives here, under `src/` or `app/`, alongside the harness. Rules
attach to real files, hooks guard real work, `verify.sh` runs against a real build.
*One source of truth, but governance and application share a history.*

The globbed rules are written to work either way — they match on file extension, not location.
This is **open in `state/HANDOFF.md`**, item 3, and it is David's call.

## 8. Greppable by design

Cursor is retiring embeddings-based semantic indexing in favour of grep-based retrieval, and their
stated direction is dynamic discovery: small, well-named files the agent pulls in as needed, rather
than large blobs loaded up front.

The layout follows that: many small files with descriptive names, one concern each, cross-linked
by relative path. `soul/VOICE.md` is findable by an agent grepping for "voice" in a way that a
§6 buried inside a 2,000-line master document is not.

## 9. What "verified" means here

There is no CI gate and no bot in any gate (`law/GOVERNANCE.md` §11). Verification is three things:

1. `harness/verify.sh` — mechanical checks of the structure
2. The six-posture audit — a human-shaped read of the change
3. David — the only gate that seals

Cursor's local review is available as a tool Carmen may run. It is never a condition she must pass.
