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

- Web cloud sessions **do not** read personal `~/.claude/skills/`. They read only:
  (a) project skills committed to the session repo's `.claude/skills/`, and
  (b) plugin skills from a marketplace declared in the repo's `.claude/settings.json`.
- A plugin marketplace **can be a private GitHub repo**. CLI installs use existing git
  credentials (`gh auth`); Web auto-updates authenticate via a `GITHUB_TOKEN`/`GH_TOKEN`
  env var set in the cloud session environment.
- There is **no global "always load my personal skills"** for Web. The only repetition is a
  small committed `.claude/settings.json` stanza per project repo — a dependency
  *declaration*, not a copy of any skill.

## Approach

Make `didactic-robot` itself a **private Claude Code plugin marketplace** exposing a single
plugin named **`toolkit`** that bundles the portable assets.

- **CLI:** install once —
  `/plugin marketplace add tenorune/didactic-robot` then `/plugin install toolkit`.
- **Web:** in each project repo to use it in, commit a ~6-line `.claude/settings.json`
  declaring this marketplace in `extraKnownMarketplaces` and enabling `toolkit@didactic-robot`;
  set `GITHUB_TOKEN` in the cloud session env for the private pull.

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
├── templates/
│   └── project-settings.json      # the stanza to drop into a consuming repo's .claude/
├── docs/
│   └── superpowers/specs/         # this spec and future specs
└── README.md                      # what this repo is + how to consume it (CLI + Web)
```

## Asset types and how each is consumed

| Asset | Lives in | CLI | Web | Notes |
|-------|----------|:---:|:---:|-------|
| Skills | `plugins/toolkit/skills/` | ✅ | ✅ | Namespaced `toolkit:<skill>`; auto-discovered once plugin installed/declared |
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
4. **Verify** end-to-end: install in the CLI; declare + load in a throwaway Web-style project repo.

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
- Adding the toolkit to a new project for Web use requires only the small committed settings stanza — no skill copying.
