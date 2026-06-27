---
name: pre-release-secret-scan
description: Before shipping artifacts, grep the build/dist output for secret-shaped strings and build-host paths as a hard gate
metadata:
  type: feedback
---

Before attaching or publishing release artifacts, scan the built `dist/` / bundle output as a hard gate:

- secret-shaped strings (e.g. `API_KEY`, `SECRET`, `TOKEN`, provider-specific prefixes) → must be empty
- build-host filesystem paths (`/Users/`, `/home/`, `C:\Users\`) → must be empty

Fail the release on any hit. This is the build-output sibling of the [[git-commit-identity]] scan — run it generically (match the pattern, filter the allowed values) rather than from a hardcoded denylist.
