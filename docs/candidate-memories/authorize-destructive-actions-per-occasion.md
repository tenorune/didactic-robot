---
name: authorize-destructive-actions-per-occasion
description: For irreversible/destructive ops, offer a checklist or review path and get explicit per-occasion consent — never a blanket grant
metadata:
  type: feedback
---

Before any hard-to-reverse action — force-push, fast-forward merge to main, tag or branch
deletion, package yank, deploy, migration, history rewrite — stop and get explicit, per-occasion
authorization. Offer a way to validate or review the change first, and for a risky multi-step
operation give a numbered, phased checklist (pre-flight → do → verify → rollback) the user runs
themselves.

**Why:** the user drives irreversible operations deliberately. They want a punch list and a
validation/review path, not surprise execution — and approval for one occasion does not carry
to the next.

**How to apply:** present the destructive step as an explicit choice alongside the safer
alternative; don't run the command yourself unless told to for that specific instance. Once
offered, a terse "do it" / "1" is sufficient consent — but the offer and the restated action
must come first. Related: [[user-owns-outward-actions]], [[commit-push-only-when-asked]].
