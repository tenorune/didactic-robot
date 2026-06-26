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
- **Web (cloud):** NOT settled while the repo is private — see "Cloud (Web) install: findings +
  OPEN DECISION" below. A private repo cannot be auto-loaded in Web without per-repo committed
  files; making the repo public makes the Setup Script path work cleanly. This is the open
  decision blocking the Web story.

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
│   └── setup-script.sh            # canonical "load everywhere" manifest: toolkit + curated externals
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
| External skills (others') | referenced in `setup/setup-script.sh` | ✅ | ✅ | NOT copied. The setup script installs them from upstream (marketplace plugin, or `git clone` into `~/.claude/skills/`) so they update at the source and keep attribution |

### External skills — "load everywhere" via the setup script

Key skills authored by others that should be present in every environment are **referenced
from upstream, not vendored.** `setup/setup-script.sh` is the single canonical manifest of
what loads everywhere: it installs the `toolkit` plugin and then each curated external source.
Two reference styles are supported per entry:

- **Marketplace plugin:** `claude plugin marketplace add <owner>/<repo>` + `claude plugin install <plugin>@<marketplace>`.
- **Loose skill repo:** `git clone <repo> ~/.claude/skills/<name>`.

Because the same script runs in the CLI and in cloud environments, a skill added to the list
appears everywhere with one edit. Rationale for referencing over copying: upstream updates flow
through automatically and original authorship/licensing stays intact. Initial curated set
(carried over from the user's existing setup): `obra/superpowers-marketplace` (plugin) and
`BehiSecc/VibeSec-Skill` (loose repo).

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
   - The curated set of external (others') skills to load everywhere → entries in `setup/setup-script.sh`
2. **Migrate** each into the structure above, scrubbing any personal identifiers during the move.
3. **Wire up** the marketplace + plugin manifests so an install actually resolves.
4. **Verify** end-to-end: install in the CLI; run the same setup-script commands in a cloud
   environment and confirm the toolkit loads with no project-repo changes.

## Cloud (Web) install: findings + OPEN DECISION (2026-06-26)

A long spike mapped exactly how Claude Code on the Web reaches GitHub. Conclusions:

- **Local CLI from the private repo — WORKS.** `claude plugin marketplace add
  tenorune/didactic-robot` + `claude plugin install toolkit@didactic-robot` (uses local `gh`
  credentials). This is the supported local path and `setup/setup-script.sh` does it.
- **Web cloud — the private repo CANNOT be auto-loaded without per-repo committed files.**
  The harness exposes three places to act, each with a hard limit for a *private* repo:
  - **Setup Script (env-level, pollution-free):** runs as `root` *before* the session, has **no
    `GH_TOKEN`**, and its git goes through a per-session proxy scoped to the *connected* repo —
    so cloning a different private repo 403s. (A *public* repo clones fine here.) Anything it
    writes to `~/.claude` is wiped by the harness re-init that runs afterward.
  - **`/session-start-hook` (project hook):** the built-in command writes a **committed**
    `<repo>/.claude/hooks/session-start.sh`. Runs in-session (has `GH_TOKEN`, can install the
    private toolkit via REST tarball) — but it's a committed file in every repo, which the
    no-identifiers / no-toolkit-refs rule forbids.
  - **User-level `~/.claude/settings.json` hook:** not honored (harness manages `~/.claude`).
- A *public* repo sidesteps all of this: the Setup Script installs it before the skill registry
  builds → native skills, no token, no hooks, no project files.

Useful facts discovered: web sessions set `CLAUDE_CODE_REMOTE=true` and `CLAUDE_PROJECT_DIR`;
the REST API (`api.github.com/.../tarball`, `Authorization: Bearer $GH_TOKEN`) bypasses the git
proxy and works **in-session**; the git proxy rewrites `https://github.com/` →
`http://local_proxy@127.0.0.1:PORT/git/` (see `~/.claude` memories for the full log).

**OPEN DECISION (blocks finalizing the Web story):** pick one —
1. **Make the repo PUBLIC** + Setup Script install. *Recommended.* Clean, deterministic, native
   skills, no token/hooks/project-files. The no-identifiers rule exists to make this safe.
2. **Private + Setup-Script-injected *uncommitted* project hook** (`<repo>/.claude/hooks/…`,
   gitignored). Keeps it private; fragile (timing/persistence) and leaves untracked files.
3. **Private + manual in-session install** each session (REST tarball).
4. **Private, CLI-only** — auto-loads locally; install on demand in Web.

The spike artifacts (`toolkit` plugin + `toolkit-smoke-test` skill) remain as the seed.

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
- **No project repo ever references the toolkit, its repo, or its marketplace in a committed
  file.** (Hard rule; constrains the Web install path — see the OPEN DECISION.)
- Using the toolkit in Web works via the chosen install path (pending the open public-vs-private
  decision), verified in a real cloud environment.
