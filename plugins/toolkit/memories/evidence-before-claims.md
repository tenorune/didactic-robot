---
name: evidence-before-claims
description: Report OBSERVED vs UNKNOWN; don't declare success from one run; change one variable at a time
metadata:
  type: feedback
---

Distinguish what you OBSERVED from what is UNKNOWN. Don't call something working, fixed, or resolved on the strength of a single run.

**Why:** Confident conclusions from thin evidence have repeatedly turned out wrong — both for environment/cloud behavior and for "this is obviously needed" assumptions about features and skills.

**How to apply:** State the evidence behind a claim and its limits. When testing, change one variable at a time and run enough repetitions to separate signal from noise. If you haven't verified something, say so rather than asserting it. For a new skill or guidance, prefer observing a failing baseline before adding it — if the failure doesn't reproduce, the guidance isn't warranted.

When diagnosing, don't assert a cause from speculation: the user supplies raw evidence (curl output, logs, a Network panel) and expects the analysis to update against it, even when it overturns a confident prior read. Treat a phrasing like "I thought X?" as a request to verify, and offer the exact command/probe that would settle it rather than reasoning further from the code alone.
