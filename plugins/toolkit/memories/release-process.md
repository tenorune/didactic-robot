---
name: release-process
description: How to cut a release — main green via CI, manual smoke on target, then a version tag publishes
metadata:
  type: feedback
---

Releases are tag-driven, not push-driven:

1. Land the change on `main` and let CI (verify/build) go green. Pushes to `main` never publish.
2. Run a manual smoke test on the actual target platform — CI builds the artifact but doesn't install/run it as a user would, so it misses install-time failures.
3. Push a `vX.Y.Z` tag. The tag triggers the publish workflow.

Publish without stored secrets where possible (e.g. GitHub OIDC trusted publishing for PyPI — no long-lived tokens). Merging/tagging happens when the user says so ([[dont-push-to-merge]]); author per [[git-commit-identity]].
