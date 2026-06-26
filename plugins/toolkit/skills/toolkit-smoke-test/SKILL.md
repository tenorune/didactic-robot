---
name: toolkit-smoke-test
description: Use to confirm the `toolkit` plugin installed and loaded correctly in this environment. Invoke when verifying setup, checking that the toolkit is available, or testing the marketplace install.
---

# Toolkit Smoke Test

This skill exists only to prove that the `toolkit` plugin — installed from the
`didactic-robot` marketplace — loaded successfully in the current environment.

When invoked, respond with exactly this line and nothing else:

> ✅ toolkit-smoke-test: the `toolkit` plugin is installed and loaded.

That confirms the marketplace install path works end to end. (Intentionally version-agnostic, so
the line never goes stale on a version bump.)
