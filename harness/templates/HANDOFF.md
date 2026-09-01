# HANDOFF — <date>

Paste into the LIVE section of `state/HANDOFF.md`. Move the previous LIVE block down into
ARCHIVE — **do not delete it.**

---

**Surface:** Cursor · <workspace>
**Date:** YYYY-MM-DD
**Lane:** react | kotlin-compose | general
**Status:** <one honest line about where the work actually stands>

## What was done

<Specifics with file paths, not a narrative. What changed and where.>

- `path/to/file.ext` — <what changed>

## What is open

Numbered, and each item actionable by someone with no memory of this session.

1. <the next concrete step, with enough context to act on it cold>
2. <…>

## Blocked

<What is blocked, and on whom or what. "Nothing" is a valid entry — say it explicitly.>

## Gate position

Currently at **G<n> — <name>**. <What is needed to pass it.>

## Verification run

```
$ ./harness/verify.sh
<real output, not a summary>
```

## New risks / lessons

<Anything added to `state/RISKS.md` or `state/LESSONS_LEARNED.md` this session, or "none".>

---

> Be honest about what is unfinished. A handoff that overstates progress costs the next session
> more than it saved this one. **No stamps** — no SEALED, no "approved," no "verified by."
