#!/bin/bash
# LOCAL (CLI) installer for the toolkit + curated external skills.
# Run once on a new machine (needs the `claude` CLI + `gh auth login` with access to the repo):
#     gh repo clone tenorune/didactic-robot
#     bash didactic-robot/setup/setup-script.sh
#
# NOTE — Claude Code on the WEB is NOT covered by this script while the repo is PRIVATE.
# A private repo cannot be auto-loaded in a web session without per-repo committed files; see
# docs/superpowers/specs/2026-06-26-shared-toolkit-design.md ("Cloud (Web) install: OPEN
# DECISION"). If the repo is made PUBLIC, these same commands work as a web Setup Script.
#
# Design rule: the CORE toolkit MUST succeed. Curated EXTERNAL skills are best-effort — a
# renamed/unreachable upstream must never abort setup.

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
