# AUDIT REPORT — <phase card title>

**Date:** YYYY-MM-DD · **Gate:** G4
**Auditor:** <who> · **Builder:** <who>
**Type:** FULL | **PARTIAL** | **SELF-AUDIT — NOT INDEPENDENT**

> Label honestly. Any posture skipped or any file excluded → **PARTIAL**. Audited your own work →
> **self-audit**. Calling four-of-six a "full audit" is itself a finding — it is the exact drift
> the standard exists to prevent.

---

## Verdict

**PASS** | **FAIL** — <one sentence>

| Severity | Count |
|---|---|
| Blocker | 0 |
| Warning | 0 |
| Note | 0 |

A Blocker sends the work back to G3. Warnings and Notes do not block.

## Ground truth

```
$ git diff --stat
<paste the real output>

$ git status --porcelain
<paste the real output>
```

**Files claimed touched vs actually touched:** <match | discrepancy — and a discrepancy here is
the finding, before a single line of logic has been read>

**Files claimed untouched — verified untouched:** <how you verified, not that you assumed>

---

## Postures

### 1 — STRUCTURAL
<Counts, hashes, workspace integrity, claims checked against source.>

### 2 — BEHAVIORAL
<Execution paths traced. Catch blocks examined. Idempotency. Every call site of any changed
signature.>

### 3 — ADVERSARIAL
<Read cold. Claims retested. The cleaner it looked, the harder you read.>

### 4 — WHOLE-APP SECURITY
<Secrets, logging, encryption, input validation, debug affordances. Not scoped to the delta.>

### 5 — FUTURE-READER
<Docs read as a stranger and as David in five years. Drift between docs and source.>

### 6 — SYNTHESIS
<Checked against `state/RISKS.md` and `state/TODO.md`. Escalations. Duplicates noted, not
re-flagged.>

---

## Findings

### F-1 — <title>
**Severity:** Blocker | Warning | Note
**File:** `path/to/file.ext:LINE`

**What is wrong:** <specific>

**What it costs:** <the concrete consequence — the crash, the leak, the lost data, the
misunderstanding. Not "this is bad practice.">

**Evidence:**
```
<the actual code, command output, or diff>
```

**Suggested fix:** <or "defer to builder">

---

## Not findings

<Things noticed and deliberately not raised, with why — a decision recorded in
`state/DECISIONS.md`, an item already open in `state/RISKS.md` at the same severity, or a style
preference with no correctness consequence.>

---

**Handed to:** David | back to G3
