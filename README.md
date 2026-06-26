# didactic-robot

A private, cross-harness store for project-agnostic Claude Code assets — **skills**, **output
styles**, reusable **instruction blocks**, and **shared memory** — authored once and used across
the Claude Code CLI and (eventually) Claude Code on the Web.

Packaged as a Claude Code **plugin marketplace**: this repo exposes one plugin, **`toolkit`**.

## Status

- ✅ **Local CLI install works** (private repo, via your `gh` credentials).
- ⏳ **Web (cloud) install is an OPEN DECISION.** A *private* repo cannot be auto-loaded in a web
  session without committing files into each project repo (which a project rule forbids). The
  clean fix is to make this repo **public** (it's built to contain zero personal identifiers, so
  that's safe). See the spec section *"Cloud (Web) install: findings + OPEN DECISION"*.
- 🌱 Contents are still a **seed**: a smoke-test skill only. Migrating real skills / output styles
  / instruction-blocks / shared-memory is the next build phase (see the spec).

## Layout

```
.claude-plugin/marketplace.json     # marketplace manifest (lists the `toolkit` plugin)
plugins/toolkit/                     # the plugin
  .claude-plugin/plugin.json
  skills/toolkit-smoke-test/         # install-verification skill (seed)
setup/setup-script.sh                # local CLI installer (+ curated external skills)
docs/superpowers/specs/              # design spec — source of truth
docs/HANDOFF.md                      # forward-first handoff
```

## Setup

### Local (CLI) — works today
Requires the `claude` CLI and `gh auth login` with access to this private repo.

```bash
gh repo clone tenorune/didactic-robot
bash didactic-robot/setup/setup-script.sh
```

Or directly:

```bash
claude plugin marketplace add tenorune/didactic-robot
claude plugin install toolkit@didactic-robot
```

### Web (cloud) — pending the open decision
Do not assume the setup script works in a web session while the repo is private (it will fail to
clone this repo through the session git proxy). Resolve the public-vs-private decision first; if
the repo is made public, the same commands work as the environment's **Setup Script**.

### Verify
Ask Claude to **run the `toolkit-smoke-test` skill**; a correct install replies with a
confirmation line naming the harness.

## Conventions

- **No personal identifiers anywhere** — no real name, email, or email-derived tokens in names,
  docs, commits, examples, or code. The GitHub handle `tenorune` and the GitHub noreply email are
  the only allowed identifiers.
- **Commits** are authored as `tenorune <117549102+tenorune@users.noreply.github.com>`.
- Curated **external** skills are *referenced* from upstream (not vendored) and installed
  best-effort, so a broken upstream never blocks the core toolkit.
