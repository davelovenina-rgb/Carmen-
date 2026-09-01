# RISKS

Open risks, newest first. A risk is closed by writing its resolution, not by deleting the row.

| ID | Risk | Severity | Status |
|---|---|---|---|
| **R-001** | Nothing here has been verified against a running Cursor instance. Everything is built from documented behavior, and Cursor's docs demonstrably lag its releases. | Warning | **OPEN** — first Cursor session closes it |
| **R-002** | Project-level hooks were described by Cursor staff as experimental; `beforeShellExecution` requires "Run Everything" enabled, and hooks reportedly do not fire over Remote-SSH. Guards may silently not run. | Warning | **OPEN** — verify in the IDE, do not assume protection |
| **R-003** | Cursor hooks are **fail-open by default** — a crashing guard script lets the action through. `failClosed: true` is set on the guards here, but that flag itself is unverified in the live app. | Warning | **OPEN** |
| **R-004** | `.cursorignore` is not a security boundary. Cursor's own docs state that terminal and MCP tools can still reach ignored files. Secrets must never be in the repo in the first place. | Note | **ACCEPTED** — mitigated by never committing secrets |
| **R-005** | Cursor is retiring embeddings-based semantic indexing in favor of grep-based retrieval. Repo structure should stay greppable — clear filenames, no giant blob files. | Note | **ACCEPTED** — design accounts for it |
| **R-006** | A known Cursor regression: `.cursorignore` negation patterns cannot override `.gitignore` exclusions while Instant Grep is on. Do not rely on `!` re-inclusion. | Note | **ACCEPTED** — no negation patterns used |
