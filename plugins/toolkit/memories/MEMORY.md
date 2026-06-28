# Toolkit Shared Memory — Index

One line per fact-file. Read a file only when its hook matches the current task; do not bulk-read.

- [Git commit identity](git-commit-identity.md) — the only identity allowed in commits/code/docs/output; never leak real name/email; scan generically
- [Branch workflow](branch-workflow.md) — develop on branches, never on shared branches; integration model varies per repo (default: dev if present)
- [Branch hygiene](branch-hygiene.md) — descriptive announced branch names (not autogen); keep the branch synced with integration; one concern per branch
- [Don't push to merge](dont-push-to-merge.md) — no recurring "ready to merge?" nudging; the user says when done
- [Commit/push only when asked](commit-push-only-when-asked.md) — never commit or push unprompted
- [Push so the user can review on the remote](push-so-user-can-review-on-remote.md) — on Web, local artifacts are invisible (sandbox); push/surface so the user can see it
- [Evidence before claims](evidence-before-claims.md) — report OBSERVED vs UNKNOWN; don't conclude from one run
- [Publishable tooling defaults](publishable-tooling-defaults.md) — env-based config, no secrets in code, vendor-agnostic
- [Execution cadence](execution-cadence.md) — terse confirmations mean keep going; scale review depth to risk
- [docs/lessons.md pattern](docs-lessons-file.md) — keep a consult-before/append-after lessons file for codebase gotchas
- [Durable handoff artifacts](durable-handoff-artifacts.md) — in-repo docs are the real cross-session memory; read on start, update at end
- [Offer to file follow-ups as issues](offer-to-file-followups-as-issues.md) — out-of-scope work: offer a GitHub issue (symptom + root cause + fix path)
- [Warn before web-research fan-out](web-research-auto-mode.md) — suggest CLI AUTO mode first; Edit mode prompts per domain
- [Manual visual gate](manual-visual-gate.md) — for UI/visual work, the user's hands-on walkthrough is the acceptance gate; green build ≠ done
- [Structured choices](structured-choices.md) — offer bounded options (A/B/C) over open-ended questions
- [Do exactly what's asked](do-exactly-whats-asked.md) — for a narrow request change only that; recommend extras, don't auto-apply
- [Paste-ready deliverables](paste-ready-deliverables.md) — copy-paste output as one clean block; matters most on Web, CLI fine
- [Pristine commits](pristine-commits.md) — every commit builds + tests pass with no new warnings in touched files
- [Show don't tell visuals](show-dont-tell-visuals.md) — for visual decisions, offer to generate a real mockup; ask before rendering
- [Release process](release-process.md) — main green via CI → manual smoke on target → version tag publishes; no stored tokens
- [No telemetry](no-telemetry.md) — published tools commit to no analytics/telemetry/error-reporting
- [Pre-release secret scan](pre-release-secret-scan.md) — grep build/dist output for secrets + host paths before shipping
- [Atomic write data files](atomic-write-data-files.md) — temp file + os.replace so a crash never leaves a corrupt file
- [Rebuild before manual test](rebuild-before-manual-test.md) — stale build is the #1 cause of phantom bugs
- [Ship safe part first](ship-safe-part-first.md) — ship the clean part now; file the risky remainder as its own issue
- [No memory rules in repo](no-memory-rules-in-repo.md) — centralize personal rules; project repos hold technical conventions only
- [Ask before bumping versions](version-bumps-ask-first.md) — never bump a version unprompted; versioning marks significant changes, not every commit
- [n=1 abstraction](n=1-abstraction.md) — don't abstract from a single instance; wait for the 2nd/3rd real use before generalizing
- [Runtime-agnostic core](runtime-agnostic-core.md) — keep core logic platform-neutral; isolate host bindings at thin edges
- [Fail-closed defaults](fail-closed-defaults.md) — on error/uncertainty default to the safe/restrictive state, never permissive
