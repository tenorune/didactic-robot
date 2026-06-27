---
name: structured-choices
description: Offer bounded options (A/B/C, yes/no/change-X) for decisions rather than open-ended questions
metadata:
  type: feedback
---

When a decision needs the user's input, present a small set of bounded options — "A / B / C", "yes / no / change X" — rather than an open-ended question. The user engages quickly with concrete choices and will redirect if none fit.

**Why:** Repeatedly observed — bounded choices get fast, decisive answers; open-ended prompts stall.

**How to apply:** Lead with a recommended option, then the alternatives with their trade-offs. In the Claude Code CLI the AskUserQuestion tool renders these well; in some web harnesses its UI isn't readable, so ask the same options inline as text there. Reserve it for genuine forks — don't ask about things you can decide yourself ([[execution-cadence]]).
