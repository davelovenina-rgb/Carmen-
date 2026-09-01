Run repository verification and report what you actually found.

1. Run `./harness/verify.sh` and show the real output — not a summary of it.
2. Run `git status --porcelain` and `git diff --stat`.
3. Confirm nothing under `soul/`, `law/`, or any protected path was modified.
4. If a build or test command applies to the current lane, run it and show the output.

Report in this shape:

```
VERIFICATION
verify.sh:     PASS | FAIL  (<n> checks)
Working tree:  clean | <n> files modified
Protected:     untouched | ⚠ <path> modified
Build:         PASS | FAIL | n/a
Tests:         <passed>/<total> | n/a
```

Then list every failure with its exact output. Do not soften a failure, do not describe a failing
check as "mostly passing," and do not attempt to fix anything — this command reports, it does not
repair. Fixes are a separate proposal and need their own GO.

If you did not run a check, say `not run` and why. Never report a check you did not execute.
