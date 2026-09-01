# General Lane — Conventions

For work with no language-specific lane: shell scripts, tooling, configuration, data files,
documentation, CI, and anything one-off.

Cursor rules: `200-general-code.mdc`, `210-shell-and-scripts.mdc`, `220-markdown-docs.mdc`.

---

## Change safety

- **Touch only what the task requires.** A drive-by fix in an unrelated file is scope creep even
  when it is correct. Note it, finish the task, raise it separately.
- **Read the call path before changing a link in it.**
- **Prefer additive over destructive.** A new function beside the old one, then a switchover,
  beats editing something twelve callers depend on.
- **Leave the tree buildable.** Every commit compiles and every test runs.

## Errors

Never swallow an error silently. An empty catch — `catch {}`, `except: pass`,
`if err != nil { }` — is a finding in every language.

Handle errors at the boundary that can actually do something about them. Error messages say what
failed, what was expected, and what to try next. Fail loudly in development, degrade gracefully in
production.

## Naming

Names say what a thing **is** or **does**, not how it was implemented. No abbreviations beyond
genuinely universal ones. Booleans read as assertions: `isReady`, `hasAccess`, `canRetry`.

Consistency inside a codebase beats correctness in the abstract — match what is already there,
and raise the inconsistency separately if it matters.

## Configuration

- Configuration comes from the environment, never from a committed file.
- Ship a `.env.example` with every key present and every value empty or fake.
- Validate configuration at startup and fail immediately with a message naming the missing key.
  A service that starts healthy and fails on the first request is much harder to debug.
- Defaults are safe defaults. If a setting can be dangerous, the default is off.

## Scripts

Every bash script opens with:

```bash
#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
```

Quote every expansion. Guard every destructive path. Check that a command exists before using it.
Errors and diagnostics to stderr; stdout is for output a caller may parse.

## Data files

- JSON and YAML get schema validation where one exists.
- CSV: header row always, quoting rules stated, encoding declared.
- Never commit a data file containing real personal data. Never.
- A large generated file belongs in `.gitignore`, with the generator committed instead.

## Dependencies

Prefer the standard library. Before adding a dependency: is it maintained, what does it pull in,
what happens when it is abandoned? Adding one is a **G2 design decision**, recorded in
`state/DECISIONS.md` — not a build detail.

## Comments

Comment **why**, never what. A comment explaining a workaround names what it works around. Delete
commented-out code — git remembers it, the file should not.
