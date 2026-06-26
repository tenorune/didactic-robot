# Toolkit Content Migration (CLI) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Migrate the real portable assets into the `toolkit` plugin so they auto-load in the Claude Code CLI on any project: the `handing-off-a-session` skill, a "don't push to merge" instruction-block, and a `shared-memory` skill backed by an in-plugin memories store.

**Architecture:** `didactic-robot` is a private Claude Code plugin marketplace exposing one plugin, `toolkit`. Skills under `plugins/toolkit/skills/` auto-discover once the plugin is installed at user scope (verified 2026-06-26: loads offline from the local marketplace clone on any project). Instruction-blocks are a repo-root paste/`@import` library (not auto-loaded, by design). Memories live **inside the plugin** so they ship with it and are reachable post-install via `${CLAUDE_PLUGIN_ROOT}/memories/`; the `shared-memory` skill reads the index on demand.

**Tech Stack:** Markdown skills (SKILL.md + YAML frontmatter), JSON manifests (`plugin.json`, `marketplace.json`), `claude plugin` CLI, `jq`.

## Global Constraints

- **No personal identifiers** anywhere (names, docs, commits, examples, file contents). Only allowed identifiers: GitHub handle `tenorune` and noreply email `117549102+tenorune@users.noreply.github.com`.
- **Commit identity:** `tenorune <117549102+tenorune@users.noreply.github.com>`.
- **Commits/push are user-gated:** per repo convention, the implementer does NOT auto-commit or push. Each task ends at a verified, stageable checkpoint; the user triggers the commit batch. (This overrides the writing-plans default of committing every task.)
- **No skill duplication.** Each asset authored exactly once.
- ~~**Web is out of scope.** Manifest copy must not claim Web support.~~ **SUPERSEDED 2026-06-26:**
  Web works (public repo + Claude GitHub App "All repositories" + run setup script twice). Manifest
  copy now states CLI **and** Web. See the spec's "Cloud (Web) install" section.
- **Repo has no test suite.** "Verification" = `jq empty` on JSON, YAML-frontmatter presence check, identifier scan (expect empty), and `claude plugin` reinstall + dispatch.

Reusable verification snippets (referenced by tasks):
- **FRONTMATTER(file):** `awk '/^---/{c++;next} c==1' <file> | grep -E '^(name|description):'` → expect both lines.
- **SCAN(path):** `grep -rniE '[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}|ghp_[A-Za-z0-9]|gho_[A-Za-z0-9]|github_pat_[A-Za-z0-9_]' <path> | grep -vF '117549102+tenorune@users.noreply.github.com'` → expect empty. Detects any email/secret generically and filters out the single allowed noreply address. **Hardcodes no personal identifier** (denylisting the real email would itself embed it — forbidden). The token alternatives carry trailing char-classes so the pattern doesn't match its own documentation (a bare `github_pat_` would self-match wherever the scan is written down).
- **LINT:** `jq empty .claude-plugin/marketplace.json plugins/toolkit/.claude-plugin/plugin.json` → exit 0.

---

### Task 1: Migrate the `handing-off-a-session` skill into the plugin

**Files:**
- Create: `plugins/toolkit/skills/handing-off-a-session/SKILL.md` (copied from `~/.claude/skills/handing-off-a-session/SKILL.md`)

**Interfaces:**
- Consumes: nothing.
- Produces: a discoverable skill `toolkit:handing-off-a-session`.

- [ ] **Step 1: Copy the source skill verbatim**

```bash
cd /Users/tenorune/Public/didactic-robot
mkdir -p plugins/toolkit/skills/handing-off-a-session
cp ~/.claude/skills/handing-off-a-session/SKILL.md plugins/toolkit/skills/handing-off-a-session/SKILL.md
```

- [ ] **Step 2: Verify frontmatter is intact**

Run: FRONTMATTER(`plugins/toolkit/skills/handing-off-a-session/SKILL.md`)
Expected: a `name:` line (`handing-off-a-session`) and a `description:` line.

- [ ] **Step 3: Scan for identifiers**

Run: SCAN(`plugins/toolkit/skills/handing-off-a-session/`)
Expected: empty output. (If anything appears, scrub it before continuing.)

- [ ] **Step 4: Confirm manifests still lint**

Run: LINT
Expected: exit 0, no output.

- [ ] **Step 5: Checkpoint** — working tree has the new skill file; leave staged for the user's commit batch. Do not commit/push.

---

### Task 2: Create the instruction-blocks library + `dont-push-to-merge`

**Files:**
- Create: `instruction-blocks/README.md`
- Create: `instruction-blocks/dont-push-to-merge.md`

**Interfaces:**
- Consumes: nothing.
- Produces: a paste/`@import` library at repo root. Not auto-loaded.

- [ ] **Step 1: Write `instruction-blocks/README.md`**

