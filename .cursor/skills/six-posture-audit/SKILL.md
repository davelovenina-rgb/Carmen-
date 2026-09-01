---
name: six-posture-audit
description: Run a full six-posture audit at Gate 4 — structural, behavioral, adversarial, whole-app security, future-reader, and synthesis. Use when reviewing a change before handing it to David, verifying someone else's work, or when asked to audit, review, or check a diff.
---

# Six-Posture Audit

Permanent law: `law/AUDIT_SIX_POSTURE.md`. All six postures, every modified and new file, no
scope-narrowing. **Time is never the constraint.**

This standard exists because an audit chain was once running partial postures across several
platforms — coverage by accident, not by design. The fix was never more platforms. It was one
auditor running every posture, every time.

## Procedure

### 0 — Establish the ground truth first

```bash
git status --porcelain          # what is actually dirty
git diff --stat                 # what actually changed, and by how much
git diff                        # read it, all of it
cat .cursor/audit.log           # the independent record of what the agent touched
```

Compare the delivery note's "Files Touched" against `git diff --stat`. **A discrepancy here is
the finding**, before you have read a single line of logic.

### 1 — STRUCTURAL
Every claimed-touched file actually touched. Every claimed-untouched file actually untouched —
verified, not assumed. Line counts within expectation. Workspace integrity: no stray files, no
artifacts from another project. Every factual claim checked against source.

### 2 — BEHAVIORAL
Trace every new execution path end to end. Every catch block examined — an empty catch is a red
flag in every language. Idempotency on state mutation. Cross-store contracts checked for
partial-state failure. Signature changed → **every** call site confirmed, not most.

### 3 — ADVERSARIAL
Read cold, as claims to be disproven. No carryover trust on unchanged files. Every statement in
the brief is an assertion to verify. A prior PASS is a claim, not permission to ship.
**The cleaner the report, the harder you read.**

### 4 — WHOLE-APP SECURITY
Not scoped to the delta, on every audit, however small. Secrets not in source, logs, commits, or
context. Encryption intact. No sensitive data in plaintext storage. Input validated at every
boundary. No debug affordance shipping to production. Dependency sanity.

### 5 — FUTURE-READER
Read every documentation change twice: once as a fresh Carmen who has never seen this project,
once as David alone in five years. Drift between docs and source. Anything that only makes sense
if you were in the room. Changelogs are legacy, not paperwork.

### 6 — SYNTHESIS
Check findings against `state/RISKS.md` and `state/TODO.md`. A deferred item that has gotten worse
→ escalate. A new finding duplicating a known-deferred one → note it and move on, do not re-flag.

## Four principles governing every posture

1. **Claims vs. truth.** The brief is a claim. The prior PASS is a claim. Verify against source.
2. **Read the diff, not the file.** Changed lines plus ~20 around them — then ask what the change
   *assumed* about the code it did not read.
3. **Beyond the tooling.** Tools catch syntax. They do not catch context drift or governance
   contradiction.
4. **For David.** Read changelogs as legacy, not paperwork.

## Output

Use `harness/templates/AUDIT_REPORT.md`. Every finding: severity, file, line, what is wrong, what
it would cost.

| Severity | Meaning |
|---|---|
| **Blocker** | Cannot proceed. Back to G3. |
| **Warning** | Should fix. Does not block. |
| **Note** | Informational. |

## Label honestly

- Any posture skipped or file excluded → **PARTIAL audit**, and say so.
- Audited your own work → **"self-audit — not independent."**

**Language drift is itself a finding.** Calling four-of-six a "full audit" is the exact gap this
standard exists to close. And a clean audit is a real result — never invent findings to look
thorough.
