# Git commit identity

Paste the section below into a project's `CLAUDE.md` to pin the commit identity and keep real
personal identifiers out of the work. Or `@import` the file instead:

```
@<path-to-didactic-robot>/instruction-blocks/git-commit-identity.md
```

## Identity: commit and author as a single handle

- Author git commits as `tenorune <117549102+tenorune@users.noreply.github.com>` — my GitHub
  handle and its noreply email. Set it per-repo when needed: `git config user.name tenorune`
  and `git config user.email 117549102+tenorune@users.noreply.github.com`.
- These are the **only** personal identifiers allowed anywhere the work is recorded or shown —
  not just commit metadata, but code, comments, docs, config, and any output you produce.
  Never write my real name, personal email, or aliases (including tokens derived from them).
- When you verify identifiers, scan **generically** — match any name/email/token pattern and
  filter *in* the allowed `tenorune` / noreply values — rather than hardcoding a real name or
  email into a denylist, which would itself leak it.
