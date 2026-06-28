---
name: config-secrets-via-gitignored-env
description: Put tunables, secrets, and identity in a gitignored .env (with a committed .env.example), injected at runtime — never hardcoded or committed
metadata:
  type: feedback
---

For anything configurable or sensitive — secrets, deploy targets, hostnames, ports, even the
user's own identity strings — default to a gitignored `.env` read at runtime, paired with a
committed, annotated `.env.example` that documents every variable and its default. Don't
hardcode these into committed source.

**Why:** it keeps secrets and personal/identity values out of git history (which matters most
for public repos), and lets the user switch dev/prod or move between machines without editing
code.

**How to apply:** when a script or app gains tunables, set up the `.env` loader (existing
environment wins), ship the annotated `.env.example`, and add `.env` to `.gitignore` —
without being asked. For dev/prod, keep `.env.dev` / `.env.prod` and switch by copying. The
same instinct covers other config seams (e.g. a gitignored `.firebaserc` with a committed
`.example`). Related: [[no-personal-identifiers]] — identity is one of the values that belongs
in this seam, not in source.
