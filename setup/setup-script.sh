#!/bin/bash
# Canonical "load everywhere" manifest for Claude Code.
#
# Same script, both harnesses — only the invocation differs:
#   - Cloud (Web): paste into the environment's "Setup script" field (or manage via /remote-env).
#   - Local (CLI): run once on a new machine (needs the `claude` CLI + `gh auth login`):
#         gh repo clone tenorune/didactic-robot
#         bash didactic-robot/setup/setup-script.sh
#
# Design rule: the CORE toolkit (private, same-owner) MUST succeed. Curated EXTERNAL skills are
# best-effort — in some cloud environments the git proxy 403s other-owner repos, and that must
# never fail setup or block the session.

# ---------------------------------------------------------------------------------------
# 1. Core: your own toolkit (private marketplace -> toolkit plugin). Must succeed.
# ---------------------------------------------------------------------------------------
set -e
claude plugin marketplace add tenorune/didactic-robot
claude plugin install toolkit@didactic-robot
echo "core: toolkit@didactic-robot installed."
set +e   # below: external failures must NOT abort setup or fail the session

# ---------------------------------------------------------------------------------------
# 2. Curated skills created by others (best-effort).
# ---------------------------------------------------------------------------------------
if claude plugin marketplace add obra/superpowers-marketplace \
   && claude plugin install superpowers@superpowers-marketplace; then
  echo "external: superpowers@superpowers-marketplace installed"
else
  echo "WARNING: skipped superpowers (cloud proxy may block other-owner repos) — continuing"
fi

if [ -d "$HOME/.claude/skills/VibeSec-Skill" ]; then
  echo "external: VibeSec-Skill already present"
elif git clone https://github.com/BehiSecc/VibeSec-Skill "$HOME/.claude/skills/VibeSec-Skill"; then
  echo "external: VibeSec-Skill cloned"
else
  echo "WARNING: skipped VibeSec-Skill (cloud proxy may block other-owner repos) — continuing"
fi

echo "Done: core toolkit installed; externals best-effort."
exit 0
