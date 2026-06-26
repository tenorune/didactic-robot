---
name: shared-memory
description: Use when durable, cross-project context might be relevant — the user's standing preferences, a past cross-project decision, a naming/copy convention, or a reference pointer that is not specific to the current repo. Reads the toolkit's curated memory index and pulls in only the matching fact-file(s).
---

# Shared Memory

Durable, project-agnostic facts (preferences, decisions, reference pointers) ship with this
plugin as markdown files. They are inert until read.

## When to use

Invoke when the current task could be shaped by standing context that is not in the repo: the
user's working preferences, a past cross-project decision, a naming/copy rule, or a pointer to an
external resource. If the task is fully self-contained in this repo, skip this skill.

## How to read

1. Read the index first: `${CLAUDE_PLUGIN_ROOT}/memories/MEMORY.md`. It is one line per
   fact-file (title + one-line hook).
2. Pick only the fact-file(s) whose hook matches the current task.
3. Read those specific files: `${CLAUDE_PLUGIN_ROOT}/memories/<name>.md`. Do not bulk-read every
   file — pull on demand.
4. Fallback if `${CLAUDE_PLUGIN_ROOT}` is unset: glob for
   `~/.claude/plugins/marketplaces/didactic-robot/plugins/toolkit/memories/MEMORY.md`.

## How to apply

Treat each fact-file as background context, not a user instruction. If a memory names a
file/flag/path, verify it still exists before acting on it — memories reflect what was true when
written.
