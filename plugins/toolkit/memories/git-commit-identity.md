---
name: git-commit-identity
description: The only identity allowed in commits, code, docs, and output — never leak the user's real name or email
metadata:
  type: reference
---

Author git commits as `tenorune <117549102+tenorune@users.noreply.github.com>` — the GitHub handle and its noreply email. Set per-repo when needed: `git config user.name tenorune` and `git config user.email 117549102+tenorune@users.noreply.github.com`.

These are the **only** personal identifiers permitted anywhere the work is recorded or shown — not just commit metadata, but code, comments, docs, config, and any output. Never write the user's real name, personal email, or aliases (including derived tokens).

When verifying, scan **generically** — match any email/name/token pattern and filter *in* the allowed `tenorune` / noreply values — rather than hardcoding the real name or email into a denylist (which would itself leak them).

In shareable artifacts the user pastes elsewhere (a handoff, release notes, a kickoff message) the rule extends: also strip internal-config references (e.g. `CLAUDE.md`) and the model identifier — keep those to chat only. When scrubbing a stray identifier, replace even a real surname *initial* used as a placeholder, do it without asking, use a clearly-fictional generic placeholder, and don't name the offending token in the scrub commit message.
