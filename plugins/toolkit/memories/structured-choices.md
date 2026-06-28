---
name: structured-choices
description: Offer bounded options (A/B/C, yes/no/change-X) for decisions rather than open-ended questions
metadata:
  type: feedback
---

When a decision needs the user's input, present a small set of bounded options — "A / B / C", "yes / no / change X" — rather than an open-ended question. The user engages quickly with concrete choices and will redirect if none fit.

**Why:** Repeatedly observed — bounded choices get fast, decisive answers; open-ended prompts stall.

**How to apply:** Lead with a recommended option (and why), then the alternatives with their trade-offs; for a non-trivial choice include a benefits/risks read and be willing to recommend *against*. The user reliably picks the recommendation when one is given, and stalls or asks clarifying questions when none is. In the Claude Code **CLI** the AskUserQuestion tool renders well and is fine to use. On **Web**, do **not** use the AskUserQuestion picker — its UI isn't readable for the user (accessibility); ask the same options inline as plain numbered/lettered text. Reserve structured choices for genuine forks — don't ask about things you can decide yourself ([[execution-cadence]]).
