# Handoff — didactic-robot

**What this is:** a **public** Claude Code plugin-marketplace repo (`tenorune/didactic-robot`) that
stores project-agnostic skills, instruction-blocks, and shared memory as one plugin (`toolkit`,
currently **v0.1.0**), used via the Claude Code **CLI** and **Claude Code on the Web** (Web now
works with conditions — see below). Local path: `~/Public/didactic-robot`. (The README is
intentionally one line; this HANDOFF is the operational source of truth.) NOTE: the repo was made
**public** (2026-06-26) to enable the Web path; the no-personal-identifiers rule keeps this safe.

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
2. **Web now works** (2026-06-26, reproduced on 2 repos) with three conditions: (a) toolkit repo
   **PUBLIC** (no `GH_TOKEN` at build time for private); (b) the **Claude GitHub App set to "All
   repositories"** (else external clones 403); (c) run the Web Setup Script **twice** on a repo —
   first run fails, identical second run succeeds (effect accepted; mechanism unexplained). Paste
   `setup/setup-script.sh`'s body into the env's Setup Script field. Details in Landmines + the
   `cloud-git-proxy-blocks-other-owner-repos` memory.
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
Install locally (CLI): `claude plugin marketplace add tenorune/didactic-robot && claude plugin install toolkit@didactic-robot` (or run `setup/setup-script.sh`).
Web: works with conditions (2026-06-26) — repo PUBLIC + Claude GitHub App = "All repositories" +
run the Web Setup Script **twice** per repo (first run fails, second succeeds). Paste
`setup/setup-script.sh`'s body into the env's Setup Script field. See Landmines / memories.
Pre-commit guard: `.githooks/pre-commit` blocks any staged email/secret except the allowed
noreply address (generic detector — names no identifier). Enable once per clone:
`git config core.hooksPath .githooks`. Override a false positive with `git commit --no-verify`.
Verify a session: ask Claude to **run the `toolkit-smoke-test` skill**.
Auto-load (VERIFIED 2026-06-26 by spike): once installed at user scope + enabled in
`~/.claude/settings.json`, the toolkit loads in **any** project dir, offline from the local
marketplace clone (works regardless of repo visibility). A headless `claude -p` from a fresh
unrelated dir dispatched `toolkit:toolkit-smoke-test`. Only manual step is the one-time per-machine
install. External skills are **referenced from upstream, not vendored**. NOTE: the proven
`setup/setup-script.sh` installs each component independently and `exit $fail` — if ANY component
(including an external) fails, the exit is nonzero (on Web that means re-run); it is NOT
"best-effort externals." (An earlier version made externals best-effort; the verified Web script
does not.)

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
- **Web install — how it actually works (CORRECTED 2026-06-26; supersedes the old "out of scope /
  403s every clone" claim, which was WRONG).** The earlier "four-command probe 403s every clone"
  conclusion was a confound: the failures were caused by (a) the Claude GitHub App being set to
  "Only select repositories" — which blocks the Setup Script's EXTERNAL clones (superpowers/VibeSec
  are never in the select list) — and (b) a first-run failure (see run-twice below), NOT by a
  blanket proxy wall. The proxy rewrites `https://github.com/` → `http://local_proxy@127.0.0.1:PORT/git/`
  and gates clones by the GitHub App's repo scope. **Working recipe (reproduced on 2 repos):**
  (1) toolkit repo **PUBLIC** (`GH_TOKEN` is absent at build time, so a private clone can't auth);
  (2) Claude GitHub App = **"All repositories"** (github.com → Settings → Applications → Claude →
  Configure) — trade-off: grants Claude access to all repos; (3) run the Setup Script **twice** per
  repo — first run fails, identical second run succeeds (mechanism **unexplained**, effect accepted
  as the workflow). With these, the combined `setup/setup-script.sh` loads `toolkit:*` +
  `superpowers:*` + `VibeSec-Skill` on an arbitrary project. (An in-script retry was TESTED
  2026-06-26 and does NOT collapse the double-run — 5 in-build attempts over ~50s all 403'd; a fresh
  session is required, not just elapsed time. So the workflow stays: run it twice.) Web sets
  `CLAUDE_CODE_REMOTE=true` and
  `CLAUDE_PROJECT_DIR`. (NOTE: this investigation produced ~6 premature wrong conclusions before
  this — see the `dont-declare-cloud-findings-resolved-early` memory; keep findings OBSERVED-only.)
- The `setup/setup-script.sh` works for **both CLI and Web** (its header documents the Web
  conditions: public repo + App "All repositories" + run twice).

---

## History (skip unless relevant — it's in git/spec)

- **Toolkit v0.1.0 built (2026-06-26):** migrated `handing-off-a-session`; added `instruction-blocks/`
  (`dont-push-to-merge`), in-plugin `memories/` (index + `git-commit-identity` seed) and the
  `shared-memory` skill; bumped manifests to CLI-only v0.1.0. Built via the plan in
  `docs/superpowers/plans/`. Verified: auto-loads on any project; skills dispatch;
  `${CLAUDE_PLUGIN_ROOT}/memories/` resolves to real files.
- **Web-install saga (2026-06-26):** a long spike first concluded (wrongly, ~6 times) that Web was
  impossible — "403s every clone", "rate-limit", "connected-repo only", etc. The user's controlled
  testing falsified each. Actual resolution: Web **works** with the repo PUBLIC + the Claude GitHub
  App = "All repositories" + running the Setup Script twice per repo. The repo was made public to
  enable it. Full reasoning in the spec + `~/.claude` memories (and the lesson in
  `dont-declare-cloud-findings-resolved-early`).
- **PID cleanup (2026-06-26):** an identifier scan that *denylisted* the real email (thereby
  embedding it) was replaced with a generic detector; git history was rewritten (`git filter-repo`)
  to purge the leaked tokens; the `.githooks/pre-commit` guard now blocks recurrence. Stale
  `…/cache/…/toolkit/0.0.1/` dir is harmless leftover.
