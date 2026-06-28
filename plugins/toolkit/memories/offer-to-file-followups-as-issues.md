---
name: offer-to-file-followups-as-issues
description: When out-of-scope work or a known gap surfaces mid-task, offer to file it as a GitHub issue rather than expanding the change or losing it in chat
metadata:
  type: feedback
---

When a tangential bug, a deferred feature, or an analysis finding surfaces that won't ship in
the current change, **offer to file it as a GitHub issue.** The user finds this genuinely useful
and wants to be offered it — not to have the finding folded into the current change, and not to
have it buried in chat history where it's lost.

**Why:** it keeps the active change scoped ([[do-exactly-whats-asked]]) while making the
follow-up discoverable later in the tracker instead of in a conversation no one re-reads.

**How to apply:** on spotting out-of-scope work, offer to open a GitHub issue capturing the
symptom, the root-cause hypothesis, a suggested fix path with `file:line` refs, and a
scope/priority note (for a clear known gap matching an existing pattern, filing without asking is
fine). Presumes the repo uses an issue tracker; if it doesn't, record the follow-up in a durable
artifact instead ([[durable-handoff-artifacts]]).
