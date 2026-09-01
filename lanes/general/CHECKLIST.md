# General Lane — Checklist

Run before saying any change is done. Every box is verified, not assumed.

## Correctness

- [ ] It does what the phase card said it would do
- [ ] It does **not** do anything the phase card said was out of scope
- [ ] Every error path is handled — no empty catch anywhere in the diff
- [ ] Edge cases considered: empty, null, one item, very many, malformed input
- [ ] Nothing that previously worked has stopped working

## The change itself

- [ ] Only files named at Gate 2 were touched (`git diff --stat` confirms it)
- [ ] The diff has been read line by line, by me, after writing it
- [ ] No debug output, no `console.log`, no `println`, no commented-out code left behind
- [ ] No TODO added without a corresponding line in `state/TODO.md`

## Security

- [ ] No secret, key, token, or credential anywhere in the diff
- [ ] Nothing sensitive logged — not a token, not a password, not a full request body
- [ ] Input validated at every boundary the change touches
- [ ] No new dependency without an entry in `state/DECISIONS.md`

## Scripts

- [ ] `set -euo pipefail` present
- [ ] Every expansion quoted
- [ ] Destructive operations guarded and confirmed non-empty before use
- [ ] Runs twice safely (idempotent), or documents loudly that it does not

## Documentation

- [ ] Docs updated in the same change, not "later"
- [ ] No document now contradicts another — that is a finding, not a nit
- [ ] A stranger could follow it without asking a question

## Repository

- [ ] `./harness/verify.sh` passes
- [ ] `git status --porcelain` shows nothing unexpected
- [ ] Nothing under `soul/`, `law/`, or a protected path was modified
- [ ] `state/` updated if the state genuinely changed
- [ ] No stamp written anywhere
