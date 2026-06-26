---
name: handing-off-a-session
description: Use when wrapping up a work session or preparing to hand work to a future session or teammate — "write a handoff", "wrap up", "prepare for the next session", or before stopping at the end of a chunk of work.
---

# Handing Off a Session

## Overview

A good handoff lets a fresh agent — zero memory of this session — resume and succeed while paying the
fewest context tokens. That takes two deliverables: **durable artifacts** updated in place, AND a
**paste-ready message** the human can drop into a new session. Produce BOTH — agents reliably write the
docs and forget the message.

## When to use

- Ending a session, finishing a feature, or before a long pause.
- The human says "hand off", "wrap up", "prep the next session".
- NOT for mid-task checkpoints where work continues in the same session.

## Procedure

1. **Verify state — never hand off red.** Run the project's tests and build; confirm the working tree is
   clean. Report the actual results. If something fails, fix it or flag it explicitly in the handoff —
   don't paper over it.
2. **Finish the branch.** REQUIRED SUB-SKILL: superpowers:finishing-a-development-branch (merge / PR /
   keep / discard). Do this before writing the handoff so the recorded state is final.
3. **Update the durable artifacts** — only the ones the project actually uses, each in the Shape below:
   - **Auto-loaded memory / status note** (the real always-current on-ramp): current state in 1–2 lines +
     what's next + open follow-ups.
   - **Roadmap**: forward-only. *Remove* shipped items (don't strike-through and keep them); note once at
     the top that shipped work lives in git/plans/specs.
   - **Handoff doc** (if the project keeps one): the full Shape below.
4. **Emit the paste-ready next-session message** — the deliverable the human pastes to start fresh, the
   Shape below compressed into a message. This is the step agents skip. Do not skip it.

## Shape — applies to the handoff doc AND the paste message

Lead with what the next session needs NOW, in this order:

1. What this is — project + location, one line
2. What's next — the first concrete action / the open decision
3. On-ramp pointers — which doc or memory is the source of truth
4. Environment essentials — the exact test / build / run commands
5. Conventions — branching, commit rules, test policy
6. The human's working style
7. `---` Landmines / gotchas worth knowing before touching code
8. `---` History — finished work, compressed, labeled "skip unless relevant"

Two properties make or break it:
- **Forward-first, history last and clearly skippable.** History is recorded in git/plans/specs — point to
  it, don't restate it.
- **No bare codenames.** A signifier like "Phase 3" or "Foundation B" means nothing to a fresh agent.
  Define it inline in one line, or cut it.

## Common mistakes

| Mistake | Fix |
|---|---|
| Wrote handoff docs but no paste-ready message | The message is a deliverable (step 4), not optional. |
| Left shipped/DONE items on the roadmap | Roadmap is forward-only; remove items when they ship. |
| Led with status of finished work | History goes in a skippable tail, below `---`. |
| Bare codenames ("Phase 3", "Foundation B") | Define inline in one line, or cut. |
| Handed off without running tests/build | Verify state first; never hand off red. |
| Restated detail already in git/plans/specs | Point to the source; keep the handoff thin. |

## Quick reference

verify (tests + build + clean tree) → finish branch → update memory/roadmap/handoff (forward-first) →
**emit the paste-ready message**.
