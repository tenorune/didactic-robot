---
name: idempotent-operations-true-no-op
description: An idempotent operation should leave no trace when nothing changed — no churn commits, writes, or downloads
metadata:
  type: feedback
---

When an operation is meant to be idempotent (a scheduled job, a sync, a regenerate step), the
*absence of work* should show as the *absence of side effects*: if nothing changed, don't write a
commit, don't rewrite a file or bump a timestamp, and don't re-download unchanged assets.

**Why:** churn-on-no-change adds noise to history and wastes bandwidth, and it hides whether
anything actually happened — a run that "did nothing" should look like it did nothing.

**How to apply:** gate writes/commits/downloads on a real content diff; when the inputs are
unchanged, exit having produced no side effects. Relates: [[runtime-agnostic-core]],
[[ship-safe-part-first]].
