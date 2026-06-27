---
name: ship-safe-part-first
description: When a change mixes a clean mechanical part and a risky entangled part, ship the safe part now and file the rest separately
metadata:
  type: feedback
---

When a change has a clean, mechanical sub-part and a risky, entangled sub-part, don't bundle them. Ship the safe, high-value part now; file the entangled remainder as its own tracked issue.

**Why:** Bundling a risky behavioral change onto a clean mechanical one puts the safe win at risk and makes review harder. Splitting keeps each piece independently reviewable and revertible.

**How to apply:** Find the seam, land the mechanical part, and write up the remainder as a separate scoped task. Related: [[evidence-before-claims]], [[pristine-commits]].
