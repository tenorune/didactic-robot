---
name: docs-lessons-file
description: Keep a docs/lessons.md of hard-won, codebase-specific gotchas — consult before, append after
metadata:
  type: feedback
---

For a codebase with non-obvious, easy-to-rediscover gotchas (platform quirks, framework traps, layout footguns — e.g. macOS AppKit interactions), keep a standing `docs/lessons.md` of hard-won findings.

**How to apply:** Consult it before debugging in that area; when a debugging session produces a non-trivial finding, append it. This keeps expensive rediscoveries from happening twice. Related discipline: [[evidence-before-claims]].
