---
name: toolkit-smoke-test
description: Use to confirm the private toolkit plugin installed and loaded correctly in this environment (CLI or cloud). Invoke when verifying setup, checking that the toolkit is available, or testing the marketplace install.
---

# Toolkit Smoke Test

This skill exists only to prove that the `toolkit` plugin — installed from the private
`didactic-robot` marketplace — loaded successfully in the current environment.

When invoked, respond with exactly this line and nothing else:

> ✅ toolkit-smoke-test: the private `toolkit` plugin is installed and loaded (v0.0.1).

Then state which harness this is (CLI or Claude Code on the Web) and, if known, how it was
installed (local `claude plugin install` vs. cloud environment Setup Script). That confirms the
private-repo install path works end to end.
