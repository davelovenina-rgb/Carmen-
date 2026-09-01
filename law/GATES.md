# GATES — The Five Gates

Every unit of work in this repository passes the same five gates, in order. A gate is not
paperwork; it is the place where a specific class of mistake gets caught.

Nothing skips a gate. A gate that is skipped is named and declared, never quietly passed.

---

```
  ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐
  │ G1      │──▶│ G2      │──▶│ G3      │──▶│ G4      │──▶│ G5      │
  │ SCOPE   │   │ DESIGN  │   │ BUILD   │   │ AUDIT   │   │ DAVID   │
  └─────────┘   └─────────┘   └─────────┘   └─────────┘   └─────────┘
   what & why    how, before    the change    six postures   the only
   in / out      any code       only          cold           seal
       │             │              │              │             │
     GO required   GO required   GO required   no GO needed   David alone
```

---

## G1 — SCOPE

**Output:** a phase card (`harness/templates/PHASE_CARD.md`).

- What is in scope, stated as files and behaviors.
- What is explicitly **out** of scope.
- What "done" looks like, in testable terms.
- What could go wrong, and what would be the early warning.

**Gate condition:** David reads the card and says GO. No card, no work.

## G2 — DESIGN

**Output:** the approach, in prose, with exact file paths and the shape of each change.

- Every file that will be touched, named.
- Every file that will **not** be touched but might look like it should be, named — with why.
- The call path traced end to end. Trace the wires before you cut one.
- Alternatives considered and why they lost. One paragraph is enough.

**Gate condition:** David says GO on the approach. Design GO is not build GO for a different design.

## G3 — BUILD

**Output:** the change.

- Only files named in G2. A file that needs touching and was not named at G2 sends the work back
  to G2 — it does not get quietly added.
- Small commits, each one coherent on its own.
- The build compiles / the tests run **before** it is handed on. A change that does not build is
  not a delivery; it is a work in progress.

**Gate condition:** it builds, it runs, and Carmen has re-read her own diff.

## G4 — AUDIT

**Output:** an audit report (`harness/templates/AUDIT_REPORT.md`) with findings by severity.

All six postures, every modified and new file, no scope-narrowing. See `law/AUDIT_SIX_POSTURE.md`.

- **Blocker** — cannot proceed. Must be fixed.
- **Warning** — should be fixed; does not block.
- **Note** — informational.

**Separation of duties:** whoever built it does not own this gate (`GOVERNANCE.md` §6). A builder's
self-check is a self-check. If a cold seat is not available, the audit is labeled
**self-audit — not independent**, in writing. Never call it a full independent audit when it isn't.

**Full vs partial:** all six postures on every touched file, or it is a **partial** audit and says
so. Calling four-of-six a "full audit" is exactly the drift the standard exists to prevent.
**Language drift is itself a finding.**

## G5 — DAVID

**Output:** David's word.

He reads, he asks, he approves — or he doesn't. Carmen never merges, never seals, never marks a
thing done on his behalf, and never assumes silence is approval.

This gate has no shortcut and no delegate.

---

## Escalation

Any of these sends work backward through the gates immediately, no debate:

- A file outside scope needed changing → back to **G2**
- The change does not build → back to **G3**
- A **Blocker** finding → back to **G3**
- David raises a flag → **stop everything**, investigate, then re-enter at the right gate
- Something unexpected appears → **stop**, report, wait
