# Instruction Blocks

Reusable CLAUDE.md snippets. This is a paste / `@import` library — **not** auto-loaded by any
harness, by design. To use a block, copy its body into a project's `CLAUDE.md`, or reference it
with an `@import` line.

The `@import` lines use a `<path-to-didactic-robot>` placeholder — replace it with wherever you
cloned this repo (e.g. `~/code/didactic-robot`).

| Block | Use it when |
|-------|-------------|
| `dont-push-to-merge.md` | You want the assistant to stop asking "ready to merge?" and let you drive testing and merging on your own cadence. |
| `commit-and-version-restraint.md` | You want commits, pushes, and version bumps to wait for your explicit go-ahead. Companion to `dont-push-to-merge.md`. |
| `branch-workflow.md` | You want development to happen on feature branches with a `dev`/`main` integration model, never directly on a shared branch — plus branch-hygiene habits (descriptive announced names, stay current with integration, one concern per branch). |
| `scope-discipline.md` | You want a narrow request to stay narrow — no redesigns or "while I was here" extras — and out-of-scope work offered as a GitHub issue instead of folded in. |
| `session-handoff.md` | You want context to survive across sessions and machines through durable in-repo artifacts (handoff doc, specs, paste-able kickoff) rather than chat memory. |
| `git-commit-identity.md` | You want commits authored under one GitHub handle/noreply email and no real personal identifiers anywhere in the work. |
| `evidence-before-claims.md` | You want success claims grounded in observed evidence — OBSERVED vs UNKNOWN, no "fixed" from a single run. |
| `pristine-commits.md` | You want every commit to build, pass tests, and add no new warnings in the files it touches. |

## Import them all

Paste this into a project's `CLAUDE.md` to pull in every block at once:

```
@<path-to-didactic-robot>/instruction-blocks/dont-push-to-merge.md
@<path-to-didactic-robot>/instruction-blocks/commit-and-version-restraint.md
@<path-to-didactic-robot>/instruction-blocks/branch-workflow.md
@<path-to-didactic-robot>/instruction-blocks/scope-discipline.md
@<path-to-didactic-robot>/instruction-blocks/session-handoff.md
@<path-to-didactic-robot>/instruction-blocks/git-commit-identity.md
@<path-to-didactic-robot>/instruction-blocks/evidence-before-claims.md
@<path-to-didactic-robot>/instruction-blocks/pristine-commits.md
```
