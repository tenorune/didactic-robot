# Candidate memories

Staging area for memory fact-files that are **tracked in the repo but not shipped** by the
`toolkit` plugin. The plugin only loads memories under `plugins/toolkit/memories/`; nothing here
is in scope for a live session.

Use this folder to draft, review, and keep history on a memory before deciding whether it earns a
place in the shipped set. To promote one: move it into `plugins/toolkit/memories/` and add a line
to that directory's `MEMORY.md` index.

| Candidate | Status |
|-----------|--------|
| `memory-portability-audience.md` | Harvested from another machine; portable-vs-local memory-placement rule. Likely ships. |
| `backup-claude-state-for-machine-switching.md` | Harvested + scrubbed; personal-infra practice. Overlaps the toolkit's own portability model — kept as a candidate, may stay user-level only. |
