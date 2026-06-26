# Handoff — didactic-robot

**What this is:** a private Claude Code plugin-marketplace repo (`tenorune/didactic-robot`) that
stores project-agnostic skills, instruction-blocks, and shared memory as one plugin (`toolkit`,
currently **v0.1.0**), used via the Claude Code **CLI** (Web is out of scope — see below). Local
path: `~/Public/didactic-robot`. (The README is intentionally one line; this HANDOFF is the
operational source of truth.)

## Repo layout (current)

```
.claude-plugin/marketplace.json      # marketplace manifest (lists the `toolkit` plugin)
.githooks/pre-commit                 # identifier/secret guard (enable: git config core.hooksPath .githooks)
plugins/toolkit/
  .claude-plugin/plugin.json         # v0.1.0
  skills/handing-off-a-session/      # migrated personal skill
  skills/shared-memory/              # reads memories on demand via ${CLAUDE_PLUGIN_ROOT}/memories/
  skills/toolkit-smoke-test/         # install-verification skill
  memories/                          # in-plugin shared-memory store: MEMORY.md index + fact-files
instruction-blocks/                  # paste/@import CLAUDE.md snippets (README + dont-push-to-merge)
setup/setup-script.sh                # LOCAL CLI installer (toolkit core + curated externals)
docs/superpowers/specs/              # design spec — source of truth
docs/superpowers/plans/              # implementation plan(s)
docs/HANDOFF.md                      # this handoff
```

## What's next

**Nothing is in flight.** Toolkit **v0.1.0 is built, verified, and pushed** (`main` @ latest):
`handing-off-a-session` + `shared-memory` + `toolkit-smoke-test` skills, `instruction-blocks/`,
in-plugin `memories/`, and the pre-commit guard. Verified end-to-end: auto-loads on any project
(offline, repo-private), new skills dispatch, `${CLAUDE_PLUGIN_ROOT}/memories/` resolves.

Likely next steps when you return (all optional/incremental):
1. **Add assets as they arise:** more skills into `plugins/toolkit/skills/`; the first real
   **output style** into a new `plugins/toolkit/output-styles/` (none exist yet); more `memories/`
   fact-files (keep `MEMORY.md` index in sync). Bump `version` in both manifests on changes, then
   `claude plugin marketplace update didactic-robot` + uninstall/reinstall to refresh the cache.
2. **Web stays deferred** (out of scope). Only revisit if cloud-proxy behavior changes; the one
   untested thread is in-session clone behavior with `GH_TOKEN` (see Landmines).
3. **`/insights`** session-analysis is deferred (spec "Out of scope").

## On-ramp / source of truth

- **Spec:** `docs/superpowers/specs/2026-06-26-shared-toolkit-design.md` (design + the Web
  findings + the resolved Web-install decision).
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
Install locally (CLI): `claude plugin marketplace add tenorune/didactic-robot && claude plugin install toolkit@didactic-robot` (or run `setup/setup-script.sh`). Needs `gh auth` access to the private repo.
Web: out of scope — the cloud Setup Script 403s every clone (see Landmines). Don't paste the setup
script into a Web Setup Script field expecting it to work.
Pre-commit guard: `.githooks/pre-commit` blocks any staged email/secret except the allowed
noreply address (generic detector — names no identifier). Enable once per clone:
`git config core.hooksPath .githooks`. Override a false positive with `git commit --no-verify`.
Verify a session: ask Claude to **run the `toolkit-smoke-test` skill**.
Auto-load (VERIFIED 2026-06-26 by spike): once installed at user scope + enabled in
`~/.claude/settings.json`, the toolkit loads in **any** project dir, offline from the local
marketplace clone — repo can stay private. A headless `claude -p` from a fresh unrelated dir
dispatched `toolkit:toolkit-smoke-test`. Only manual step is the one-time per-machine install.
External skills are **referenced from upstream, not vendored**, and installed **best-effort** in
the setup script, so a broken upstream never blocks the core toolkit.

