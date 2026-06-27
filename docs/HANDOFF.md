# Handoff — didactic-robot

**What this is:** a **public** Claude Code plugin-marketplace repo (`tenorune/didactic-robot`) that
stores project-agnostic skills, instruction-blocks, an output style, and shared memory as one plugin
(`toolkit`, currently **v0.3.1**), used via the Claude Code **CLI** and **Claude Code on the Web** (Web works
with conditions — see below). Local path: `~/Public/didactic-robot`. (The README is intentionally
one line; this HANDOFF is the operational source of truth.) NOTE: the repo is **public**
(since 2026-06-26) to enable the Web path; the no-personal-identifiers rule keeps this safe.

## Repo layout (current)

```
.claude-plugin/marketplace.json      # marketplace manifest (lists the `toolkit` plugin)
.githooks/pre-commit                 # identifier/secret guard (enable: git config core.hooksPath .githooks)
plugins/toolkit/
  .claude-plugin/plugin.json         # v0.3.1
  skills/handing-off-a-session/      # migrated personal skill
  skills/shared-memory/              # reads memories on demand via ${CLAUDE_PLUGIN_ROOT}/memories/
  skills/toolkit-smoke-test/         # install-verification skill
  skills/vetting-ui-changes/         # web-UI vetting discipline skill (added v0.2.0)
  output-styles/disciplined.md       # always-on working posture; opt-in via /output-style (added v0.3.1)
  memories/                          # in-plugin shared-memory store: MEMORY.md index + 21 fact-files
instruction-blocks/                  # paste/@import CLAUDE.md snippets (README + dont-push-to-merge)
setup/setup-script.sh                # LOCAL CLI installer (toolkit core + curated externals)
docs/superpowers/specs/              # design specs — source of truth
docs/superpowers/plans/              # implementation plans
docs/HANDOFF.md                      # this handoff
```

## What's next

**Nothing is in flight.** `main` and `dev` in sync at the **v0.3.1** bump merge (run `git log --oneline -1`
for the tip), clean, **not yet pushed**. Shipped work lives in git + specs/plans; this section is
forward-only. Shipped since v0.1.0: the **`vetting-ui-changes`** skill (v0.2.0), a **21-entry
cross-project shared-memory set** under `plugins/toolkit/memories/` (v0.3.0), and the first **output
style** `disciplined` (v0.3.1).

Next steps when you return (all optional/incremental):
0. **Push + refresh:** `main`/`dev` are committed but unpushed. When ready: push, then
   `claude plugin marketplace update didactic-robot` + reinstall + **restart** to load v0.3.1, and
   live-test the `disciplined` style via `/output-style` (a live session pins the old plugin cache).
1. **Add assets as they arise:** more skills into `plugins/toolkit/skills/`; more **output styles** into
   `plugins/toolkit/output-styles/` (the slot now exists — `disciplined.md` is the first); more
   `memories/` fact-files (keep `MEMORY.md` index in sync). **Version bumps only when you ask** — a batch
   of related work is one bump, not one per commit.
2. **Deferred memory tiers:** a triaged list of further cross-project memories was *not* added —
   Tier 3 (library design: n=1-abstraction, runtime-agnostic-core, fail-closed-defaults,
   injected-clock, upstream-staging) and ~14 niche Tier-4 items. Revisit if wanted.
3. **Web run-twice (optional):** unchanged — the Web Setup Script must be run twice per repo (first
   run fails, second succeeds); mechanism unexplained, in-script retry already ruled out. Only probe
   if it becomes annoying — see Landmines + the `cloud-git-proxy-blocks-other-owner-repos` memory.

## On-ramp / source of truth

- **Specs:** `docs/superpowers/specs/2026-06-26-shared-toolkit-design.md` (toolkit + Web findings);
  `docs/superpowers/specs/2026-06-27-vetting-ui-changes-skill-design.md` (the skill, built TDD-style,
  with the guidelines-mining revision).
