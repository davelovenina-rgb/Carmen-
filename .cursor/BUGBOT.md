# BUGBOT.md — Review Instructions

Read by Cursor's review agents (`/review-bugbot`, `/agent-review`, and Bugbot on a PR if it is
ever connected).

**This file exists because `.cursor/rules/*.mdc` do NOT apply to Bugbot.** Cursor's docs state
that plainly. Rules steer the coding agent; this file steers the reviewer. They are separate
systems, so the guidance has to be written twice.

**Review here is a tool, never a gate.** This repository has no bots-first rule
(`law/GOVERNANCE.md` §11). Findings are input to David, not a merge condition.

---

## Severity language

Use exactly these three, matching `law/AUDIT_SIX_POSTURE.md`:

- **Blocker** — cannot proceed; correctness, security, or data loss
- **Warning** — should fix; does not block
- **Note** — informational

## Flag as Blocker, always

- Any secret, key, token, credential, keystore, or `.env` content in a diff — no exceptions
- `fallbackToDestructiveMigration()` or any migration path that can delete user data
- An empty catch block: `catch {}`, `catch (_: Exception) {}`, `except: pass`
- `catch (Throwable)` in Kotlin — it swallows `CancellationException` and breaks cancellation
- `!!` in Kotlin, or a non-null assertion added purely to silence the compiler
- `GlobalScope` in Kotlin
- A signature change where a call site was missed
- A `<div onClick>` or any interactive element that a keyboard cannot reach
- `any` introduced in TypeScript, or a `@ts-ignore` without an explanation
- A new dependency added without a note in `state/DECISIONS.md`
- Anything under `soul/` or `law/` modified without an amendment marker and a decision entry
- A `SEALED` or approval stamp written by an agent — this repository does not stamp

## Flag as Warning

- Navigation or a one-time effect carried in `StateFlow` state rather than a `Channel`
- A composable calling a ViewModel from inside `Screen` instead of `Root`
- A missing `modifier: Modifier = Modifier` parameter on a public composable
- Async state modelled as parallel booleans instead of a discriminated union
- A `useEffect` deriving state that could be computed during render
- A missing loading, error, **or empty** state
- A test that asserts on implementation detail rather than user-visible behavior
- A governance document that now contradicts another one

## Do not flag

- Warmth, Spanish, or personality in `soul/`, `law/`, `state/`, or documentation. That is the
  repository working as designed, not a style problem.
- Long governance files. `law/AMENDMENTS.md` requires superseded text to be kept — length is the
  cost of auditability, and condensing these files is itself a violation.
- Anything recorded as a deliberate decision in `state/DECISIONS.md`.
- Anything already open in `state/RISKS.md` at the same severity. Note it, do not re-raise it.
- Missing CI configuration. There is deliberately none (`state/DECISIONS.md` D-003).
- The absence of nested `AGENTS.md` files. That is deliberate (D-004) and has a documented reason.

## Tone

Direct and specific. Cite the file and the line. State what is wrong and what it would cost —
not what a general best practice says. If nothing is wrong, say the review was clean; do not
manufacture findings to look thorough.
