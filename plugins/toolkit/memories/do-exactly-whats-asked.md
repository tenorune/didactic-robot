---
name: do-exactly-whats-asked
description: For a narrow request, change only that — don't redesign, over-engineer, or bundle in unrequested extras
metadata:
  type: feedback
---

When the user asks for a small, specific change, deliver exactly that and nothing more.
Preserve the existing, working structure and styling instead of redesigning, and don't fold
in adjacent "improvements" you happened to notice.

**Why:** unrequested changes — renames, restyles, extra fields, a "while I was here" feature,
a deploy-hygiene bump — add review cost, obscure the actual change, and sometimes contradict
the intent. The user gates scope on purpose and reacts sharply when a one-line ask comes back
as a redesign.

**How to apply:** do the literal ask first. If you spot a worthwhile adjacent change,
*recommend* it in chat with a one-line rationale and let the user decide — don't silently add
it to the commit. For a narrow rename/edit it's fine to surface the surrounding context (e.g.
the related terms on the same line) so they can choose the full scope — but don't expand the
change yourself.