- **Shared-memory set:** `plugins/toolkit/memories/MEMORY.md` (index) — the in-plugin cross-project
  memories, read on demand by the `shared-memory` skill.
- **Cloud/Web mechanics:** the auto-loaded memories under
  `~/.claude/projects/-Users-tenorune-Public-didactic-robot/memory/` — especially
  `web-plugin-loading-via-setup-script` and `cloud-git-proxy-blocks-other-owner-repos`.

## Environment essentials

This is a docs/config repo — no test suite. "Verification" =:
```bash
jq empty .claude-plugin/marketplace.json plugins/toolkit/.claude-plugin/plugin.json
bash -n setup/setup-script.sh
# identifier/secret scan — generic detector, filters in only the allowed noreply address (names no identifier):
grep -rniE '[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}|ghp_[A-Za-z0-9]|gho_[A-Za-z0-9]|github_pat_[A-Za-z0-9_]' . --exclude-dir=.git | grep -vF '117549102+tenorune@users.noreply.github.com'   # expect empty
```
Install locally (CLI): `claude plugin marketplace add tenorune/didactic-robot && claude plugin install toolkit@didactic-robot` (or run `setup/setup-script.sh`). To pick up a new version in a
running session: `claude plugin update toolkit@didactic-robot` then **restart** (a live session
pins the cache snapshot it started with — see Landmines).
Web: works with conditions (2026-06-26) — repo PUBLIC + Claude GitHub App = "All repositories" +
run the Web Setup Script **twice** per repo (first run fails, second succeeds). Paste
`setup/setup-script.sh`'s body into the env's Setup Script field. See Landmines / memories.
Pre-commit guard: `.githooks/pre-commit` blocks any staged email/secret except the allowed
noreply address (generic detector — names no identifier). Enable once per clone:
`git config core.hooksPath .githooks`. Override a false positive with `git commit --no-verify`.
Verify a session: ask Claude to **run the `toolkit-smoke-test` skill** (version-agnostic — confirms
the plugin loaded; it does NOT report the version).
Auto-load (VERIFIED 2026-06-26 by spike): once installed at user scope + enabled in
`~/.claude/settings.json`, the toolkit loads in **any** project dir, offline from the local
marketplace clone (works regardless of repo visibility). External skills are **referenced from
upstream, not vendored**. The proven `setup/setup-script.sh` installs each component independently and
`exit $fail` — if ANY component (incl. an external) fails, exit is nonzero (on Web that means
re-run); it is NOT "best-effort externals."

## Conventions

- **No personal identifiers** in anything (names, docs, commits, examples). Allowed: GitHub handle
  `tenorune`, noreply email `117549102+tenorune@users.noreply.github.com`.
- Commit as `tenorune <117549102+tenorune@users.noreply.github.com>` (repo git config already set).
- **Develop on branches** (changed 2026-06-27, supersedes the old "work on `main`"): feature branch
  → `dev` integration branch → `main`. You create and work the feature branch; **do NOT merge/PR,
  push, or bump versions unless asked.** A version bump marks a *significant* change (a feature, or a
  batch of related work) — not every commit. `main` and `dev` are currently in sync at the v0.3.1 bump.

## Human's working style

- Drives manual testing across many turns; does not want repeated "ready to merge?" nudges. Says
  explicitly when done. Terse confirmations ("y", "go ahead") mean keep going.
- Likes bounded multiple-choice options for decisions over open-ended questions.
- Sharp about unverified claims — distinguish DOCUMENTED vs OBSERVED vs INFERRED; don't assert cloud
  behavior without evidence. (Two wrong cloud conclusions came from theorizing — verify.)
- These preferences are now codified as cross-project memories in `plugins/toolkit/memories/`.

---

## Landmines / gotchas

- **A live session pins its plugin-cache snapshot.** After `claude plugin update`, a running
  session keeps loading the OLD version (and old `toolkit-smoke-test` may even print a stale version
  string) until you **restart**. `installed_plugins.json` is the source of truth for what's installed;
  the smoke test only proves *something* loaded. (Hit during the v0.2.0 verification.)
