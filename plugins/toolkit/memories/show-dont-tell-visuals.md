---
name: show-dont-tell-visuals
description: For a visual decision, offer to generate a real mockup rather than describing it in prose
metadata:
  type: feedback
---

For a visual or design decision, a real artifact beats a prose description — generate a mockup (e.g. an SVG rendered to PNG: `qlmanage -t -s <px> -o . file.svg`, then read the PNG) so the user can actually see the options.

**Always ask first.** Don't silently spin up mockups — offer ("want me to mock these up?") and wait, because rendering is a deliberate, potentially token-heavy step. Once the user opts in, show the options rather than narrating them.

**Why:** Mockups have repeatedly been decisive on design forks where prose stalled. Related: [[structured-choices]], [[manual-visual-gate]].
