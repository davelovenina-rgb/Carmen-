# THE SIX-POSTURE AUDIT STANDARD

Permanent law. Applies at Gate 4 to every modified and new file, every time.

**The discovery it came from:** an audit chain was running partial postures across several
platforms. Stacking platforms produced coverage by *accident*, not by design. The fix was never
more platforms — it was one auditor running every posture, every time, with no scope-narrowing.

> *"Absolutely if needs to audit however amount of time shouldn't be a question."* — David

Time is never the constraint.

---

## Posture 1 — STRUCTURAL

*Does the shape of the change match what was claimed?*

File counts, line counts, hashes. Every file in "Files Touched" actually touched. Every file in
"Files NOT Touched" actually untouched — verified, not assumed. Workspace integrity: no foreign
artifacts, no stray files, no leftovers from another project. Every claim in the delivery note
checked against the source.

Tools: `git diff --stat`, `git status`, `find`, `wc -l`, `md5sum`, `grep`.

## Posture 2 — BEHAVIORAL

*Does it actually work, on every path?*

Trace every new execution path end to end. Examine every catch block — an empty catch
(`catch (_: Exception) {}`, `catch {}`) is a red flag, always. Verify idempotency on anything that
mutates state. Check cross-store contracts for partial-state failure. If a signature changed,
confirm **every** call site was updated — not most of them.

## Posture 3 — ADVERSARIAL

*Read it cold, as claims to be disproven.*

No carryover trust from a prior pass on unchanged files. Every statement in the delivery brief is
an **assertion to verify**, not a fact. A prior auditor's PASS is a claim, not permission to ship.

> **The cleaner the report, the harder you read.**

## Posture 4 — WHOLE-APP SECURITY

*Not scoped to the current change.*

Secrets, keys, tokens, credentials — not in source, not in logs, not in commits, not in context.
Encryption intact. No sensitive data in plaintext storage. Dependency and supply-chain sanity.
Input validated at every boundary. Debug/dev affordances not shipping to production.

At least first-pass depth on **every** audit, even a small one.

## Posture 5 — FUTURE-READER

*Read the docs as a stranger.*

Read every governance and README change as a brand-new Carmen who has never seen this project —
and as David, alone, five years from now, trying to remember what was built and why.

Looking for: drift between docs and source, anything a fresh instance would misread, anything
that only makes sense if you were in the room. Changelogs are legacy, not paperwork.

## Posture 6 — SYNTHESIS

*Connect it across time.*

Check new findings against known-deferred items. Has a deferred item gotten worse? Escalate. Does
a new finding duplicate a known-deferred one? Note it and move on — do not re-flag. Look for
amplifications, evolutions, and contradictions between this pass and the last one.

---

## Four principles governing how every posture is executed

1. **Claims vs. Truth.** The brief is a claim. The prior PASS is a claim. Verify against source.
2. **Read the diff, not the file.** Read changed lines plus ~20 lines around them, and ask what
   the change *assumed* about the code it did not read.
3. **Beyond the tooling.** Automated tools catch syntax. They do not catch context drift or
   governance contradiction. That is why a human-shaped pass exists.
4. **For David.** Read changelogs as legacy, not as paperwork.

---

## Full vs partial

| Label | Requirement |
|---|---|
| **Full audit** | All six postures, every modified and new file, no scope-narrowing. |
| **Partial audit** | Any posture skipped or any file excluded. **Must be labeled "partial."** |

Language drift is a finding. If it is partial, say partial.

## Severity

| Severity | Meaning |
|---|---|
| **Blocker** | Cannot proceed. Back to G3. |
| **Warning** | Should fix. Does not block. |
| **Note** | Informational. No action required. |

## What is not a finding

- A deliberate, documented decision recorded in `state/DECISIONS.md`
- A known-deferred item already on the roster, unchanged in severity
- A style preference with no correctness, security, or clarity consequence
- Anything David has explicitly authorized as acceptable for this project
