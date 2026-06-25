#!/bin/bash
# Canonical "load everywhere" manifest for Claude Code.
# This single script is the source of truth for everything you want available in EVERY
# environment — your own toolkit plus curated skills authored by others.
#
# Same script, both harnesses — only the invocation differs:
#   - Cloud (Web): paste into the environment's "Setup script" field (or manage via /remote-env);
#     the environment runs it automatically at session start.
#   - Local (CLI): run it yourself once on a new machine. Prereqs: the `claude` CLI and a
#     GitHub login with access to the private repo (`gh auth login`). Then:
#         gh repo clone tenorune/didactic-robot
#         bash didactic-robot/setup/setup-script.sh
#
# Private same-owner repos install with no extra token (cloud sessions have account-level
# GitHub access). If a source ever lacks access, set GITHUB_TOKEN (PAT, repo scope) in the
# environment, or use a tokenized clone URL — see the fallback note at the bottom.
set -e

# add_marketplace <owner/repo> : tolerant of already-added marketplaces on re-run.
add_marketplace() { claude plugin marketplace add "$1" 2>/dev/null || true; }

# ---------------------------------------------------------------------------------------
# 1. Your own toolkit (private marketplace -> toolkit plugin)
# ---------------------------------------------------------------------------------------
add_marketplace "tenorune/didactic-robot"
claude plugin install "toolkit@didactic-robot"

# ---------------------------------------------------------------------------------------
# 2. Curated skills created by others, loaded everywhere.
#    Two ways to reference an external skill from upstream:
#      (a) marketplace plugin  -> add_marketplace + claude plugin install
#      (b) loose skill repo     -> git clone into ~/.claude/skills/<name>
#    Keep this list curated; add/remove entries as your "load everywhere" set evolves.
# ---------------------------------------------------------------------------------------

# (a) superpowers core skills library
add_marketplace "obra/superpowers-marketplace"
claude plugin install "superpowers@superpowers-marketplace"

# (b) VibeSec — security-review skill distributed as a loose repo
if [ ! -d "$HOME/.claude/skills/VibeSec-Skill" ]; then
  git clone https://github.com/BehiSecc/VibeSec-Skill "$HOME/.claude/skills/VibeSec-Skill"
fi

echo "Load-everywhere set ready: toolkit + curated external skills installed."

# --- Fallback for a PRIVATE external source that needs auth -----------------------------
# Set GITHUB_TOKEN (PAT with read access) in the environment, then either re-run the add
# (GITHUB_TOKEN/GH_TOKEN is honored), or clone explicitly:
#   git clone "https://x-access-token:${GITHUB_TOKEN}@github.com/<owner>/<repo>.git" \
#     "$HOME/.claude/skills/<name>"
