---
name: pristine-commits
description: Every commit builds and passes tests with no NEW warnings in touched files
metadata:
  type: feedback
---

Hold each commit to a pristine bar: it builds, tests pass, and it introduces no new compiler/linter warnings in the files it touches — not just no new errors.

**How to apply:** Before committing, check the build/test output for warnings in your changed files and clear them. "Pristine output" is the standard; don't let warning noise accumulate commit over commit. Related: [[evidence-before-claims]] — read the actual output, don't assume it's clean.
