---
name: publishable-tooling-defaults
description: Build publish-ready by default — env-based config, no secrets in code, vendor-agnostic
metadata:
  type: feedback
---

The user releases most tooling publicly, so build it publish-ready from the start:

- **Env-based config.** Settings come from environment variables / a `.env` file, with a committed `.env.example` documenting them. Don't hardcode configurable values.
- **No secrets in code.** API keys, tokens, and credentials are never committed — load them from the environment. (Related: [[git-commit-identity]] for the no-personal-identifiers rule.)
- **Vendor-agnostic.** Avoid hardcoded lock-in to a single provider where reasonable — prefer portable, standard interfaces (e.g. an OpenAI-compatible API surface) so the tool isn't bound to one vendor.
