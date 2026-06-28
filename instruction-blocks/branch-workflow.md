# Branch workflow

Paste the section below into a project's `CLAUDE.md` to keep development on feature branches.
Or `@import` the file instead:

```
@<path-to-didactic-robot>/instruction-blocks/branch-workflow.md
```

## Workflow: develop on branches

- Develop on a feature branch, never directly on a shared branch (`main` or `dev`). If this
  repo's CLAUDE.md states its own integration model, follow that.
- Default when unspecified: if the repo has a `dev` branch, cut the feature branch off `dev`
  (feature → dev → main); otherwise cut it off `main`. Prefer a `dev` integration branch.
- You create and work the feature branch. You do **not** merge to `dev`/`main` or open PRs
  unless I ask.
- Pushing is per-repo — default to not pushing and confirm first; some repos explicitly want
  feature branches pushed.

## Branch hygiene

- **Name branches descriptively and tell me the name.** Don't silently use the harness's
  auto-generated name (`claude/<random-words>`) — it's meaningless to me. Pick a short,
  descriptive name for the work (e.g. `fix-canvas-dot-duplication`) and tell me what you chose.
- **Keep the branch current with the integration branch.** When I say I merged something into
  the integration branch, fetch it before continuing rather than assuming your local copy is
  current. Before handing work back, merge the integration branch *into* the feature branch so
  the eventual merge stays clean and CI runs against the real base.
- **One concern per branch.** If unrelated work surfaces mid-task, put it on its own branch
  rather than folding it into the current one.
