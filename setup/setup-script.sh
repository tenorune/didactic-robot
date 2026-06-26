#!/bin/bash
# Canonical "load everywhere" manifest for Claude Code.
# Single source of truth for everything you want in EVERY environment — curated external
# skills plus your own private toolkit.
#
# Same script, both harnesses — only the invocation differs:
#   - Cloud (Web): paste into the environment's "Setup script" field (or manage via /remote-env).
#   - Local (CLI): run once on a new machine (needs the `claude` CLI + `gh auth login`):
#         gh repo clone tenorune/didactic-robot
#         bash didactic-robot/setup/setup-script.sh
#
# ORDERING MATTERS: do the PUBLIC external installs FIRST, then the PRIVATE toolkit LAST.
# Authenticating to a private repo appears to reconfigure git credentials for the cloud git
# proxy, which then 403s a subsequent public clone. Public-first avoids that.
set -e

# ---------------------------------------------------------------------------------------
# 1. Curated skills created by others (PUBLIC, upstream). Done first.
# ---------------------------------------------------------------------------------------
claude plugin marketplace add obra/superpowers-marketplace
claude plugin install superpowers@superpowers-marketplace

git clone https://github.com/BehiSecc/VibeSec-Skill "$HOME/.claude/skills/VibeSec-Skill"

# ---------------------------------------------------------------------------------------
# 2. Your own toolkit (PRIVATE marketplace -> toolkit plugin). Done last.
# ---------------------------------------------------------------------------------------
claude plugin marketplace add tenorune/didactic-robot
claude plugin install toolkit@didactic-robot

echo "Ready: superpowers + VibeSec + toolkit installed."
