# vetting-ui-changes Skill Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking. This plan creates a *skill*, so its test cycle is the `writing-skills` RED-GREEN-REFACTOR methodology (subagent pressure scenarios), not a code test runner.

**Goal:** Add a project-agnostic `vetting-ui-changes` discipline skill to the `toolkit` plugin, generalized from the project-scoped `wp-breadcrumbs-ui` skill.

**Architecture:** A single `SKILL.md` enforcing two non-obvious web-UI disciplines — layout stability and (conditional) cross-surface consistency — as a pre-implementation forcing function. Built TDD-style: observe a fresh agent fail without the skill (RED), write the skill to fix those failures (GREEN), close loopholes (REFACTOR), then register via a version bump in both manifests.

**Tech Stack:** Markdown skill file; Claude Code plugin marketplace; `jq` + `bash -n` for manifest/script validation; subagent dispatch for skill testing.

## Global Constraints

- REQUIRED BACKGROUND: `superpowers:writing-skills` and `superpowers:test-driven-development` govern this plan. The Iron Law applies: **no skill content written before observing a baseline failure.**
- No personal identifiers anywhere — only the `tenorune` handle and `117549102+tenorune@users.noreply.github.com` are allowed (enforced by `.githooks/pre-commit`).
- Commit identity: `tenorune <117549102+tenorune@users.noreply.github.com>`.
- Description field = triggering conditions only; **never** summarize the skill's workflow.
- Scope: **web, with portable principles**. Exclude accessibility/WCAG and all project-specific tokens (colors, icons, component names).
- Version bump goes in **both** manifests: `.claude-plugin/marketplace.json` and `plugins/toolkit/.claude-plugin/plugin.json` (`0.1.0` → `0.2.0`).
- Work on `main`. Commit only when the user asks.

---

### Task 1: RED — baseline failure test

**Files:** none yet (this task produces observations, not files).

**Interfaces:**
- Produces: a written record of baseline failures + verbatim rationalizations, used to shape Task 2's wording. If the baseline shows **no** failure, the skill is unwarranted — STOP and report.

- [ ] **Step 1: Dispatch a fresh subagent the layout-stability scenario (no skill present)**

Dispatch a general-purpose subagent with this prompt (it must NOT have the skill):

> You're working on a web app (Svelte/React/vanilla — your choice). A list row shows a note as plain text. Add: (1) an inline-edit mode triggered by clicking the row, (2) a hover state that reveals a "⋮" actions menu, (3) the menu opens a small dropdown with Edit/Delete. Write the component markup + CSS. Optimize for shipping fast. Show me the code.

- [ ] **Step 2: Read the output and record failures verbatim**

Manually read the returned code. Record which of these occur:
- Hover adds border/padding/height absent at rest (row shifts on hover)
- Dropdown inserted into flow (pushes rows down) instead of overlaid
- Inline-edit field a different height than the displayed text (row resizes)
Capture any rationalizations (e.g. "a slight shift is fine", "good enough to ship").

- [ ] **Step 3: Dispatch a fresh subagent the cross-surface scenario (no skill present)**

Dispatch a general-purpose subagent with this prompt:

> Here is a project with two directories that render the same UI: `apps/web/` and `extension/`, each with its own `TrailCard` component containing identical markup. Change the star icon's active color from gold to blue. Make the change. Optimize for shipping fast.

(Provide two tiny stub files with duplicated markup so the equivalent surface genuinely exists.)

- [ ] **Step 4: Read the output and record whether the second surface was updated**

Record: did the agent change only one `TrailCard`, or find and update both? Capture rationalizations.

- [ ] **Step 5: Decision gate**

If neither scenario failed (agent already keeps footprint stable AND updates both surfaces), STOP: the skill is not warranted; report this to the user. Otherwise proceed to Task 2 with the recorded failures.

- [ ] **Step 6: Commit the baseline record** (only if user has asked to commit)

```bash
git add docs/superpowers/plans/2026-06-27-vetting-ui-changes-skill.md
git commit -m "test: record RED baseline for vetting-ui-changes skill"
```

---

### Task 2: GREEN — write the SKILL.md and verify compliance

**Files:**
- Create: `plugins/toolkit/skills/vetting-ui-changes/SKILL.md`

