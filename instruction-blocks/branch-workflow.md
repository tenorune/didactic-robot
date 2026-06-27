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
