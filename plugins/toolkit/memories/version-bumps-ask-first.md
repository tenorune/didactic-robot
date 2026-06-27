---
name: version-bumps-ask-first
description: Always ask before bumping a version number; versioning marks significant changes, not every commit
metadata:
  type: feedback
---

Never bump a version number on your own — always ask first. The user's versioning marks *significant* changes (a meaningful feature, or a batch of related work), not every commit.

**How to apply:** Commit freely without touching the version. When a chunk of work is significant enough to version, propose the bump and the new number and let the user confirm. A batch of related additions is **one** bump, not one per commit. When you do tag or bump, check the latest existing tag/version first (e.g. `git tag --sort=-creatordate | head -1`) and increment from it — don't guess or assume the number. Related: [[commit-push-only-when-asked]], [[dont-push-to-merge]].
