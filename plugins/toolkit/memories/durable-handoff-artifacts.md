---
name: durable-handoff-artifacts
description: Treat in-repo docs (handoff, specs, plans) as the real cross-session memory — read them on start, update them at the end
metadata:
  type: feedback
---

The user cannot reliably recover prior Claude Code sessions, so durable in-repo documents —
not conversation memory — are the authoritative handoff between sessions and across machines.

**Why:** chat context doesn't survive a session ending or a machine switch; specs, plans, and
a handoff doc do, and they are what a fresh session reloads to get oriented. Re-explaining
context wastes tokens and risks omission.

**How to apply:** on session start, read the project's orientation doc (e.g. `HANDOFF.md`) and
the relevant specs/plans before acting. When wrapping substantive work, produce BOTH a
paste-able next-session kickoff message AND an update to the handoff doc (most-recent work,
in-flight items, open issues, conventions, key files). Prefer durable artifacts — commit
messages, spec/plan files, a living architecture/README doc kept in sync with a changelog —
over chat for anything that must outlive the session. Related: [[paste-ready-deliverables]].