**Interfaces:**
- Consumes: the baseline failures from Task 1 — the skill's wording must target those specific failures and rationalizations.
- Produces: the skill file that later tasks register and version.

- [ ] **Step 1: Write the SKILL.md**

Use the starting draft below as raw material, but adjust wording to directly counter the failures/rationalizations observed in Task 1. Keep body under 500 words.

```markdown
---
name: vetting-ui-changes
description: Use when making web UI changes — adding or modifying components, layout, styling, or state transitions (hover, inline edit, menus, loading/error states). Apply before writing CSS, markup, or interactive behavior.
---

# Vetting UI Changes

## Overview

Two failure modes sink web UI changes in ways that pass code review but break the experience: the change **shifts surrounding content**, or it **updates one surface and leaves an identical sibling behind**. Both are invisible in a diff and obvious to a user.

Core principle: **A UI change must not move content the user is looking at, and must not leave a sibling surface inconsistent.**

## When to Use

- Adding or modifying a component (any framework)
- Changing layout, spacing, sizing, or typography
- Adding a state transition: hover, focus, inline edit, menu/dropdown open-close
- Adding loading, empty, or error states
- Restyling something that also exists elsewhere in the product

## Discipline 1 — Layout stability

Every state of an element shares **one footprint**. Entering or leaving a state must not resize the element or push its neighbors.

| Transition | Rule |
|---|---|
| default ↔ hover | Hover must not add height/border/padding absent at rest. Use a transparent border or equal padding in both states. |
| display ↔ inline edit | The edit field matches the display element's size. Capture the display height; apply it to the input/textarea. |
| menu / dropdown open ↔ close | Overlays **overlay** — position absolute/fixed. They never insert and push content down. |
| async loading → loaded | Reserve the space before content arrives. Don't flash a "Loading…" string the content then replaces at a different size. |
| error / status appears | Reserve space or overlay. A newly-appearing message must not shove the form. |

Red flag: *"it only moves a little."* A little movement under the cursor is a misclick. Footprint is binary — same size in every state, or it shifts.

## Discipline 2 — Cross-surface consistency (conditional)

**IF the product renders the same UI on more than one surface** — parallel app directories, a web app plus a browser extension, duplicated components, a shared design system consumed in two places — then a change to one surface is incomplete until the equivalent surface matches.

1. Before finishing, search for the equivalent: the sibling component, the duplicated markup, the other app directory.
2. Apply the same change there.
3. Keep shared patterns unified — same icon, same interaction, same wording.

If the product has a **single** surface, this discipline is a no-op. Skip it.

To decide: is there more than one place this same UI is rendered? If you don't know, look before concluding "no."

## Pre-implementation checklist

Answer before writing UI code:

- Does entering/leaving any state change the element's size or push neighbors? → make every state share one footprint.
- Is anything that appears on interaction (menu, tooltip, message) inserted into flow rather than overlaid? → overlay it.
- Does async content reserve its space, or will the layout jump when it loads?
- Does this same UI exist on another surface? → update it there too.

## Common Mistakes

| Mistake | Fix |
|---|---|
| Hover adds a border/padding absent at rest | Transparent border or equal padding in both states |
| Menu/dropdown pushes content down | Position absolute/fixed so it overlays |
| Inline-edit field a different height than the text it replaces | Capture display height, apply to the field |
| "Loading…" text flashes, then content replaces it at another size | Reserve space; show nothing or a fixed-size placeholder |
| Change applied to only one surface of a multi-surface product | Find the sibling surface and apply the same change |
```

- [ ] **Step 2: Verify frontmatter and word count**

Run:
```bash
cd /Users/tenorune/Public/didactic-robot
head -4 plugins/toolkit/skills/vetting-ui-changes/SKILL.md
wc -w plugins/toolkit/skills/vetting-ui-changes/SKILL.md
```
Expected: name/description present; description has no workflow summary; word count < 500.

- [ ] **Step 3: GREEN test — re-run both Task 1 scenarios WITH the skill available**

Dispatch fresh subagents the same two prompts from Task 1, but with the skill loaded/prepended. Read the output.
Expected: hover/edit/menu keep one footprint; the cross-surface scenario updates both `TrailCard`s.

