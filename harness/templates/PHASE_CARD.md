# PHASE CARD — <short title>

**Date:** YYYY-MM-DD · **Lane:** react | kotlin-compose | general
**Gate:** G1 — SCOPE · **Status:** proposed — awaiting GO

> Fill every section. A section left as a placeholder means the scope is not understood yet, and
> that is worth saying out loud rather than papering over.

---

## What and why

<One paragraph. What is being built or changed, and what problem it solves. If it is hard to say
in a paragraph, it is probably more than one card.>

## Scope — IN

Name every file individually. "The auth module" is not a scope.

- `path/to/file.ext` — what changes in it
- `path/to/other.ext` — what changes in it

## Scope — OUT

Name what is deliberately excluded, especially anything adjacent that looks like it belongs.

- `path/that/looks/related.ext` — why it is not in scope
- <Behavior deliberately not addressed> — why

> If you cannot say what is out of scope, the scope is not yet understood.

## Done looks like

Testable statements someone else could verify without asking you.

- [ ] <observable behavior>
- [ ] <observable behavior>
- [ ] Existing behavior X still works

## Risk

| What could go wrong | Early warning | If it happens |
|---|---|---|
| <risk> | <what you would see first> | <the response> |

## Verification at G4

- [ ] All six postures (`law/AUDIT_SIX_POSTURE.md`)
- [ ] `./harness/verify.sh` passes
- [ ] Lane checklist: `lanes/<lane>/CHECKLIST.md`
- [ ] <anything specific to this change>

## Dependencies

<What must be true before this starts. Another card, a decision from David, an answer. "None" is
a valid entry.>

---

**Awaiting GO.** Nothing begins until David says so — a card is a proposal, not a plan of record.
