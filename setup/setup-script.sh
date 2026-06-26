#!/bin/bash
# Canonical "load everywhere" manifest for Claude Code.
# Single source of truth for everything you want in EVERY environment — your own toolkit
# plus curated skills authored by others.
#
# Same script, both harnesses — only the invocation differs:
#   - Cloud (Web): paste into the environment's "Setup script" field (or manage via /remote-env);
#     the environment runs it automatically at session start.
#   - Local (CLI): run it yourself once on a new machine. Prereqs: the `claude` CLI and a
#     GitHub login with access to the private repo (`gh auth login`). Then:
#         gh repo clone tenorune/didactic-robot
#         bash didactic-robot/setup/setup-script.sh
#
# Design rule: the CORE toolkit install is strict (must succeed). CURATED EXTERNAL skills are
# best-effort — a broken/renamed upstream must never block your own toolkit or fail the session.

# ---------------------------------------------------------------------------------------
# 1. Core: your own toolkit (private marketplace -> toolkit plugin). Must succeed.
# ---------------------------------------------------------------------------------------
set -e
claude plugin marketplace add tenorune/didactic-robot
claude plugin install toolkit@didactic-robot
echo "core: toolkit@didactic-robot installed."
set +e   # below: external failures must NOT abort setup or fail the session

# ---------------------------------------------------------------------------------------
# 2. Curated skills created by others, loaded everywhere (best-effort).
#    Add/remove entries to evolve your "load everywhere" set.
# ---------------------------------------------------------------------------------------

# install_marketplace_plugin <owner/repo> <marketplace-name> <plugin-name>
install_marketplace_plugin() {
  claude plugin marketplace add "$1"
  claude plugin marketplace update "$2" >/dev/null 2>&1   # avoid stale-cache "not found"
  if claude plugin install "${3}@${2}"; then
    echo "external: installed ${3}@${2}"
  else
    echo "WARNING: skipped ${3}@${2} (continuing)"
  fi
}

# clone_skill <git-url> <dest-name>
clone_skill() {
  local dest="$HOME/.claude/skills/$2"
  if [ -d "$dest" ]; then
    echo "external: $2 already present"
  elif git clone "$1" "$dest"; then
    echo "external: cloned $2"
  else
    echo "WARNING: skipped clone of $2 (continuing)"
  fi
}

# (a) superpowers core skills library (marketplace plugin)
install_marketplace_plugin "obra/superpowers-marketplace" "superpowers-marketplace" "superpowers"

# (b) VibeSec — security-review skill distributed as a loose repo
clone_skill "https://github.com/BehiSecc/VibeSec-Skill" "VibeSec-Skill"

echo "Load-everywhere set ready (core installed; externals best-effort)."
exit 0

# --- Fallback for a PRIVATE external source that needs auth -----------------------------
# Set GITHUB_TOKEN (PAT with read access) in the environment, then either re-run the add
# (GITHUB_TOKEN/GH_TOKEN is honored), or clone explicitly:
#   git clone "https://x-access-token:${GITHUB_TOKEN}@github.com/<owner>/<repo>.git" \
#     "$HOME/.claude/skills/<name>"
