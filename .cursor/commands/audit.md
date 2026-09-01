Run Gate 4 — a six-posture audit on the current change.

Read `law/AUDIT_SIX_POSTURE.md` first, then apply **all six postures** to **every** modified and
new file. No scope-narrowing. Time is never the constraint here.

1. **STRUCTURAL** — every claimed-touched file actually touched, every claimed-untouched file
   actually untouched. Line counts, workspace integrity, no stray artifacts.
2. **BEHAVIORAL** — trace every new execution path. Examine every catch block. Verify idempotency.
   If a signature changed, confirm every call site.
3. **ADVERSARIAL** — read it cold, as claims to be disproven. The cleaner it looks, the harder you
   read.
4. **WHOLE-APP SECURITY** — secrets, logging, encryption, input validation, debug affordances.
   Not scoped to the delta.
5. **FUTURE-READER** — read every doc change as a stranger and as David five years from now.
6. **SYNTHESIS** — check findings against `state/RISKS.md` and `state/TODO.md`.

Write the report using `harness/templates/AUDIT_REPORT.md`. Every finding gets a severity —
**Blocker**, **Warning**, or **Note** — and a file path with a line number.

Label the report honestly:

- Any posture skipped or any file excluded → it is a **PARTIAL** audit and must say so.
- If you wrote the code being audited → label it **"self-audit — not independent."**

Calling a partial audit "full" is itself a finding. If there is nothing to report, say the audit
was clean — do not invent findings to look thorough.
