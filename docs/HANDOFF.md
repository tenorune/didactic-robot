# Handoff — didactic-robot

**What this is:** a private Claude Code plugin-marketplace repo (`tenorune/didactic-robot`) that
stores project-agnostic skills / output styles / instruction-blocks / shared-memory as one plugin
(`toolkit`), for reuse across the Claude Code CLI and Web. Local path: `~/Public/didactic-robot`.

## What's next (do this first)

1. **Resolve the OPEN DECISION blocking the Web story** — how to load the *private* toolkit in
   Claude Code on the Web. Options (full analysis in the spec):
   - **Make the repo public** + Setup Script install — *recommended*, clean, native skills, no
     token/hooks/project-files. Safe because the repo holds zero personal identifiers.
   - Private + Setup-Script-injected **uncommitted** project hook (fragile).
   - Private + manual in-session install. / Private + CLI-only.
2. **Then build the toolkit contents** (deferred): inventory + migrate the real assets — start
   with the `handing-off-a-session` skill (`~/.claude/skills/`), the global CLAUDE.md "don't push
   to merge" rule → an instruction-block, output styles, and a `shared-memory` skill. A
   `writing-plans` implementation plan was about to be written when the Web spike took over.

## On-ramp / source of truth

- **Spec:** `docs/superpowers/specs/2026-06-26-shared-toolkit-design.md` (design + the Web
  findings + the open decision).
- **Cloud/Web mechanics:** the auto-loaded memories under
  `~/.claude/projects/-Users-tenorune-Public-didactic-robot/memory/` — especially
  `web-plugin-loading-via-setup-script` and `cloud-git-proxy-blocks-other-owner-repos`.

## Environment essentials

This is a docs/config repo — no test suite. "Verification" =:
```bash
jq empty .claude-plugin/marketplace.json plugins/toolkit/.claude-plugin/plugin.json
bash -n setup/setup-script.sh
grep -rniE '***REDACTED-ID-PATTERN***|ghp_|gho_' . --exclude-dir=.git   # must be empty (no identifiers)
```
Install locally: `claude plugin marketplace add tenorune/didactic-robot && claude plugin install toolkit@didactic-robot`.
Verify a session: ask Claude to **run the `toolkit-smoke-test` skill**.

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

- **Branch `claude/proxy-resilient-setup` (origin) is polluted with misdirection — leave it
  alone, do not merge.** It came from a web session and contains a plausible-but-wrong "Option 1:
  add repo to environment scope" (no such feature) and a REST-fallback setup script that can't
  work (the setup script has no `GH_TOKEN`).
- **Web cloud git facts (hard-won, verified):** the session git proxy rewrites
  `https://github.com/` → `http://local_proxy@127.0.0.1:PORT/git/` and only clones the
  *connected* repo (other repos 403, even your own private ones). `GH_TOKEN` exists **in-session**
  but **not** in the Setup Script (which runs as root pre-session); the harness re-inits
  `~/.claude` after the setup script (so user-level `settings.json` you write there is wiped). The
  REST API (`api.github.com/.../tarball`, `Authorization: Bearer $GH_TOKEN`) bypasses the proxy
  in-session. `/session-start-hook` creates a *committed* project hook. Web sets
  `CLAUDE_CODE_REMOTE=true` and `CLAUDE_PROJECT_DIR`.
- The `setup/setup-script.sh` is **local-CLI only** right now; its header says so. Don't paste it
  into a web Setup Script expecting it to work while the repo is private.

---

## History (skip unless relevant — it's in git/spec)

Most of this session was a spike to find a *private + automatic + pollution-free* Web install
path. It does not exist given the harness design; the result is the OPEN DECISION above. The
repo currently holds only the spike seed (`toolkit` plugin + `toolkit-smoke-test` skill). Full
reasoning is in the spec and the `~/.claude` memories.
