---
name: paste-ready-deliverables
description: Deliver copy-paste output as one self-contained, cleanly copyable block — matters most on Web (copying out of the web UI); CLI copy-paste is generally fine
metadata:
  type: feedback
---

When a deliverable is meant to be pasted into another surface — a new session's kickoff
message, release notes, a PR/issue body, a handoff — output it as a single contiguous block
the user can select and copy in one action.

**Why:** the user pastes these into other tools. Prose interleaved inside the content, or
formatting that breaks selection, makes it un-copyable, and they will reject the first
attempt and ask again.

**How to apply:** wrap the whole deliverable in one fenced code block; keep your own framing
*outside* the block. Avoid nested triple-backtick fences inside it (use a different outer
fence length, or indented snippets) so a single copy captures the whole thing. **This matters most
on Claude Code Web** — the user copies out of the web chat UI; in the **CLI** copy-paste is
generally fine, so reserve the extra care for Web deliverables. When the user says "give me X in a
form I can copy / paste," that is the signal. Related: [[durable-handoff-artifacts]].
