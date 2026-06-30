# Handoff — didactic-robot

**What this is:** a **public** Claude Code plugin-marketplace repo (`tenorune/didactic-robot`) that
stores project-agnostic skills, instruction-blocks, an output style, and shared memory as one plugin
(`toolkit`, currently **v0.4.1**), used via the Claude Code **CLI** and **Claude Code on the Web** (Web works
with conditions — see below). Local path: `~/Public/didactic-robot`. (The README is intentionally
one line; this HANDOFF is the operational source of truth.) NOTE: the repo is **public**
(since 2026-06-26) to enable the Web path; the no-personal-identifiers rule keeps this safe.

## Repo layout (current)

```
.claude-plugin/marketplace.json      # marketplace manifest (lists the `toolkit` plugin)
.githooks/pre-commit                 # identifier/secret guard (enable: git config core.hooksPath .githooks)
plugins/toolkit/
  .claude-plugin/plugin.json         # v0.4.1
  skills/handing-off-a-session/      # canonical handoff skill; reconcile-git-state step added v0.3.2
  skills/shared-memory/              # reads memories on demand via ${CLAUDE_PLUGIN_ROOT}/memories/
  skills/toolkit-smoke-test/         # install-verification skill
  skills/vetting-ui-changes/         # web-UI vetting discipline skill (added v0.2.0)
  output-styles/disciplined.md       # always-on working posture; opt-in via /config → Output style (added v0.3.1)
  memories/                          # in-plugin shared-memory store: MEMORY.md index + 30 fact-files
instruction-blocks/                  # paste/@import CLAUDE.md snippets — 8 blocks + README (placeholder @import + import-all)
setup/setup-script.sh                # LOCAL CLI installer (toolkit core + curated externals)
docs/superpowers/specs/              # design specs — source of truth
docs/superpowers/plans/              # implementation plans
docs/candidate-memories/             # tracked-but-NOT-shipped memory drafts (README + 6 candidates + fold record)
docs/HANDOFF.md                      # this handoff
```

## What's next

**Nothing is in flight.** `main` and `dev` in sync at **v0.4.1** and **pushed** (`origin/main` =
`origin/dev`; `git log --oneline -1` for the exact tip), working tree clean, no open branches. This
section is forward-only — shipped work lives in git (the harvest worksheet is local-only, see History).

Next steps when you return (all optional/incremental):
0. **Update the active install to v0.4.1:** source is pushed at v0.4.1, but a running session pins the
   plugin-cache snapshot it started with. To move up:
   `claude plugin update toolkit@didactic-robot` + **restart**.
1. **Sift the remaining harvested candidate memories** in `docs/candidate-memories/` (tracked, NOT loaded
   by the plugin). Six remain — the human is sifting, deciding which to promote:
   - **2 confirmed** (surfaced by the harvest AND independently written as the human's own stored memories
     on a second machine): `memory-portability-audience`, `backup-claude-state-for-machine-switching`.
   - **4 drafts:** `user-owns-outward-actions`, `authorize-destructive-actions-per-occasion`,
     `config-secrets-via-gitignored-env`, `idempotent-operations-true-no-op`.
   Promote = move into `plugins/toolkit/memories/` + add to `MEMORY.md`, then confirm **no live memory
   links a candidate** (`grep -r "\[\[" plugins/toolkit/memories`). The fold record is `reinforced-themes.md`.
2. **Add assets as they arise:** more skills / **output styles** / `memories/` fact-files (keep `MEMORY.md`
   index in sync — now **30**). **Version bumps only when you ask.**
3. **Web run-twice (optional):** unchanged — the Web Setup Script must be run twice per repo (first run
   fails, second succeeds); mechanism unexplained, in-script retry already ruled out. Only probe if it
   becomes annoying — see Landmines + the `cloud-git-proxy-blocks-other-owner-repos` memory.

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
  batch of related work) — not every commit. `main` and `dev` are currently in sync at the v0.4.1 bump.

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

- **Instruction-blocks from harvested memories + impersonal-voice directive (2026-07-01, v0.4.1):**
  promoted 3 of the v0.4.0 harvested memories into the blocks library — new `scope-discipline.md`
  (`do-exactly-whats-asked` + `offer-to-file-followups-as-issues`) and `session-handoff.md`
  (`durable-handoff-artifacts` + `paste-ready-deliverables`), plus a **Branch hygiene** section folded
  into `branch-workflow.md` (`branch-hygiene`); blocks 6→8. Added a **No first-person voice** posture
  bullet to the `disciplined` style (impersonal output, third-person self-reference only when
  unavoidable; companion to the gerund rule) and recorded it in the style's design spec. Patch bump
  0.4.0→0.4.1 (additive, non-breaking). Of the 6 harvested memories, `push-so-user-can-review-on-remote`
  was judged Web/environment-specific and left as memory-only (no block); the remaining 6
  `docs/candidate-memories/` are untouched.
- **Cross-project memory harvest → promotions + reinforcement folds (2026-06-28, v0.4.0):** mined ~15
  past sessions across 8 projects + the human's own stored memories on a second machine into a local
  harvest worksheet (kept OUT of the repo at `~/Public/claude-harvests/`). Promoted 6 net-new memories
  (`do-exactly-whats-asked`, `branch-hygiene`, `paste-ready-deliverables`, `durable-handoff-artifacts`,
  `push-so-user-can-review-on-remote`, `offer-to-file-followups-as-issues`; index 24→30), folded reinforced
  themes into 6 existing memories + the output style (gerund openers), and left 6 candidates under
  `docs/candidate-memories/` for sifting. Ask-inline resolved as **Web-conditional** (no AskUserQuestion
  picker on Web — accessibility; CLI Q&A fine). No live memory links a candidate.
- **Instruction-blocks expansion + cross-Mac memory harvest (2026-06-27, v0.3.3):** added 5
  instruction-blocks (`git-commit-identity`, `evidence-before-claims`, `branch-workflow`,
  `pristine-commits`, `commit-and-version-restraint`) each with a concrete `@import` line using a
  `<path-to-didactic-robot>` placeholder, plus an "import them all" README section. Harvested over SSH
  from another Mac (`toy-23.local`): folded a "check latest tag, don't guess" note into
  `version-bumps-ask-first`, and staged 2 candidate memories under `docs/candidate-memories/` (tracked,
  not shipped). Shipped 3 Tier-3 library-design memories (`n=1-abstraction`, `runtime-agnostic-core`,
  `fail-closed-defaults`; index 21→24); dropped `injected-clock`, `upstream-staging`, and the unrecorded
  ~14 Tier-4 items. Identifiers scrubbed throughout — a real Proton email surfaced in a harvested memory
  and was excluded.
- **Handoff skill reconcile-git-state step + housekeeping (2026-06-27, v0.3.2):** `handing-off-a-session`
  now requires checking uncommitted / unmerged / **unpushed** state and asking the human (bounded options)
  BEFORE writing the handoff, instead of documenting a half-finished tree (cuts off the "don't push unless
  asked → so don't ask" misread). Built RED→GREEN with subagent pressure tests per superpowers:writing-skills.
  Same commit corrected stale `/output-style` → `/config` → Output style refs (CLI removed `/output-style`
  in v2.1.91). Also removed the old standalone `~/.claude/skills/handing-off-a-session` and cleared
  superseded toolkit caches so the skill is plugin-only. Merge tip after this handoff doc update.
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
