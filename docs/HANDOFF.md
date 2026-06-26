# Handoff — didactic-robot

**What this is:** a private Claude Code plugin-marketplace repo (`tenorune/didactic-robot`) that
stores project-agnostic skills / output styles / instruction-blocks / shared-memory as one plugin
(`toolkit`), used via the Claude Code **CLI** (Web is out of scope — see below). Local path:
`~/Public/didactic-robot`. (The README is intentionally one line; this HANDOFF is the operational
source of truth.)

## Repo layout (current)

```
.claude-plugin/marketplace.json     # marketplace manifest (lists the `toolkit` plugin)
plugins/toolkit/                     # the plugin
  .claude-plugin/plugin.json
  skills/toolkit-smoke-test/         # install-verification skill (seed)
setup/setup-script.sh                # LOCAL CLI installer (toolkit core + curated externals)
docs/superpowers/specs/              # design spec — source of truth
docs/HANDOFF.md                      # this handoff
```

## What's next (do this first)

1. **DECISION — RESOLVED (2026-06-26): CLI-ONLY; repo stays PRIVATE; Web is out of scope.** A
   public-repo experiment was tried and reverted after a cloud probe proved the Setup Script phase
   403s *every* clone (own/other, public/private, `git clone` and `claude plugin marketplace add`
   alike) — so "public" delivered no Web install, and the old "superpowers/VibeSec load via the
   Setup Script" belief was never true in a project-connected environment. Web is deferred until
   cloud-proxy behavior changes or a non-hack path appears. Full rationale: spec ("Cloud (Web)
   install: findings + DECISION").
2. **Build the toolkit contents — NOW the active task, scoped to the CLI:** inventory + migrate the
   real assets — start with the `handing-off-a-session` skill (`~/.claude/skills/`), the global
   CLAUDE.md "don't push to merge" rule → an instruction-block, output styles, and a
   `shared-memory` skill. A `writing-plans` implementation plan was queued.

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
grep -rniE '[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}|ghp_[A-Za-z0-9]|gho_[A-Za-z0-9]' . --exclude-dir=.git | grep -vF '117549102+tenorune@users.noreply.github.com'   # expect empty
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

An earlier spike searched for a *private + automatic + pollution-free* Web install path. It does
not exist given the harness design. A public-repo experiment was then tried and **reverted** once a
cloud probe proved the Setup Script 403s every clone regardless of visibility — so the resolution
is **CLI-only, repo private, Web deferred** (see "What's next" #1). The repo currently holds only
the seed (`toolkit` plugin + `toolkit-smoke-test` skill). Full reasoning is in the spec and the
`~/.claude` memories.
