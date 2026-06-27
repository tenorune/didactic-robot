---
name: no-memory-rules-in-repo
description: Don't scatter personal preference/identity rules into project repos; centralize them; project repos hold technical conventions only
metadata:
  type: feedback
---

Keep the user's personal working-preference and identity rules OUT of individual project/product repo files (CLAUDE.md, AGENTS.md, docs). Those repos are public and per-project — scattering personal rules there leaks them and duplicates them across repos.

**In a project repo's CLAUDE.md, keep only project-specific TECHNICAL conventions:** branch model, test/build/deploy commands, architecture notes, a docs/lessons.md pointer.

**Personal, cross-project preferences live centrally** — in the user's private session memory and in this shared-memory set — so they travel across projects from one home. (See [[git-commit-identity]]: never commit the user's real name/email anywhere.)
