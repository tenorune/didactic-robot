# Design: `vetting-ui-changes` skill

Date: 2026-06-27
Status: Approved (brainstorming) — pending RED baseline before implementation

## Origin

Generalized from a project-scoped skill, `wp-breadcrumbs-ui` (Wikipedia Breadcrumbs
project; the source copy lives at `~/Downloads/wp-breadcrumbs-ui/SKILL.md`). That skill
bundled three disciplines — accessibility/WCAG, layout stability, and cross-surface
consistency — heavily saturated with project specifics (named principles, color palette,
Lucide icon map, component names, extension+PWA duality).

Only two of the three disciplines are worth generalizing into the project-agnostic
`toolkit` plugin:

- **Layout stability** — a non-obvious discipline agents routinely skip.
- **Cross-surface consistency** — likewise non-obvious.

Accessibility is **deliberately excluded**: it is well-documented standard practice that
agents already half-know and that linters/tools cover, so per `writing-skills`' "don't
create for standard practices well-documented elsewhere," it does not earn a skill here.
The original `wp-breadcrumbs-ui` stays project-scoped and unchanged.

## Purpose

A discipline skill that forces an agent to vet a **web** UI change against two non-obvious
failure modes **before writing code**: layout instability and cross-surface
inconsistency. The value is the **forcing function** (consult the checklist *before*
writing UI), not the facts themselves.

## Scope

- **Technology breadth:** Web, with portable principles. Lead with concrete web examples
  (HTML/CSS/JS, any framework) but state each principle platform-neutrally so it transfers
  to native/desktop. Does not claim to cover native/TUI specifics.
- **Excludes:** accessibility/WCAG; all project-specific design tokens (colors, icons,
  component names).

## Frontmatter (SDO — triggers only, no workflow summary)

- `name: vetting-ui-changes`
- `description: Use when making web UI changes — adding or modifying components, layout,
  styling, or state transitions (hover, inline edit, menus, loading/error states). Apply
  before writing CSS, markup, or interactive behavior.`

## Body structure

1. **Overview** — core principle: a UI change must not shift surrounding content, and must
   not leave a sibling surface behind.
2. **Discipline 1 — Layout stability.** Every state shares one footprint. Enumerate the
   trigger transitions (default↔hover, display↔edit, menu open/close, async
   loading→loaded, error). Rules: overlays overlay (absolute/fixed), never insert; edit
   fields match display size; reserve space for async content. Web examples, portable
   wording.
3. **Discipline 2 — Cross-surface consistency (conditional).** IF the product has >1 UI
   surface (parallel app dirs, duplicated components, web+extension), find the equivalent
   and apply the same change; keep shared patterns unified. **No-op for single-surface
   projects.** Keyed to the observable "more than one surface" predicate.
4. **Discipline 3 — Deliberate destruction.** Destructive actions (delete/remove/
   disconnect/reset) need a confirmation that NAMES the specific target and uses an
   action-specific button label (not generic `OK`/native `confirm()`); never destroy on a
   single click. (Added in the 2026-06-27 guidelines round — see Revision below.)
5. **Discipline 4 — Mobile readiness (conditional).** IF the UI runs on phones: text
   inputs ≥ 16px (else iOS zooms on focus), tap targets ≥ ~44px, suppress tap-highlight /
   double-tap delay on custom controls. **No-op for desktop-only products.** (Added in the
   guidelines round.)
6. **Pre-implementation checklist** — the forcing function: a short yes/no list to answer
   before writing UI code (one line per discipline).
7. **Common Mistakes table** — generic rows (edit textarea ≠ display height; loading-text
   flash; reveal via `display:none→flex`; change applied to only one surface; destructive
   action with no confirmation / unnamed target / generic button; input `font-size` < 16px).

## Form decisions (per `writing-skills` — "Match the Form to the Failure")

- **Layout stability** is a *discipline* failure (agent knows better, ships shift under
  pressure) → checklist + red-flags list + a rationalization table **built from the RED
  baseline** (not invented up front).
- **Cross-surface** is *conditional* discipline → keyed to the observable predicate
  ("more than one surface"), no nuance/exemption clauses.

## Location & versioning

- File: `plugins/toolkit/skills/vetting-ui-changes/SKILL.md`
- Bump version in **both** manifests (`.claude-plugin/marketplace.json` and
  `plugins/toolkit/.claude-plugin/plugin.json`), then
  `claude plugin marketplace update didactic-robot` + reinstall.
- Optional, out of scope unless requested: add a one-line back-reference from the original
  `wp-breadcrumbs-ui` to this generic skill.

## Testing (Iron Law: no skill without a failing test first)

1. **RED baseline:** dispatch a fresh subagent a tempting web UI task *without* the skill;
   observe whether it ships layout-shifting markup or forgets a second surface. Capture
   exact rationalizations.
2. **GREEN:** write the SKILL.md addressing those specific failures; re-run the scenario;
   verify compliance.
3. **REFACTOR:** close new loopholes (rationalization table, red flags) until bulletproof.

The RED baseline both justifies the skill and shapes its wording. If the baseline does not
exhibit the failure, the skill is not warranted and we stop.

## Revision — 2026-06-27 guidelines round

After the initial 2-discipline build (layout stability + cross-surface) passed RED/GREEN, the
project's source design doc
(`github.com/tenorune/wikipedia-breadcrumbs/.../ui-ux-guidelines.md`) was mined for further
generic candidates. Each was RED-baseline-tested before inclusion (same Iron Law):

- **Deliberate destruction → ADDED (Discipline 3).** Baseline: agents deleted on a single
  click with no confirmation, or confirmed without naming the target, or used native
  `confirm()`. GREEN: with the discipline, a haiku agent built a custom modal naming the
  exact item with a `Delete` button. Proven.
- **Mobile readiness → ADDED (Discipline 4, conditional).** Baseline: in non-mobile-framed
  tasks, agents consistently used 14–15px inputs (latent iOS-zoom failure). GREEN: with the
  discipline, a haiku agent used `font-size: 16px` + 44px targets *without being told it was
  mobile*. Proven.
- **Interaction containment (one-overlay-at-a-time / dismiss-guard) → REJECTED.** Baseline:
  both haiku and sonnet already handled `stopPropagation` + one-at-a-time + outside-click
  close unprompted. Not reproduced — same outcome as the original hover/dropdown warnings.
  Excluded on evidence.

Also borrowed the source doc's stable-framing line into Discipline 1 ("the screen should
never shift, jump, or flash in response to a user action unless the user asked for content
to change"). Excluded as project-specific/opinionated: truthful-status (sync/offline
semantics), visual hierarchy, auto-save/no-Save-Cancel, progressive disclosure, time-as-
language.

Result: a 4-discipline skill (~950 words). Word count exceeds the <500 aim, accepted because
each discipline is proven and on-demand-loaded; flagged for final review.
