---
name: fail-closed-defaults
description: On error or uncertainty, default to the safe/restrictive state — never the permissive one
metadata:
  type: feedback
---

When something fails, is missing, or is ambiguous, default to the safe and restrictive outcome — deny, stop, or withhold — rather than the permissive one. Don't let an error open the gate.

**Why:** Fail-open behavior turns a small failure (a missing config, a thrown check, a timeout) into a security or correctness hole. The safe default is the one where a failure costs availability, not integrity.

**How to apply:** Write checks so the absence of a positive result means "no/blocked," not "yes." On an exception inside a guard, return the restrictive answer. Make the secure path the default and the permissive path an explicit, deliberate opt-in. Related: [[publishable-tooling-defaults]], [[no-telemetry]].
