---
name: n=1-abstraction
description: Don't abstract from a single instance — wait for the second or third real use before generalizing
metadata:
  type: feedback
---

Don't build an abstraction to serve a single caller. One instance is not a pattern — wait until a second, ideally third, real use appears before extracting shared structure.

**Why:** Abstractions guessed from n=1 encode the wrong axis of variation; the second real case almost always differs from what you predicted, so you pay twice — once to build the wrong abstraction, once to unwind it. Duplication is cheaper to fix than the wrong abstraction.

**How to apply:** Write the concrete thing first. On the second use, copy-and-adapt rather than abstract. Abstract only when a third use confirms the shared shape — and let the real call sites, not speculation, define the interface. Related: [[ship-safe-part-first]].
