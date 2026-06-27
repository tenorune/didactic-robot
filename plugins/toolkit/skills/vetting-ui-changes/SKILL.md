---
name: vetting-ui-changes
description: Use when making web UI changes — adding or modifying components, inline editing, revealed/hover/async content, destructive actions (delete/remove/disconnect), or UI used on phones. Apply before writing CSS, markup, or interactive behavior.
---

# Vetting UI Changes

## Overview

These web UI failures pass code review but break the experience — invisible in a diff, obvious to a user. Vet every change against the disciplines below before writing code.

## When to Use

- Inline edit: swapping displayed text for an input/textarea
- Revealing content on interaction or hover (actions, menus, tooltips); loading / saving / empty / error states
- Restyling something that also exists elsewhere in the product
- Adding a destructive action (delete, remove, disconnect, reset)
- Anything that will be used on phones

## Discipline 1 — Layout stability

**A region's footprint must not change when its state changes** — the screen should never shift, jump, or flash in response to a user action unless the user asked for content to change. The reliable way this breaks is **swapping one element for another of a different size** — that is the failure to hunt for.

When you replace or reveal an element, the new state must occupy the same box as the old:

- **Inline edit / element swap.** The input or textarea you swap in must match the box of the text it replaces — same font-size, line-height, and *total* height including padding and border. A bare `<input>`, or a textarea with `min-height`, is taller than the text it replaced and grows the row. Match the box, or pin the container's height so the swap cannot resize it.
- **Revealed / async content.** Reserve the space before it appears. Don't reveal with `display: none → block/flex` (that reflows neighbors), and don't let a "Saving…" / "Loading…" swap change the region's size. Toggle `opacity`/`visibility` on an already-laid-out element, or keep a fixed-size slot.

Red flag: *"it only moves a little."* Footprint is binary — same box in every state, or it shifts. A little movement under the cursor is a misclick.

(You almost certainly already overlay menus/dropdowns with `position: absolute` and reveal hover affordances with `opacity` — keep doing that. The element swaps above are where shift sneaks in unnoticed.)

## Discipline 2 — Cross-surface consistency (conditional)

**IF the same UI is rendered on more than one surface** — parallel app directories, a web app plus a browser extension, duplicated components, a shared design system consumed in two places — then a change to one surface is incomplete until the equivalent matches.

1. Before finishing, find the equivalent: the sibling component, the duplicated markup, the other app directory. Being handed one file to edit is not evidence there is only one copy — grep for it.
2. Apply the same change there.
3. Keep shared patterns unified — same icon, same interaction, same wording.

Single-surface product? This is a no-op; skip it. If you don't know whether a second surface exists, look before concluding "no."

## Discipline 3 — Deliberate destruction

**Any action that deletes, removes, disconnects, or resets data needs a deliberate confirmation.** Agents routinely wire a delete button straight to removal, or confirm with a prompt that doesn't say what is being destroyed.

- **Confirm first.** Never destroy on a single click.
- **Name the target.** "Are you sure?" is not enough — "Delete *Quarterly report*?" / "Disconnect the Google account shown?" so the user sees exactly what is affected.
- **Action-specific button.** The confirm button reads `Delete` / `Disconnect`, never `OK` / `Yes`.
- Prefer a custom in-app confirmation over native `confirm()` when the product has its own UI.

## Discipline 4 — Mobile readiness (conditional)

**IF the UI runs on phones** (most web apps do), handle the failure that never shows on a desktop dev machine: **text inputs need `font-size: 16px` or larger** — anything smaller makes iOS zoom the page on focus, and agents default to 14px. (Standard mobile hygiene applies too: tap targets ≥ ~44px; on custom controls suppress the tap-highlight flash and double-tap delay.)

Desktop-only product? Skip it.

## Pre-implementation checklist

Before writing UI code:

- Does any state swap one element for another? → the replacement must occupy the same box (size + padding + border), or pin the container's height.
- Does anything appear on interaction or after an async call? → reserve its space; don't reveal via `display: none → …`.
- Does this same UI exist on another surface? → grep for it; update every copy.
- Does this action delete or remove data? → confirm first, name the target, action-specific button.
- Will this run on phones? → text inputs ≥ 16px, tap targets ≥ ~44px.

## Common Mistakes

| Mistake | Fix |
|---|---|
| Inline-edit `<input>`/`<textarea>` taller than the text it replaced → row grows | Match font/line-height and total box height, or pin container height |
| `min-height` textarea swapped in for a one-line label | Size the field to the displayed text; grow only as the user types |
| Revealed actions use `display: none → flex` → content reflows | Reserve the slot; toggle `opacity`/`visibility` on an in-flow element |
| "Saving…"/"Loading…" text swaps in at a different size → region jumps | Fixed-size status slot, or overlay it |
| Changed one surface, left an identical duplicate stale | grep for the component/markup; update every copy |
| Destructive action fires on a single click, no confirmation | Confirm first; never wire delete straight to removal |
| Confirmation doesn't name what's affected ("Are you sure?") | Name the target: "Delete *Quarterly report*?" |
| Generic `OK` / native `confirm()` for a destructive action | Action-specific label (`Delete`); custom in-app confirm |
| Input `font-size` < 16px → iOS zooms the page on focus | Set text inputs to `font-size: 16px` |
