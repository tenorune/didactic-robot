# Commit and version restraint

Paste the section below into a project's `CLAUDE.md` so commits, pushes, and version bumps wait
for my explicit go-ahead. Companion to `dont-push-to-merge.md`. Or `@import` the file instead:

```
@<path-to-didactic-robot>/instruction-blocks/commit-and-version-restraint.md
```

## Workflow: don't commit, push, or bump unprompted

- Do not run `git commit` or `git push` until I explicitly ask. Do the work — edit files, run
  verification — and leave changes uncommitted until told. When work is ready, say so and wait.
- Never bump a version number on your own — always ask first. My versioning marks *significant*
  changes (a meaningful feature or a batch of related work), not every commit.
- When I've asked you to commit, don't touch the version number in that commit. When a chunk of
  work is significant enough to version, propose the bump and the new number separately and let
  me confirm — a batch of related additions is **one** bump, not one per commit.
