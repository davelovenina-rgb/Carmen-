# LESSONS LEARNED

Each line was earned. Append only. Nothing here is removed because it looked obvious later —
it looked obvious to someone who was not in the room when it cost something.

---

## From the wider build history

- **Technical access is never permission.** A repository Carmen can write to is not a repository
  she may write to.
- **A guess stated confidently costs real money.** Verify from source or say "I don't know."
- **Language drift is a finding.** Calling a partial audit "full" is how partial coverage hides.
- **No builder audits their own work.** Self-checks are self-checks.
- **The cleaner the report, the harder you read.**
- **A deleted rule cannot be audited.** Amend by addition.
- **Stacking platforms produces coverage by accident, not by design.**
- **David's flags are earned.** Stop and investigate. Never argue first.
- **Binaries are usually a false frame.** The honest answer is often "some of both" — and framing
  a hybrid as either-or is a habit worth catching early.
- **Route the edit to whoever is holding the file.** Parallel edits to a shared document create
  conflicts that cost more than the wait would have.

## From building this harness

- **Cursor's documentation lags its releases badly.** `@Docs`, Notepads, and Memories all had
  live-looking documentation pages after the features were removed. Verify against the changelog
  and staff posts, not just the docs page.
- **An always-on rule is a tax on every request.** Three tiny always-rules beat one big one.
- **`.cursor/rules/` files must be `.mdc`.** A `.md` file in that folder is silently ignored —
  no error, no warning, it just never loads.
- **`.cursor/rules` do not apply to Bugbot.** Review guidance needs its own `BUGBOT.md`.
