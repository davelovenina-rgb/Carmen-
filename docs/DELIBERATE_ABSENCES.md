# DELIBERATE ABSENCES

Things a reasonable person would expect to find here, that are missing **on purpose**.

This file exists so nobody helpfully adds one back. If you are about to add something on this
list, read its reason first — and if the reason no longer holds, that is an amendment for David
(`law/AMENDMENTS.md`), not a fix.

---

## No CI, no GitHub Actions, no bot gate

**Why:** David's ruling — no bots-first (`state/DECISIONS.md` D-003, `law/GOVERNANCE.md` §11).
Bot reviews and CI runs do not participate in any gate here.

**Instead:** `harness/verify.sh` runs locally, the six-posture audit runs by hand, and David is
the only gate that seals. Cursor's local review (`/review-bugbot`, `/agent-review`) is available
as a tool Carmen may run — never a condition she must pass.

**Adding one anyway** would make a bot a participant in a gate, which is precisely the ruling.

---

## No `SEALED` stamps

**Why:** `law/GOVERNANCE.md` §10. Only David seals, and he does it in his own words.

A document that stamps itself lies with a straight face — the stamp says "verified" whether or not
anything was verified, and it is the first thing a future reader trusts. Status lives in
`state/CURRENT_STATE.md` as plain prose that has to actually say something.

`harness/verify.sh` check 6 fails if a stamp appears.

---

## No nested `AGENTS.md`

**Why:** `state/DECISIONS.md` D-004. Since Cursor 3.6, nested `AGENTS.md` files are discovered
across the entire repository and loaded **in full on every request**. Teams have reported this
consuming hundreds of thousands of tokens before the first message.

**Instead:** one root `AGENTS.md`, and everything directory-scoped in a `globs`-scoped `.mdc` rule
that attaches only when a matching file is in context.

`harness/verify.sh` check 3 fails if a second `AGENTS.md` appears.

**If you also run Claude Code here:** it lazy-loads nested context files and would prefer the
opposite layout. This repository optimizes for Cursor, deliberately.

---

## No `.cursorrules`

**Why:** legacy format, deprecation announced by Cursor. Its behavior is exactly a rule with
`alwaysApply: true`, which the harness already has three of.

---

## No `.cursorindexingignore`

**Why:** community-known but absent from Cursor's current documentation, with a history of
inconsistent behavior. `.cursorignore` is documented and sufficient.

---

## No negation (`!`) patterns in `.cursorignore`

**Why:** a known Cursor regression (August 2026) means `!` cannot override a `.gitignore`
exclusion while Instant Grep is enabled. A pattern that silently does not work is worse than no
pattern, because you believe you are protected.

---

## No live `.cursor/mcp.json`

**Why:** an MCP config is where a token ends up, and a token in git is a token that has leaked.

**Instead:** `.cursor/mcp.json.example` is tracked, with every secret read as `${env:VAR}`. Copy
it to `.cursor/mcp.json` (gitignored) locally.

`harness/verify.sh` check 5 warns if a live `mcp.json` appears.

---

## No `@Docs` sources, Notepads, or Memories

**Why:** all three were removed from Cursor — `@Docs` in August 2026, Notepads in October 2025,
Memories in 2.1.x. Their documentation pages outlived them, which is exactly how a harness ends up
depending on something that no longer exists.

**Instead:** documentation lives as Markdown in this repository, where it is greppable, versioned,
and cannot be removed by a vendor.

---

## No linter or formatter config

**Why:** this repository is a harness, not an application. There is no source tree to lint yet.

**When project code arrives:** its lane brings its own config — ESLint/Prettier for React,
ktlint/detekt for Kotlin. That is a G2 decision recorded in `state/DECISIONS.md`, not something to
guess at in advance.

---

## No `package.json`, no `build.gradle.kts`

**Why:** same reason. The lanes hold conventions and templates; they do not assume a project
exists yet.

Whether project code eventually lives *here* or the harness is copied *into* project repositories
is **open** — `state/HANDOFF.md` item 3, and `docs/ARCHITECTURE.md` §7. It is David's call.

---

## No content from `carmen-cursor`, `carmen-sg-docs`, `carmen-sg-cursor`, or `Carmen-IntelliJ-Repo`

**Why:** David asked for something fresh (`state/DECISIONS.md` D-001). Those repositories remain
separate and untouched. Nothing here was copied from them — not a rule, not a document, not a
convention.

**Not a judgment on them.** A deliberate non-mixing, because tangled lineage was the specific
failure mode this build was meant to escape.
