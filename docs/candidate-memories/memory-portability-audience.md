---
name: memory-portability-audience
description: When creating a project memory, decide portable vs local-only — portable goes to both the user store and the repo; local-only stays in the user store
metadata:
  type: feedback
---

When you create a project memory, decide its audience before choosing where it lives:

- **Portable** — makes sense in any session, including cloud/web ones with no access to
  this machine. Write it to the user-level memory store AND the repo's committed memory
  set (and its index).
- **Local-only** — references local context a cloud session can't use: machine paths,
  local scripts, secret-backup workflows, specific drives. Keep it only in the user-level
  store; do not commit it to the repo.

**Why:** A repo's committed memory set is curated for any session that checks out the repo
(including Claude Web). Local-only feedback confuses sessions that lack the local tools it
assumes.

**How to apply:** As you write a memory, ask "would this still make sense in a cloud session
with no access to this machine?" Yes → both places. No → user store only.
Related: [[no-memory-rules-in-repo]].