- **Misdirection branch `claude/proxy-resilient-setup` was DELETED (2026-06-26).** It pushed a
  plausible-but-wrong "Option 1: add repo to environment scope" (no such feature) and an unworkable
  REST-fallback setup script. If it ever reappears, it is misdirection — do not merge.
- **Web install — how it actually works (CORRECTED 2026-06-26; supersedes the old "out of scope /
  403s every clone" claim, which was WRONG).** The proxy rewrites `https://github.com/` →
  `http://local_proxy@127.0.0.1:PORT/git/` and gates clones by the Claude GitHub App's repo scope.
  **Working recipe (reproduced on 2 repos):** (1) toolkit repo **PUBLIC** (`GH_TOKEN` is absent at
  build time, so a private clone can't auth); (2) Claude GitHub App = **"All repositories"**
  (github.com → Settings → Applications → Claude → Configure); (3) run the Setup Script **twice** per
  repo — first run fails, identical second run succeeds (mechanism **unexplained**; an in-script
  retry was TESTED and does NOT collapse the double-run — a fresh session is required, not just
  elapsed time). With these, the combined `setup/setup-script.sh` loads `toolkit:*` + `superpowers:*`
  + `VibeSec-Skill` on an arbitrary project. (This investigation produced ~6 premature wrong
  conclusions first — see `dont-declare-cloud-findings-resolved-early`; keep findings OBSERVED-only.)
- The `setup/setup-script.sh` works for **both CLI and Web** (its header documents the Web
  conditions: public repo + App "All repositories" + run twice).

---

## History (skip unless relevant — it's in git/spec)

- **`disciplined` output style (2026-06-27, v0.3.1):** first toolkit output style, under
  `plugins/toolkit/output-styles/`. Encodes the always-on *interaction posture + restraint* subset of
  the conventions (terse-cue momentum, bounded choices, OBSERVED-vs-UNKNOWN evidence, no unprompted
  commit/push/bump/merge, "done is the operator's call"); voice = principle+why under one thesis.
  `keep-coding-instructions: true`, `force-for-plugin: false` (opt-in, never auto-applied). Task
  procedures stay in skills, reference facts stay in memory — see the selection principle in
  `docs/superpowers/specs/2026-06-27-disciplined-output-style-design.md`.
- **Shared-memory set + branch workflow (2026-06-27, v0.3.0):** added 21 cross-project memories under
  `plugins/toolkit/memories/` (working-style, release/publish, library-design, identity), distilled
  from this repo's work + a mining pass across `~/Public` and `github.com/tenorune` handoff/convention
  docs; adopted feature → dev → main branching. Squashed to one v0.3.0 commit; merge `c829c75`.
- **`vetting-ui-changes` skill (2026-06-27, v0.2.0):** project-agnostic web-UI vetting skill (layout
  stability, cross-surface consistency, deliberate destruction, mobile readiness) built TDD-style
  (RED baseline → GREEN → REFACTOR per superpowers:writing-skills); generalized from a project-scoped
  skill. Interaction-containment was tested and rejected (agents already handle it). Commit `347dd52`.
- **Toolkit v0.1.0 built (2026-06-26):** migrated `handing-off-a-session`; added `instruction-blocks/`
  (`dont-push-to-merge`), in-plugin `memories/` (index + `git-commit-identity` seed) and the
  `shared-memory` skill. Verified: auto-loads on any project; skills dispatch.
- **Web-install saga (2026-06-26):** a long spike first concluded (wrongly, ~6 times) that Web was
  impossible. Actual resolution: Web **works** with the repo PUBLIC + Claude GitHub App = "All
  repositories" + running the Setup Script twice per repo. Repo made public to enable it.
- **PID cleanup (2026-06-26):** an identifier scan that *denylisted* the real email was replaced with
  a generic detector; git history was rewritten (`git filter-repo`) to purge leaked tokens; the
  `.githooks/pre-commit` guard now blocks recurrence.
```
