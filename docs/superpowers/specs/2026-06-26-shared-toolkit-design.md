# Design: `didactic-robot` — a private, cross-harness store for skills, prompts, and memory

**Date:** 2026-06-26
**Status:** Approved (design); implementation plan to follow

## Problem

Skills, output styles, reusable instruction text, and durable "memory" facts currently
live in scattered, harness-specific locations (`~/.claude/skills/`, individual project
repos, ad-hoc notes). They have to be recreated per context. The goal is a single private
source of truth that can be authored once and consumed from multiple harnesses — starting
with the Claude Code CLI and Claude Code on the Web — without duplicating the asset itself.

## Constraints

- **No personal identifiers anywhere.** No real name, real email, or email-derived tokens
  in names, docs, commit messages, examples, or code. The GitHub account handle and the
  GitHub noreply email are explicitly allowed where functionally required.
- **Commit identity:** all commits authored as `tenorune
  <117549102+tenorune@users.noreply.github.com>`.
- **No skill duplication.** A given skill/style is authored exactly once.

## Key findings that shape the design

Confirmed against current Claude Code docs (code.claude.com/docs — Claude Code on the web,
Skills, Plugin marketplaces):

- A plugin marketplace **can be a private GitHub repo**. CLI installs use existing git
  credentials (`gh auth`).
- **Consumption is driven entirely by the Cloud environment Setup Script** (configured once
  per cloud environment), NOT by anything committed to project repos. The setup script runs
  install/clone commands against the environment's `~/.claude`, and the running cloud session
  reads that same home directory — so both `claude plugin install …` and `git clone … into
  ~/.claude/skills/` work. The user has verified this approach in current Web environments.
- **Project repos stay clean.** No project repo references this toolkit, its repo, or its
  marketplace in any committed file. This is a hard requirement, not just a preference.

## Approach

Make `didactic-robot` itself a **private Claude Code plugin marketplace** exposing a single
plugin named **`toolkit`** that bundles the portable assets. Both harnesses consume it with
the same commands; only *where* those commands run differs.

- **CLI (local):** run once —
  `claude plugin marketplace add tenorune/didactic-robot` then
  `claude plugin install toolkit@didactic-robot` (or the `/plugin` UI equivalent).
- **Web (cloud):** put the same commands in the **Cloud environment Setup Script**, so every
  session in that environment gets the toolkit. Nothing is added to any project repo. A
  reference setup script lives in the repo (see `setup/setup-script.sh`). Example shape:

  ```bash
  #!/bin/bash
  set -e
  claude plugin marketplace add tenorune/didactic-robot
  claude plugin install toolkit@didactic-robot
  echo "Toolkit ready."
  ```

## Repository layout

```
didactic-robot/
├── .claude-plugin/
│   └── marketplace.json          # marketplace manifest; lists the `toolkit` plugin
├── plugins/
│   └── toolkit/
│       ├── .claude-plugin/
│       │   └── plugin.json        # plugin manifest (name, version, description)
│       ├── skills/                # portable skills (one dir per skill, each with SKILL.md)
│       │   └── shared-memory/
│       │       └── SKILL.md        # reads ../../memories/*.md on demand
│       └── output-styles/         # reusable output styles
├── memories/                      # curated markdown fact-files (preferences, decisions, refs)
│   └── MEMORY.md                  # index of the fact-files
├── instruction-blocks/           # reusable CLAUDE.md snippets (a library to paste / @import)
├── setup/
│   └── setup-script.sh            # reference Cloud-env Setup Script (install commands)
├── docs/
│   └── superpowers/specs/         # this spec and future specs
└── README.md                      # what this repo is + how to consume it (CLI + Web)
```

## Asset types and how each is consumed

| Asset | Lives in | CLI | Web | Notes |
|-------|----------|:---:|:---:|-------|
| Skills | `plugins/toolkit/skills/` | ✅ | ✅ | Namespaced `toolkit:<skill>`; auto-discovered once the plugin is installed via the setup script |
| Output styles | `plugins/toolkit/output-styles/` | ✅ | ✅ | Selected via `/output-style`; bundled in the plugin |
| Instruction blocks | `instruction-blocks/` | ✅ | ✅ | Plain markdown library; pasted or `@import`ed into a CLAUDE.md. Not auto-loaded by design |
| Memories | `memories/` + `shared-memory` skill | ✅ | ✅ | Files are inert; the `shared-memory` skill makes them discoverable and reads them on demand |

### The `shared-memory` skill

A thin skill whose job is: when durable cross-project context might be relevant, read
`memories/MEMORY.md` (the index) and pull in the specific fact-file(s) needed. This is the
chosen vehicle because raw files don't auto-load in either harness, but a skill does, and
skills behave identically in CLI and Web. It keeps "memory" conceptually distinct from
"skills" while remaining reachable everywhere. (This is separate from, and does not replace,
the CLI's native per-project memory under `~/.claude/projects/.../memory/`.)

## Bootstrap (the gathering step)

1. **Inventory** existing assets and produce a migration list:
   - `~/.claude/skills/handing-off-a-session` (and any other personal skills)
   - Existing output styles
   - Global CLAUDE.md rules → candidates for `instruction-blocks/`
   - Skills / prompts embedded in other project repos
2. **Migrate** each into the structure above, scrubbing any personal identifiers during the move.
3. **Wire up** the marketplace + plugin manifests so an install actually resolves.
4. **Verify** end-to-end: install in the CLI; run the same setup-script commands in a cloud
   environment and confirm the toolkit loads with no project-repo changes.

## Out of scope (deferred)

- **`/insights` session analysis.** Mining past sessions to improve workflows is a separate
  later effort. A `docs/` placeholder will record the intent so it isn't lost.

## Open / to confirm during planning

- Final `plugin.json` / `marketplace.json` field values and versioning scheme.
- Whether instruction-blocks should also be surfaced via a skill, or remain a paste/import library.
- Exact contents of the first migration batch (depends on the inventory).

## Success criteria

- A skill authored once in this repo is usable, unmodified, in both the CLI and a Web session.
- No personal identifiers appear anywhere in the repo or its history.
- Using the toolkit in Web requires only the Cloud environment Setup Script — **no project repo
  ever references the toolkit, its repo, or its marketplace.**
