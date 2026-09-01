# DECISION — <short title>

Append to `state/DECISIONS.md`. **Never edit or delete an existing entry.** A reversed decision
gets a *new* entry that references the old ID.

---

```markdown
## D-0NN — <short title>
**Date:** YYYY-MM-DD · **By:** <David | Carmen (research-driven) | Carmen, ratified by David>

<What was decided, in one or two sentences. Plain and specific.>

*Why:* <The reasoning. What alternative lost, and what that alternative would have cost. If it
came from research, cite the source.>
```

---

## What belongs here

Anything a future reader would otherwise look at and ask *"why is it like this?"*

- An architecture or convention choice
- A deliberate omission — something absent on purpose
- A trade-off where the losing option was reasonable
- A ruling from David that shapes how work is done

## What does not

- An implementation detail visible in the code itself
- A temporary workaround — that is a risk (`state/RISKS.md`) or a task (`state/TODO.md`)
- A preference nobody would question

## Why the reasoning matters more than the outcome

A decision recorded without its reasoning gets undone by someone who was not in the room. They
see a constraint with no visible justification, remove it, and rediscover the original problem
the expensive way.

A decision recorded here is **not a finding** at audit. That is precisely the point of writing
it down.
