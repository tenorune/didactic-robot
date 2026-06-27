---
name: manual-visual-gate
description: For UI/visual work, the user's hands-on walkthrough is the acceptance gate — a green build is not "done"
metadata:
  type: feedback
---

For any UI or visual feature, automated tests are necessary but not sufficient. The real acceptance gate is the user's hands-on visual walkthrough — work is not "done" until the user has run it and said so.

**Why:** The user is a hands-on tester and will reject work that passes every test if it doesn't look or read right. (A fully-built, green-tested feature has been parked because the visual gate failed.)

**How to apply:** Don't treat a green build as done, and don't nudge toward merging ([[dont-push-to-merge]]). Expect manual-test iterations; keep making fixes while the user walks through it. The user says when it's done.
