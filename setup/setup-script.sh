#!/bin/bash
# Cloud environment Setup Script for Claude Code on the Web.
# Paste this into the environment's "Setup script" field (or manage via /remote-env).
# Goal of this spike: confirm a PRIVATE same-owner marketplace installs in a cloud env.
set -e

OWNER_REPO="tenorune/didactic-robot"   # private marketplace repo (same GitHub account)
MARKETPLACE="didactic-robot"           # = "name" in .claude-plugin/marketplace.json
PLUGIN="toolkit"

# Attempt 1 (expected to work): cloud sessions have account-level GitHub access, so the
# marketplace add should authenticate via the environment's existing GitHub credentials.
claude plugin marketplace add "$OWNER_REPO"
claude plugin install "${PLUGIN}@${MARKETPLACE}"

echo "Toolkit ready: installed ${PLUGIN}@${MARKETPLACE} from ${OWNER_REPO}."

# --- Fallback (only if Attempt 1 fails with an auth/clone error) -------------------------
# Set GITHUB_TOKEN (a PAT with `repo` scope) in the environment settings, then either:
#   1) rely on GITHUB_TOKEN being honored by `claude plugin marketplace add` (re-run above), or
#   2) clone the marketplace explicitly with a tokenized URL, e.g.:
#        git clone "https://x-access-token:${GITHUB_TOKEN}@github.com/${OWNER_REPO}.git" \
#          "$HOME/didactic-robot"
#        claude plugin marketplace add "$HOME/didactic-robot"
#        claude plugin install "${PLUGIN}@${MARKETPLACE}"
