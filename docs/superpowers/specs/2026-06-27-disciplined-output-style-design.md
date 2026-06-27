# Design — `disciplined` output style

**Status:** designed, approved (voice A + recommended keep-set). First output style in the toolkit;
creates `plugins/toolkit/output-styles/`.

## Purpose

An output style is **system-prompt-level and always-on when selected**. This one bakes the operator's
cross-project *interaction posture and restraint defaults* into the system prompt so they govern every
turn without depending on a memory/skill trigger firing. It is the always-on companion to the
`shared-memory` skill (the pull-on-demand reader for the broader fact-set).

## Placement & manifest

- File: `plugins/toolkit/output-styles/disciplined.md` (default `output-styles/` location — no manifest
  override needed). Auto-discovered in the style picker on install.
- No `plugin.json` / `marketplace.json` change required; **no version bump** unless the operator asks.

## Frontmatter (the two load-bearing choices)

- `keep-coding-instructions: true` — augments Claude Code's engineering instructions, does not replace
  them. This is a behavior layer, not a persona swap. Required because **only one style is active at a
  time** — when this is the active style, nothing else style-level is layered underneath it, so it must
  stand on its own atop the coding instructions.
- `force-for-plugin: false` — **opt-in via the picker, never auto-applied.** A toolkit installed across
  every project must not silently swap (and thereby evict) whatever style a project had chosen. Forcing
  it would contradict the operator-in-control thesis the style itself encodes.

## Selection principle (why this content and not the rest)

The test for inclusion is not "is it a good convention" but **"does it govern every turn regardless of
the task?"** That splits the toolkit's content into three homes; only the first is this style:

- **In the style — always-on posture/restraint:** `execution-cadence`, `structured-choices`,
  `evidence-before-claims`, the restraint cluster (`dont-push-to-merge` + `commit-push-only-when-asked`
  + `version-bumps-ask-first`), and `manual-visual-gate` (generalized to "done is the operator's call").
- **Stays in skills — task-triggered procedures:** `vetting-ui-changes`, `handing-off-a-session`,
  `release-process`, `pre-release-secret-scan`, `rebuild-before-manual-test`, `web-research-auto-mode`.
  Dead weight on most turns, and already fire on their own triggers — duplicating them as always-on
  prose fights the skill system.
- **Stays in memory — on-demand reference facts:** `atomic-write-data-files`,
  `publishable-tooling-defaults`, `no-telemetry`, `pristine-commits`, `docs-lessons-file`,
  `ship-safe-part-first`. Coding-decision knowledge, recalled when relevant, not asserted every turn.
- **Out entirely (safety):** `git-commit-identity`, `no-memory-rules-in-repo` — identity/leak rules
  belong in memory + the pre-commit hook, never in a style the operator can toggle off.

`branch-workflow` is deliberately excluded: it is a situational workflow procedure (per-repo integration
model), not always-on posture.

## Content & voice

Voice **A — principle + why**: ~5 principles, each with a one-clause rationale, under a single thesis
header ("an operator who drives the loop"). Principled instructions with a reason generalize better to
unanticipated turns than bare imperatives, and read as a coherent posture rather than a lint list. A
scope comment in the file states what is deliberately excluded, so a future session does not "complete"
the style by dumping skills/memory content into it.

The five principles: terse-cue momentum / effort-to-stakes; bounded choices; OBSERVED-vs-UNKNOWN
evidence; no unprompted commit/push/bump/merge + no merge-nudging; "done" is the operator's call.

## Verification

- File parses as frontmatter + body (valid YAML frontmatter, known fields only).
- Manifests unchanged: `jq empty .claude-plugin/marketplace.json plugins/toolkit/.claude-plugin/plugin.json`.
- Identifier scan stays empty (generic detector, filters in only the allowed noreply).
- Live confirmation deferred to the operator: select via `/config` → Output style after install +
  restart (a live session pins its plugin-cache snapshot). The `/output-style` command was removed in
  CLI v2.1.91; if the style isn't listed, `/reload-plugins` then reopen `/config`.

## Out of scope / deferred

- README/HANDOFF updates documenting the new asset type — do when the operator asks.
- Any second output style (terse-only, explanatory) — not built; this is the first slot only.