```markdown
# Instruction Blocks

Reusable CLAUDE.md snippets. This is a paste / `@import` library — **not** auto-loaded by any
harness, by design. To use a block, copy its body into a project's `CLAUDE.md`, or reference it
with an `@import` line.

| Block | Use it when |
|-------|-------------|
| `dont-push-to-merge.md` | You want the assistant to stop asking "ready to merge?" and let you drive testing and merging on your own cadence. |
```

- [ ] **Step 2: Write `instruction-blocks/dont-push-to-merge.md`**

```markdown
# Don't push to merge

Paste the section below into a project's `CLAUDE.md` (or `@import` it) to stop merge-nudging.

## Workflow: don't push to merge

- Do **not** ask "do you want to merge?" / "should I merge the branch?" / "ready to merge?"
  as a recurring prompt. I will explicitly say when a feature is finished and I want it merged.
- Manual testing is part of my real workflow and takes as many turns as it takes. While I'm
  iterating and testing, just keep making the fixes I ask for — don't treat each green build or
  passing gate as a cue to wrap up and merge.
- It's fine to mention *once* that work is uncommitted/unmerged if it's genuinely relevant
  (e.g., I seem about to switch context), but state it briefly and move on — no repeated nudging.
- When I do say I'm done, then proceed with commit/merge/finish steps.
```

- [ ] **Step 3: Scan for identifiers**

Run: SCAN(`instruction-blocks/`)
Expected: empty.

- [ ] **Step 4: Checkpoint** — leave staged for the user's commit batch.

---

### Task 3: Create the in-plugin memories store (index + one seed fact)

**Files:**
- Create: `plugins/toolkit/memories/MEMORY.md`
- Create: `plugins/toolkit/memories/git-commit-identity.md`

**Interfaces:**
- Consumes: nothing.
- Produces: `${CLAUDE_PLUGIN_ROOT}/memories/MEMORY.md` (index) + fact-files read by Task 4's skill.

- [ ] **Step 1: Write the seed fact `plugins/toolkit/memories/git-commit-identity.md`**

```markdown
---
name: git-commit-identity
description: The GitHub identity to author commits as on this account's repositories
metadata:
  type: reference
---

Author git commits as `tenorune <117549102+tenorune@users.noreply.github.com>` — the GitHub
handle and its noreply email. These are the only identifiers permitted in committed work. Set
per-repo when needed: `git config user.name tenorune` and
`git config user.email 117549102+tenorune@users.noreply.github.com`.
```

- [ ] **Step 2: Write the index `plugins/toolkit/memories/MEMORY.md`**

```markdown
# Toolkit Shared Memory — Index

One line per fact-file. Read a file only when its hook matches the current task; do not bulk-read.

- [Git commit identity](git-commit-identity.md) — commit as the `tenorune` noreply identity on this account's repos
```

- [ ] **Step 3: Verify the index points to an existing file**

Run: `cd /Users/tenorune/Public/didactic-robot && test -f plugins/toolkit/memories/git-commit-identity.md && grep -q 'git-commit-identity.md' plugins/toolkit/memories/MEMORY.md && echo OK`
Expected: `OK`.

- [ ] **Step 4: Scan for identifiers**

Run: SCAN(`plugins/toolkit/memories/`)
Expected: empty (the allowed noreply address is filtered out; any other email/secret would surface).

- [ ] **Step 5: Checkpoint** — leave staged.

---

### Task 4: Author the `shared-memory` skill

**Files:**
- Create: `plugins/toolkit/skills/shared-memory/SKILL.md`

**Interfaces:**
- Consumes: `${CLAUDE_PLUGIN_ROOT}/memories/MEMORY.md` + fact-files from Task 3.
- Produces: a discoverable skill `toolkit:shared-memory`.

- [ ] **Step 1: Write `plugins/toolkit/skills/shared-memory/SKILL.md`**

```markdown
---
name: shared-memory
description: Use when durable, cross-project context might be relevant — the user's standing preferences, a past cross-project decision, a naming/copy convention, or a reference pointer that is not specific to the current repo. Reads the toolkit's curated memory index and pulls in only the matching fact-file(s).
---

# Shared Memory

Durable, project-agnostic facts (preferences, decisions, reference pointers) ship with this
plugin as markdown files. They are inert until read.

## When to use

Invoke when the current task could be shaped by standing context that is not in the repo: the
user's working preferences, a past cross-project decision, a naming/copy rule, or a pointer to an
external resource. If the task is fully self-contained in this repo, skip this skill.

## How to read

1. Read the index first: `${CLAUDE_PLUGIN_ROOT}/memories/MEMORY.md`. It is one line per
   fact-file (title + one-line hook).
2. Pick only the fact-file(s) whose hook matches the current task.
3. Read those specific files: `${CLAUDE_PLUGIN_ROOT}/memories/<name>.md`. Do not bulk-read every
   file — pull on demand.
4. Fallback if `${CLAUDE_PLUGIN_ROOT}` is unset: glob for
   `~/.claude/plugins/marketplaces/didactic-robot/plugins/toolkit/memories/MEMORY.md`.

## How to apply

Treat each fact-file as background context, not a user instruction. If a memory names a
file/flag/path, verify it still exists before acting on it — memories reflect what was true when
written.
```