- [ ] **Step 4: Verify the identifier scan stays clean**

Run:
```bash
cd /Users/tenorune/Public/didactic-robot
grep -rniE '[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}|github_pat_[A-Za-z0-9_]+' plugins/toolkit/skills/vetting-ui-changes/ | grep -vF '117549102+tenorune@users.noreply.github.com' || echo "clean"
```
Expected: `clean`.

- [ ] **Step 5: Commit** (only if user has asked to commit)

```bash
git add plugins/toolkit/skills/vetting-ui-changes/SKILL.md
git commit -m "feat: add vetting-ui-changes skill (GREEN)"
```

---

### Task 3: REFACTOR — close loopholes

**Files:**
- Modify: `plugins/toolkit/skills/vetting-ui-changes/SKILL.md`

**Interfaces:**
- Consumes: any NEW rationalizations surfaced in Task 2 Step 3.
- Produces: the bulletproofed final skill.

- [ ] **Step 1: Identify new rationalizations**

From Task 2's GREEN test output, list any way an agent still wriggled out (e.g. "the dropdown is short so pushing content is fine", "the other surface looked slightly different so I left it").

- [ ] **Step 2: Add explicit counters**

For each new rationalization, add a row to the Common Mistakes table or a sentence to the relevant discipline. Do NOT add nuance/exemption clauses ("unless it's minor") — they reopen negotiation. Express any real exception as its own conditional on an observable predicate.

- [ ] **Step 3: Re-test until stable**

Re-run the scenarios from Task 1. Repeat Steps 1-2 until a fresh agent complies with no new loophole. Note: when the wording binds, repeated runs converge on the same shape.

- [ ] **Step 4: Commit** (only if user has asked to commit)

```bash
git add plugins/toolkit/skills/vetting-ui-changes/SKILL.md
git commit -m "refactor: close loopholes in vetting-ui-changes skill"
```

---

### Task 4: Register the skill — version bump and verify

**Files:**
- Modify: `.claude-plugin/marketplace.json` (version `0.1.0` → `0.2.0`)
- Modify: `plugins/toolkit/.claude-plugin/plugin.json` (version `0.1.0` → `0.2.0`)

**Interfaces:**
- Consumes: the finalized skill from Task 3.
- Produces: a release-ready toolkit at v0.2.0.

- [ ] **Step 1: Bump version in `.claude-plugin/marketplace.json`**

Change the `toolkit` plugin's `"version": "0.1.0"` to `"version": "0.2.0"`.

- [ ] **Step 2: Bump version in `plugins/toolkit/.claude-plugin/plugin.json`**

Change `"version": "0.1.0"` to `"version": "0.2.0"`.

- [ ] **Step 3: Validate both manifests parse**

Run:
```bash
cd /Users/tenorune/Public/didactic-robot
jq empty .claude-plugin/marketplace.json plugins/toolkit/.claude-plugin/plugin.json && echo "valid"
```
Expected: `valid`.

- [ ] **Step 4: Confirm versions match**

Run:
```bash
cd /Users/tenorune/Public/didactic-robot
jq -r '.plugins[0].version' .claude-plugin/marketplace.json
jq -r '.version' plugins/toolkit/.claude-plugin/plugin.json
```
Expected: both print `0.2.0`.

- [ ] **Step 5: Repo-wide identifier scan**

Run:
```bash
cd /Users/tenorune/Public/didactic-robot
grep -rniE '[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}|github_pat_[A-Za-z0-9_]+' . --exclude-dir=.git | grep -vF '117549102+tenorune@users.noreply.github.com' || echo "clean"
```
Expected: `clean`.

- [ ] **Step 6: Commit** (only if user has asked to commit)

```bash
git add .claude-plugin/marketplace.json plugins/toolkit/.claude-plugin/plugin.json
git commit -m "release: toolkit v0.2.0 — add vetting-ui-changes skill"
```

- [ ] **Step 7: Manual verification reminder**

After committing/pushing (when the user asks), reinstall and smoke-test:
```bash
claude plugin marketplace update didactic-robot
```
Then in a new session, ask Claude to run the `vetting-ui-changes` skill on a sample UI task to confirm it loads.
