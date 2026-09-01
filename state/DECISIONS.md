# DECISIONS

Every decision that shapes the repository, with the reasoning that produced it. Append only.
A decision recorded here is **not a finding** in an audit (`law/AUDIT_SIX_POSTURE.md`).

---

## D-001 — Fresh build, no inheritance
**Date:** 2026-09-01 · **By:** David

The harness is built new. Nothing is copied from `carmen-cursor`, `carmen-sg-docs`,
`carmen-sg-cursor`, or the IntelliJ repository. Those remain separate and untouched.

*Why:* David asked for something fresh rather than a merge of existing efforts, which had become
tangled. Mixing lineages was the specific failure mode to avoid.

## D-002 — No-stamp
**Date:** 2026-09-01 · **By:** David

No `SEALED` stamps, approval stamps, or "verified by" stamps written by an agent. Status is
plain prose in `state/CURRENT_STATE.md`. Only David seals, in his own words.

## D-003 — No bots-first gate
**Date:** 2026-09-01 · **By:** David

No CI workflow, no bot review, and no bot participation in any gate. Verification is local:
`harness/verify.sh`, the six-posture audit, and David's own read. Cursor's local review is a
tool Carmen may run, never a gate she must pass.

## D-004 — Exactly one AGENTS.md, at the root
**Date:** 2026-09-01 · **By:** Carmen (research-driven) · **Ratified:** pending David

Cursor 3.6+ discovers nested `AGENTS.md` files across the entire repository and loads each one
in full on **every** request, because `AGENTS.md` is an always-rule. On a large tree that has
blown past context windows in the field. Directory-scoped guidance therefore lives in globbed
`.mdc` rules, which attach only when a matching file is in context.

*Source:* `docs/CURSOR_RESEARCH.md` §Rules — nested AGENTS.md, with Cursor staff citation.

## D-005 — Heavy knowledge lives in skills, not rules
**Date:** 2026-09-01 · **By:** Carmen (research-driven) · **Ratified:** pending David

Cursor's dynamic context discovery keeps only a skill's `name` and `description` in static
context and loads the body on demand. Always-on rules cost tokens on every single request. So the
three always-rules are kept deliberately tiny, and the long-form material lives in
`.cursor/skills/` and `lanes/`.

## D-006 — Lane conventions align with David's existing Android practice
**Date:** 2026-09-01 · **By:** Carmen

The Kotlin Compose lane follows the conventions David already uses — MVI with State/Action/Event,
Koin DI, typed `Result` error handling, feature-layered modules, JUnit5 + Turbine + AssertK.
A competing convention set would have made the harness fight his existing work.