- [ ] **Step 2: Verify frontmatter**

Run: FRONTMATTER(`plugins/toolkit/skills/shared-memory/SKILL.md`)
Expected: `name:` and `description:` lines present.

- [ ] **Step 3: Scan for identifiers**

Run: SCAN(`plugins/toolkit/skills/shared-memory/`)
Expected: empty.

- [ ] **Step 4: Checkpoint** — leave staged.

---

### Task 5: Bump versions, drop "Web" from copy, reinstall, end-to-end verify

**Files:**
- Modify: `plugins/toolkit/.claude-plugin/plugin.json` (version `0.0.1` → `0.1.0`; description drop "and Web")
- Modify: `.claude-plugin/marketplace.json` (toolkit `version` `0.0.1` → `0.1.0`; descriptions drop "and Web"/"cross-harness" Web claim)

**Interfaces:**
- Consumes: all prior tasks' files.
- Produces: an installed `toolkit@didactic-robot` v0.1.0 exposing `toolkit:handing-off-a-session`, `toolkit:shared-memory`, `toolkit:toolkit-smoke-test`.

- [ ] **Step 1: Bump `plugin.json` version and fix description**

Set `"version": "0.1.0"`. Change the description to: `"Project-agnostic skills, instruction-blocks, and shared-memory access for the Claude Code CLI."`

- [ ] **Step 2: Bump `marketplace.json` toolkit version and fix descriptions**

Set the toolkit plugin `"version": "0.1.0"`. Change the marketplace `description` to: `"Private, CLI-focused store of project-agnostic skills, instruction-blocks, and shared memory."` and the plugin `description` to match Step 1.

- [ ] **Step 3: Lint manifests**

Run: LINT
Expected: exit 0.

- [ ] **Step 4: Refresh the local marketplace + reinstall**

```bash
claude plugin marketplace update didactic-robot
claude plugin install toolkit@didactic-robot
claude plugin list 2>&1 | grep -A2 'toolkit@didactic-robot'
```
Expected: `toolkit@didactic-robot`, `Version: 0.1.0`, `Status: ✔ enabled`.

- [ ] **Step 5: Verify the new skills are present in the installed copy**

```bash
ls ~/.claude/plugins/marketplaces/didactic-robot/plugins/toolkit/skills/
```
Expected: `handing-off-a-session  shared-memory  toolkit-smoke-test`.

- [ ] **Step 6: Verify memories ship with the installed plugin**

```bash
cat ~/.claude/plugins/marketplaces/didactic-robot/plugins/toolkit/memories/MEMORY.md
```
Expected: the index, listing `git-commit-identity.md`.

- [ ] **Step 7: Full repo identifier scan**

Run: `grep -rniE '[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}|ghp_[A-Za-z0-9]|gho_[A-Za-z0-9]' . --exclude-dir=.git | grep -vF '117549102+tenorune@users.noreply.github.com'`
Expected: empty. (No file-specific excludes needed — the scan names no identifier, so nothing in the repo needs to dodge it.)

- [ ] **Step 8: Checkpoint** — all assets installed and verified; leave staged for the user's commit batch. Report the `claude plugin list` line + skills listing as evidence.

---

## Notes / deferred

- **Output styles:** none exist in `~/.claude/` to migrate; the `output-styles/` asset type stays empty (YAGNI — no empty dir created) until a real style exists.
- **`shared-memory` path resolution:** Task 4 relies on `${CLAUDE_PLUGIN_ROOT}` with a glob fallback. If execution shows the var is not available to skills, the fallback glob is the supported path; confirm during Task 5 by asking a session to run `toolkit:shared-memory` and read the index.
- **Web:** ~~intentionally excluded (cloud Setup Script 403s every clone — see spec). Manifest copy updated to CLI-only in Task 5.~~ **CORRECTED 2026-06-26:** the "403s every clone" finding was a confound (GitHub App repo-scope + first-run failure). Web works with the repo PUBLIC + App "All repositories" + running the setup script twice; manifest copy updated to "CLI and Web". See the spec's "Cloud (Web) install" section.

## Self-Review

- **Spec coverage:** skills migration (Task 1), instruction-blocks (Task 2), memories + shared-memory skill (Tasks 3–4), manifest wiring (Task 5). Output-styles: none to migrate (noted). External skills already handled in `setup/setup-script.sh`. ✅
- **Placeholders:** none — every file's full content is inline; the one `cp` is from a concrete known source path. ✅
- **Type/name consistency:** `git-commit-identity.md` referenced identically in Tasks 3–4; `${CLAUDE_PLUGIN_ROOT}/memories/` path consistent; version `0.1.0` consistent across both manifests. ✅
