# Design: `didactic-robot` — a private, cross-harness store for skills, prompts, and memory

**Date:** 2026-06-26
**Status:** Approved (design). Web-install decision **RESOLVED 2026-06-26 → CLI-ONLY; repo stays
PRIVATE; Claude Code on the Web is out of scope** (the cloud Setup Script phase 403s every clone —
verified; see below). A brief public-repo experiment was tried and reverted. Implementation plan
to follow, scoped to the CLI.

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
- **Web (cloud):** OUT OF SCOPE (2026-06-26). Empirically, the cloud Setup Script phase 403s
  **every** clone — own/other-owner, public/private, raw `git clone` and `claude plugin
  marketplace add` alike — so there is no working Setup-Script install path, and the in-session
  alternatives all require either a forbidden committed project hook or per-session manual steps.
  Decision: don't pursue Web for now; keep the repo private and use the toolkit via the CLI. See
  "Cloud (Web) install: findings + DECISION" below.

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

## Cloud (Web) install: findings + DECISION (2026-06-26)

**DECISION (2026-06-26, revised): CLI-ONLY; keep the repo PRIVATE; Web is out of scope.**
Originally resolved as "make the repo public + Setup Script install," and the repo was briefly
made public. Then a four-command cloud probe **falsified the premise**: in the Setup Script phase
(root, pre-session, no credential) the proxy 403s *every* clone — `claude plugin marketplace add
obra/superpowers-marketplace` → 403, `git clone BehiSecc/VibeSec-Skill` → 403, `claude plugin
marketplace add tenorune/didactic-robot` → 403 — regardless of visibility, and `claude plugin
marketplace add` is just git-clone-through-the-proxy (superpowers has no releases, so no
api.github.com bypass). Public bought nothing for the Setup Script path, and it also showed the
old "superpowers/VibeSec load via the Setup Script" belief was never true in a project-connected
environment. Rather than adopt an in-session hack (forbidden committed hook, or manual per-session
install), the call is to **stop pursuing Web for now and focus on the CLI**; the repo was reverted
to private. The [[no-personal-identifiers]] rule still holds (it keeps a future re-publish safe),
and a pre-publish scan of the working tree + full history had confirmed zero identifiers/secrets.

**Official org path (noted, not used):** Anthropic's "manage plugins for your organization"
(support.claude.com/articles/13837433) distributes a marketplace from a repo that must be
**private/internal** (public is disallowed for *org* marketplaces), authenticated via the Claude
GitHub App installation token, on **Team/Enterprise plans** via Cowork. It does NOT cover Claude
Code on the Web or setup scripts. It is the only sanctioned private route and is irrelevant to an
individual plan — recorded here so a future Team/Enterprise migration can reconsider.

A long spike mapped exactly how Claude Code on the Web reaches GitHub. Conclusions:

- **Local CLI from the private repo — WORKS.** `claude plugin marketplace add
  tenorune/didactic-robot` + `claude plugin install toolkit@didactic-robot` (uses local `gh`
  credentials). This is the supported local path and `setup/setup-script.sh` does it.
- **Web cloud — the private repo CANNOT be auto-loaded without per-repo committed files.**
  The harness exposes three places to act, each with a hard limit for a *private* repo:
  - **Setup Script (env-level, pollution-free):** runs as `root` *before* the session, has **no
    `GH_TOKEN`**, and its git goes through a per-session proxy that **403s every non-connected
    clone — public OR private, `git clone` or `claude plugin marketplace add`** (verified
    2026-06-26; an earlier "a public repo clones fine here" note was WRONG). Anything it writes to
    `~/.claude` is wiped by the harness re-init that runs afterward.
  - **`/session-start-hook` (project hook):** the built-in command writes a **committed**
    `<repo>/.claude/hooks/session-start.sh`. Runs in-session (has `GH_TOKEN`, can install the
    private toolkit via REST tarball) — but it's a committed file in every repo, which the
    no-identifiers / no-toolkit-refs rule forbids.
  - **User-level `~/.claude/settings.json` hook:** not honored (harness manages `~/.claude`).
- A *public* repo does NOT sidestep this (verified 2026-06-26): the Setup Script 403s it too, so
  there is no clean Setup-Script install — public or private.

Useful facts discovered: web sessions set `CLAUDE_CODE_REMOTE=true` and `CLAUDE_PROJECT_DIR`;
the REST API (`api.github.com/.../tarball`, `Authorization: Bearer $GH_TOKEN`) bypasses the git
proxy and works **in-session**; the git proxy rewrites `https://github.com/` →
`http://local_proxy@127.0.0.1:PORT/git/` (see `~/.claude` memories for the full log).

**DECISION — chosen: option 4 (private, CLI-only); Web deferred.** The alternatives, for the record:
1. **Make the repo PUBLIC** + Setup Script install. ❌ **Tried and reverted** — the cloud Setup
   Script 403s every clone regardless of visibility, so public delivered no Web install. (The
   no-identifiers rule still makes a future re-publish safe if the cloud behavior ever changes.)
2. **Private + Setup-Script-injected *uncommitted* project hook** (`<repo>/.claude/hooks/…`,
   gitignored). Keeps it private; fragile (timing/persistence) and leaves untracked files.
3. **Private + manual in-session install** each session (REST tarball).
4. **Private, CLI-only** — auto-loads locally; install on demand in Web. ✅ **CHOSEN** (Web
   deferred until cloud proxy behavior changes or a non-hack path appears).

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
- Using the toolkit in the **CLI** works via `claude plugin marketplace add` + install (the
  decided scope, 2026-06-26). **VERIFIED 2026-06-26 by spike:** once installed at user scope and
  enabled in `~/.claude/settings.json`, the toolkit auto-loads in *any* project directory —
  offline, from the local marketplace clone (`~/.claude/plugins/marketplaces/didactic-robot`), so
  the repo staying private is irrelevant locally. A headless `claude -p` launched from a fresh,
  unrelated dir dispatched `toolkit:toolkit-smoke-test` successfully. Only manual step: the
  one-time install per machine. Web is explicitly deferred — no working pollution-free path exists
  given current cloud-proxy behavior.
