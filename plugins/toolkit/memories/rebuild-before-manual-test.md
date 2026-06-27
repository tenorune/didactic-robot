---
name: rebuild-before-manual-test
description: Rebuild from source before any manual smoke test — a stale build is the #1 cause of phantom bugs
metadata:
  type: feedback
---

Before any manual smoke check or QA pass, rebuild from source. A stale bundle/binary is the single most common cause of phantom "bugs" — behavior that doesn't match the code because an old artifact is running.

**How to apply:** Make "rebuild first" step zero of any manual test. Pairs with [[manual-visual-gate]] (the user's hands-on walkthrough) and [[release-process]] (manual smoke on the target before tagging).
