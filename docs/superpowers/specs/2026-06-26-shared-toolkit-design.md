# Design: `didactic-robot` — a private, cross-harness store for skills, prompts, and memory

**Date:** 2026-06-26
**Status:** Approved (design). Web-install decision **UPDATED 2026-06-26 → Web WORKS with
conditions** (toolkit repo PUBLIC + Claude GitHub App = "All repositories" + run the Setup Script
twice per repo); reproduced on 2 repos. The repo is now PUBLIC. This supersedes the earlier
"CLI-only / Web out of scope / Setup Script 403s every clone" conclusion, which was a confound (the
GitHub App's repo scope + a first-run failure, not a blanket proxy wall). See "Cloud (Web) install"
below.

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
- **Web (cloud):** WORKS with conditions (2026-06-26, reproduced on 2 repos). Paste the
  `setup/setup-script.sh` body into the environment's Setup Script field. Requires: the toolkit repo
  **PUBLIC** (no `GH_TOKEN` at build time to auth a private clone); the **Claude GitHub App set to
  "All repositories"** (otherwise the external clones 403); and running the Setup Script **twice**
  per repo (first run fails, second succeeds; mechanism unexplained, effect accepted). See "Cloud
  (Web) install: findings + DECISION" below.

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

**DECISION (2026-06-26, FINAL revision): Web WORKS — repo PUBLIC + Claude GitHub App = "All
repositories" + run the Setup Script twice per repo.** This reverses the prior "CLI-only / Web out
of scope" call. That earlier call rested on a four-command probe that 403'd every clone — but the
user's later controlled testing showed those 403s were a **confound**, not a proxy wall:
1. The Claude GitHub App was set to **"Only select repositories."** The Web git proxy enforces that
   scope on EVERY clone, including public ones, so the Setup Script's EXTERNAL clones
   (`obra/superpowers`, `BehiSecc/VibeSec` — never in the select list) 403'd. Setting the App to
   **"All repositories"** fixes it. (Logic-solid: a non-listed repo is unreachable under "select.")
2. A separate **run-twice effect**: even with the App fixed, the FIRST Setup Script run on a given
   repo fails and an identical SECOND run succeeds. Mechanism unexplained; accepted as the workflow.

Reproduced on 2 repos: with both conditions met, `setup/setup-script.sh` loads `toolkit:*` +
`superpowers:*` + `VibeSec-Skill` on an arbitrary project. The repo is now **PUBLIC** (required —
no `GH_TOKEN` at build time to auth a private clone). The no-personal-identifiers rule keeps the
public repo safe; a pre-publish scan of the working tree + full history confirmed zero
identifiers/secrets. **Caveat for future readers:** this investigation produced ~6 premature wrong
conclusions ("403s every clone", "rate-limit", "connected-repo only", "git-clone vs marketplace",
two "RESOLVED"s) before the controlled tests settled it — see the
`dont-declare-cloud-findings-resolved-early` memory; report OBSERVED only and change one variable at
a time. (Tested 2026-06-26: an in-script retry does NOT collapse the double-run — 5 in-build attempts
over ~50s all 403'd; a fresh session is required, not just elapsed time. The two-run workflow stays.)

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
- **Web cloud — the PUBLIC repo loads via the Setup Script (env-level, pollution-free).** The Setup
  Script runs as `root` before the session with no `GH_TOKEN`, and its git goes through a
  per-session proxy that rewrites `https://github.com/` → `http://local_proxy@127.0.0.1:PORT/git/`
  and **gates clones by the Claude GitHub App's repo scope.** With the App set to "All repositories"
  the Setup Script clones the public toolkit AND external public repos (superpowers/VibeSec); under
  "Only select repositories" those external clones 403. (An earlier "Setup Script 403s every clone —
  public or private" note was WRONG — it conflated the select-scope block with a first-run failure.)
  The remaining quirk is the run-twice effect (first run fails, identical second run succeeds). A
  PRIVATE repo still can't be cloned at build time (no `GH_TOKEN`) — which is why the repo was made
  public.
- For the record, the two in-session alternatives (no longer needed now that the Setup Script
  works): `/session-start-hook` writes a *committed* `<repo>/.claude/hooks/session-start.sh` (runs
  in-session with `GH_TOKEN`, can install via REST tarball — but a committed per-repo file the
  no-toolkit-refs rule forbids); a user-level `~/.claude/settings.json` hook is not honored.

Useful facts discovered: web sessions set `CLAUDE_CODE_REMOTE=true` and `CLAUDE_PROJECT_DIR`;
the REST API (`api.github.com/.../tarball`, `Authorization: Bearer $GH_TOKEN`) bypasses the git
proxy and works **in-session**; the git proxy rewrites `https://github.com/` →
`http://local_proxy@127.0.0.1:PORT/git/` (see `~/.claude` memories for the full log).

**DECISION — chosen: PUBLIC repo + Setup Script install (CLI and Web).** The alternatives, for the
record:
1. **PUBLIC repo + Setup Script install.** ✅ **CHOSEN** — works in both CLI and Web (Web needs the
   Claude GitHub App = "All repositories" + running the Setup Script twice per repo). The
   no-identifiers rule keeps the public repo safe.
2. Private + Setup-Script-injected *uncommitted* project hook (gitignored) — not needed; fragile.
3. Private + manual in-session install each session (REST tarball) — not needed; manual per session.
4. Private, CLI-only — superseded; a private repo can't be cloned at build time on Web (no
   `GH_TOKEN`), so it cannot support the Web path.

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
  one-time install per machine. **Web also works** (2026-06-26, reproduced on 2 repos): the toolkit
  repo PUBLIC + the Claude GitHub App set to "All repositories" + running the Setup Script twice per
  repo (first run fails, second succeeds).
