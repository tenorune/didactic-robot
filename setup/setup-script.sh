#!/bin/bash
# Loads the toolkit + curated external skills. Works in BOTH the Claude Code CLI and Claude Code
# on the Web (same commands).
#
# CLI: run once on a new machine —  bash didactic-robot/setup/setup-script.sh  (or paste the
#      commands). The toolkit repo is PUBLIC, so no auth is required.
#
# WEB: paste this body into the environment's Setup Script field. Conditions (verified 2026-06-26,
#      reproduced on 2 repos):
#        - the toolkit repo must be PUBLIC (no GH_TOKEN at build time to auth a private clone)
#        - the Claude GitHub App must be set to "All repositories" (else the external clones 403)
#        - run this TWICE on a repo: the FIRST run fails, an identical SECOND run succeeds
#          (mechanism unexplained; an in-script retry was TESTED and does NOT help — a fresh session
#          is required, not just elapsed time). A nonzero exit on run 1 is expected.
#      Full findings: docs/superpowers/specs/2026-06-26-shared-toolkit-design.md ("Cloud (Web)
#      install") + the cloud-git-proxy-blocks-other-owner-repos memory.
#
# This is the PROVEN script (each component installed independently; `exit $fail`). Keep it in sync
# with what is actually verified on Web — do not silently "improve" it without re-verifying.
fail=0

# Toolkit (own public repo: tenorune/didactic-robot)
claude plugin marketplace add tenorune/didactic-robot \
  && claude plugin install toolkit@didactic-robot \
  && echo "TOOLKIT=OK" || { echo "TOOLKIT=FAIL"; fail=1; }

# Superpowers (external marketplace)
claude plugin marketplace add obra/superpowers-marketplace \
  && claude plugin install superpowers@superpowers-marketplace \
  && echo "SUPERPOWERS=OK" || { echo "SUPERPOWERS=FAIL"; fail=1; }

# VibeSec (external skill, raw clone into ~/.claude/skills)
git clone https://github.com/BehiSecc/VibeSec-Skill ~/.claude/skills/VibeSec-Skill \
  && echo "VIBESEC=OK" || { echo "VIBESEC=FAIL"; fail=1; }

echo "=== setup done (fail=$fail) ==="
exit $fail
