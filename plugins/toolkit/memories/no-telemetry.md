---
name: no-telemetry
description: Published tools make an explicit no-analytics / no-telemetry commitment
metadata:
  type: feedback
---

Tools released publicly carry an explicit commitment: no analytics, no telemetry, no error-reporting endpoint, no outbound calls except the user-initiated features themselves. State it plainly in the README or a privacy doc.

**How to apply:** Don't add analytics or phone-home behavior to published tools. If a feature must make network calls, they are user-initiated and disclosed. Pairs with [[publishable-tooling-defaults]].
