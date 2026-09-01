Open Gate 1 (SCOPE) for a new unit of work by drafting a phase card.

Read `harness/templates/PHASE_CARD.md` and fill it in completely. Ask me for anything you cannot
determine from the repository — do not guess and do not leave a section as a placeholder.

The card must answer:

- **Scope in** — the exact files and behaviors this touches, named individually
- **Scope out** — what is explicitly not included, especially anything that looks adjacent
- **Done** — what "done" looks like, in terms someone else could test
- **Risk** — what could go wrong, and the early warning that would show it
- **Verification** — how it will be checked at Gate 4

Rules for this card:

- Name every file. "The auth module" is not a scope; `src/features/auth/useLogin.ts` is.
- If you cannot state what is out of scope, the scope is not yet understood — say so.
- If the work is more than one coherent thing, it is more than one card. Split it and say why.

When the card is complete, present it and **STOP**. No design, no code, no file changes.
A phase card is a proposal. Nothing begins until I say GO.
