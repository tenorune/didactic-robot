---
name: runtime-agnostic-core
description: Keep core logic free of platform/runtime specifics; isolate host bindings at thin edges
metadata:
  type: feedback
---

Keep the core logic of a tool independent of any one runtime, platform, or host. Push platform-specific bindings — filesystem, network, OS, host APIs — out to thin edges/adapters, so the core runs anywhere and can be tested in isolation.

**Why:** A core entangled with one runtime can't be ported, reused, or tested without dragging that runtime along. Tools meant to run across environments (e.g. a CLI and a web build) depend on the core staying neutral.

**How to apply:** Define the core in terms of plain inputs/outputs and injected dependencies, not direct calls to host APIs. Adapt at the boundary — one small layer per platform. When a platform detail leaks into the core, treat it as a design smell and push it outward. Prefer reusable, modular scaffolding over one-offs when more pieces are likely, and lean on a platform's native capability before adding new infrastructure to satisfy a requirement. Related: [[publishable-tooling-defaults]], [[ship-safe-part-first]].
