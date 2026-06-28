---
name: user-owns-outward-actions
description: The agent drafts and pushes branches; the user takes outward, state-changing actions — merges, PRs, publishes, tags, posts — unless told otherwise for that occasion
metadata:
  type: feedback
---

Draw a hard line between *drafting* and *acting on external or state-changing surfaces*. The
agent produces text and pushes the assigned feature branch; the user opens and merges PRs,
publishes releases, pushes tags, yanks packages, and posts cross-repo comments — even when the
agent technically has the access (e.g. via an MCP server) to do it.

**Why:** the user keeps control over what lands in shared/production state and what gets sent
to other people. They review on the remote and take those actions there themselves.

**How to apply:** offer drafts ("here's the release title + notes," "here's the branch — you
merge"), push only the assigned branch, and don't perform an outward action unless explicitly
asked for that occasion. Treat "commit X to dev" or "merge it" as single-occasion permission,
not a standing change to the default. Related: [[commit-push-only-when-asked]],
[[authorize-destructive-actions-per-occasion]], [[do-exactly-whats-asked]].