## Conventions

- **No personal identifiers** in anything (names, docs, commits, examples). Allowed: GitHub handle
  `tenorune`, noreply email `117549102+tenorune@users.noreply.github.com`.
- Commit as `tenorune <117549102+tenorune@users.noreply.github.com>` (repo git config already set).
- Work happens on `main` (this is personal infra). Commit/push only when asked.

## Human's working style

- Drives manual testing across many turns; does not want repeated "ready to merge?" nudges. When
  done, will say so explicitly.
- Sharp about unverified claims — distinguish DOCUMENTED vs OBSERVED vs INFERRED; don't assert
  cloud behavior without evidence. (Two wrong cloud conclusions happened by theorizing — verify.)

---

## Landmines / gotchas

- **Misdirection branch `claude/proxy-resilient-setup` was DELETED (2026-06-26).** It pushed a
  plausible-but-wrong "Option 1: add repo to environment scope" (no such feature) and an unworkable
  REST-fallback setup script. If it ever reappears, it is misdirection — do not merge.
- **Why Web is out of scope (hard-won, VERIFIED 2026-06-26):** in the cloud **Setup Script** phase
  (root, pre-session, no `GH_TOKEN`) the git proxy 403s **every** clone — own/other-owner,
  public/private, raw `git clone` AND `claude plugin marketplace add` (which is just
  git-clone-through-the-proxy; no api.github.com bypass). A four-command probe confirmed:
  `marketplace add obra/superpowers-marketplace` → 403, `git clone BehiSecc/VibeSec-Skill` → 403,
  `marketplace add tenorune/didactic-robot` → 403. So making the repo public bought nothing, and
  the old "superpowers/VibeSec load via the Setup Script" belief was never true here. The proxy
  rewrites `https://github.com/` → `http://local_proxy@127.0.0.1:PORT/git/`. `GH_TOKEN` exists
  **in-session** only; the REST API (`api.github.com/.../tarball`, `Authorization: Bearer
  $GH_TOKEN`) bypasses the proxy **in-session** (the only thing that does), but the only ways to
  run it per-session are a forbidden committed project hook or a manual install — hence Web is
  deferred. `/session-start-hook` creates a *committed* project hook. Web sets
  `CLAUDE_CODE_REMOTE=true` and `CLAUDE_PROJECT_DIR`. **In-session** clone behavior (whether a
  non-connected public repo clones with the token present) was never tested — pick up there if Web
  is ever revisited.
- The `setup/setup-script.sh` is **local-CLI only**; its header says so.

---

## History (skip unless relevant — it's in git/spec)

- **Toolkit v0.1.0 built (2026-06-26):** migrated `handing-off-a-session`; added `instruction-blocks/`
  (`dont-push-to-merge`), in-plugin `memories/` (index + `git-commit-identity` seed) and the
  `shared-memory` skill; bumped manifests to CLI-only v0.1.0. Built via the plan in
  `docs/superpowers/plans/`. Verified: auto-loads on any project; skills dispatch;
  `${CLAUDE_PLUGIN_ROOT}/memories/` resolves to real files.
- **Web-install decision (2026-06-26):** a spike sought a private + automatic + pollution-free Web
  path; it doesn't exist. A public-repo experiment was tried and **reverted** once a cloud probe
  proved the Setup Script 403s every clone regardless of visibility → resolution: CLI-only, repo
  private, Web deferred. Full reasoning in the spec + `~/.claude` memories.
- **PID cleanup (2026-06-26):** an identifier scan that *denylisted* the real email (thereby
  embedding it) was replaced with a generic detector; git history was rewritten (`git filter-repo`)
  to purge the leaked tokens; the `.githooks/pre-commit` guard now blocks recurrence. Stale
  `…/cache/…/toolkit/0.0.1/` dir is harmless leftover.
