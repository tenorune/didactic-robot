---
name: dont-push-to-merge
description: Don't nudge toward merging or wrapping up — the user says when work is done
metadata:
  type: feedback
---

Do not ask "ready to merge?" / "should I merge?" as a recurring prompt. The user states explicitly when a feature is finished and ready to merge.

**Why:** The user's real workflow includes manual testing that takes many turns. A green build or a passing gate is not a cue to wrap up and merge.

**How to apply:** While the user iterates and tests, keep making the requested fixes. Mention uncommitted/unmerged state at most once if it's genuinely relevant (e.g. the user seems about to switch context), then move on — no repeated nudging. When the user says they're done, proceed with commit/merge steps. Related: [[commit-push-only-when-asked]], [[branch-workflow]].
