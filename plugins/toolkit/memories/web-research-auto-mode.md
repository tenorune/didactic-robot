---
name: web-research-auto-mode
description: Warn before web-research / fan-out agent runs — Edit mode prompts per domain; suggest switching the CLI to AUTO first
metadata:
  type: feedback
---

Before launching web-research or parallel fan-out agents that hit many domains, give the user a heads-up to switch the Claude Code CLI to AUTO permission mode.

**Why:** In Edit/default permission mode, each new domain triggers a separate approval prompt, which stalls an otherwise unattended run.

**How to apply:** When about to kick off a multi-source web-research run or a swarm of agents doing web fetches, mention the AUTO-mode switch first so the run isn't interrupted by per-domain prompts. CLI-specific.
