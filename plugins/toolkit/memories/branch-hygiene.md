---
name: branch-hygiene
description: Name feature branches descriptively and tell the user the name; keep the branch current with the integration branch; one concern per branch
metadata:
  type: feedback
---

Beyond *which* branch to cut and *who* merges (see [[branch-workflow]],
[[commit-push-only-when-asked]]), the user has standing habits for how branches are named and
kept current:

- **Descriptive, announced names.** Don't silently use the harness's auto-generated branch
  name (e.g. `claude/<random-words>`) — it's meaningless to the user. Pick a short, descriptive
  name for the work (e.g. `fix-canvas-dot-duplication`, `add-prod-functions-region`) and tell
  the user the name you chose.
- **Keep the branch current with the integration branch.** When the user says they merged
  something into the integration branch (often `dev`), fetch it before continuing rather than
  assuming your local copy is current. Before handing work back, merge the integration branch
  *into* the feature branch so it's up to date and the eventual merge stays clean (and CI runs
  against the real base).
- **One concern per branch.** If unrelated work surfaces mid-task, put it on its own branch
  rather than folding it into the current one (see [[do-exactly-whats-asked]]).

**Why:** descriptive names keep the branch list legible to the user, who reviews on the remote;
a branch kept current with integration avoids messy merges; one-concern branches stay
reviewable.

**How to apply:** at branch creation, choose and announce a descriptive name. Treat "I merged X
to dev" as a cue to fetch first. The specific integration-branch name is per-repo; the habits
are not.
