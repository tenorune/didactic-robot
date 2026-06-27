---
name: commit-push-only-when-asked
description: Never commit or push unprompted; wait for an explicit instruction
metadata:
  type: feedback
---

Do not run `git commit` or `git push` until the user explicitly asks. Do the work — edit files, run verification — and leave changes uncommitted until told.

**Why:** The user controls when work is recorded and published; premature commits and pushes are hard to walk back.

**How to apply:** When work is ready, say so and wait. When the user says to commit, commit on a branch per [[branch-workflow]], authored per [[git-commit-identity]]. Don't pair this with merge-nudging — see [[dont-push-to-merge]].
