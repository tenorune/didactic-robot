#!/bin/bash
# LOCAL (CLI) installer for the toolkit + curated external skills. Run once on a new machine
# (needs the `claude` CLI + `gh auth login` with access to the private repo):
#     gh repo clone tenorune/didactic-robot
#     bash didactic-robot/setup/setup-script.sh
#
# SCOPE — CLI ONLY (repo is PRIVATE). Claude Code on the WEB is intentionally out of scope:
# verified 2026-06-26 that the cloud Setup Script phase 403s EVERY clone (own/other, public/
# private, git clone and `claude plugin marketplace add`), so no Setup-Script install works there.
# Rationale: docs/superpowers/specs/2026-06-26-shared-toolkit-design.md ("Cloud (Web) install").
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
  echo "WARNING: skipped superpowers (public repo — likely a transient upstream/network issue) — continuing"
fi

if [ -d "$HOME/.claude/skills/VibeSec-Skill" ]; then
  echo "external: VibeSec-Skill already present"
elif git clone https://github.com/BehiSecc/VibeSec-Skill "$HOME/.claude/skills/VibeSec-Skill"; then
  echo "external: VibeSec-Skill cloned"
else
  echo "WARNING: skipped VibeSec-Skill (public repo — likely a transient upstream/network issue) — continuing"
fi

echo "Done: core toolkit installed; externals best-effort."
exit 0
