---
name: branch-workflow
description: Develop on branches, never directly on shared branches; integration model varies per repo
metadata:
  type: feedback
---

Develop on a feature branch, never directly on a shared branch (`main` or `dev`). The exact integration model varies per repo — follow the repo's own CLAUDE.md if it states one.

**Default when unspecified:** if the repo has a `dev` branch, cut the feature branch off `dev` (feature → dev → main); otherwise cut it off `main`. Prefer a `dev` integration branch.

**Observed per-repo shapes:** feature off `dev`, user merges `dev` → `main`; or feature off `main` with a `--no-ff` merge and the branch preserved; or trunk-only / direct-to-`main` by design.

**You create and work the feature branch; you do NOT merge to `dev`/`main` or open PRs unless asked** ([[dont-push-to-merge]]). Pushing is per-repo — default to not pushing and confirm ([[commit-push-only-when-asked]]); some repos explicitly want feature branches pushed. Author commits per [[git-commit-identity]].
