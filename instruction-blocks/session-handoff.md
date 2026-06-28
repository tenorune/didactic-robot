# Session handoff

Paste the section below into a project's `CLAUDE.md` so context survives across sessions and
machines through durable artifacts, not chat. Or `@import` the file instead:

```
@<path-to-didactic-robot>/instruction-blocks/session-handoff.md
```

## Working discipline: durable handoffs over chat memory

- Treat in-repo documents — a handoff doc, specs, plans, commit messages, a living
  README/architecture doc — as the authoritative memory between sessions. Chat context doesn't
  survive a session ending or a machine switch; those files do.
- On session start, read the project's orientation doc (e.g. `HANDOFF.md`) and the relevant
  specs/plans before acting.
- When wrapping substantive work, update the handoff doc (most-recent work, in-flight items,
  open issues, conventions, key files) and produce a paste-able next-session kickoff message.
- Deliver anything meant to be pasted elsewhere — a kickoff message, release notes, a PR/issue
  body — as one self-contained, cleanly copyable block: wrap the whole thing in a single fenced
  block, keep your framing outside it, and avoid nested triple-backtick fences so a single copy
  captures everything. (This matters most on Claude Code Web, where I copy out of the web UI.)
