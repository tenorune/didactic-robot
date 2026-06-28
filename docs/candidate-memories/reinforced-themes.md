# Reinforced themes — augmentations to existing shipped memories

These cross-project themes from the harvest are **not net-new** — each one reinforces or
refines a memory the toolkit already ships. Rather than add duplicate files, fold the noted
**addition** into the existing memory (or its output-style rule). All wording here is already
generic/scrubbed.

**Status (2026-06-28): FOLDED into the live files.** Each theme is now in the memory/output-style noted
in its entry — `structured-choices` (#2, #4), `execution-cadence` (#1, #6), `evidence-before-claims`
(#3), `git-commit-identity` (#8, #10-real-name), `no-memory-rules-in-repo` (#10-files),
`runtime-agnostic-core` (#7-reuse), and the disciplined output style (#9-gerund). #5 (commit-gating)
was already fully covered by `commit-push-only-when-asked`/`dont-push-to-merge`/`branch-workflow`
(incl. the solo-repo/trunk shape) — nothing added. **One facet left unfolded:** #7's *idempotence =
true no-op (no churn)* has no clean shipped home — kept here as a note for a possible future memory.

> Net-new themes live as their own files alongside this one
> (`paste-ready-deliverables`, `do-exactly-whats-asked`, `config-secrets-via-gitignored-env`,
> `durable-handoff-artifacts`, `user-owns-outward-actions`,
> `authorize-destructive-actions-per-occasion`).

---

## 1. Terse / low-ceremony interaction  →  augments `execution-cadence` + `structured-choices`
**Most pervasive theme in the harvest (8 projects).**
**Addition:** single-token replies are the *complete* message — a pick (`A`/`1`), a bare `yes`/`ok`/`go`,
an explicit `skip`, a `done.`/`good.`/`thanks` close-out, or a terse authorization. Act on minimal
input; don't bounce back "to confirm…" or "want me to elaborate?" unless genuinely ambiguous, don't
re-litigate after a terse choice, and don't read dissatisfaction into a terse closer (match the
register, ≤2 sentences).

## 2. Ask inline on Web, never the AskUserQuestion UI  →  refines `structured-choices`
**RESOLVED (user, 2026-06): the AskUserQuestion picker is poorly designed for the user's eyes on
Web; the CLI interactive Q&A is fine.** So this is surface-conditional, not a contradiction.
**Addition:** on Claude Code **Web**, ask all clarifying questions and present options as plain inline
chat text (numbered/lettered so they can answer with one token) — never the AskUserQuestion /
multiselect picker. In the **CLI**, the structured interactive Q&A is fine. `structured-choices`
(recommendation-first, bounded options) still holds; only the *Web rendering* changes.

## 3. Diagnose & verify before asserting/changing  →  augments `evidence-before-claims` + `systematic-debugging`
**Addition:** don't assert a cause from speculation. The user brings raw evidence (curl output,
DevTools Network, logs, screenshots) and expects the analysis to update against it, even when it
overturns a confident prior read. Treat a phrasing like "I thought X?" as a verify-request, not idle
wondering, and offer the exact command/probe that would produce the decisive evidence.

## 4. Decision-support: recommend + options  →  augments `structured-choices`
**Addition:** lead with a recommendation *and why*, then 2–4 alternatives — and for non-trivial
refactors/design choices include an explicit benefits/risks (blast-radius) framing and be willing to
recommend *against* the change. When a recommendation is given the user reliably picks it; when it's
withheld they stall and ask clarifying questions. Don't make them choose blind among equal options.

## 5. Commit/push/PR gated; maintainer owns merges  →  augments `commit-push-only-when-asked` + `dont-push-to-merge` + `branch-workflow`
**Addition:** never push to shared/long-lived branches (dev, main, release/*) or open PRs unless asked
for that occasion; push only the assigned feature/session branch and let the user merge. Treat
"commit X to dev" / "merge it" as single-occasion permission. **Exception:** on a *solo* repo the user
pushes straight to main and skips PRs — the gate is for *collaborative* repos.

## 6. Brainstorm/spec/plan + approval before building  →  augments `execution-cadence`
**Addition:** for non-trivial features the user runs the "superpowers" chain — brainstorm → written
spec → written plan → subagent-driven execution (per-task review) → finish — and approves the design
before any code. Propose the workflow and get a go-ahead (or a short design) before building; small
work needs only a one-line plan + confirmation.

## 7. Engineering taste: portability, reuse, clean side-effects  →  augments `runtime-agnostic-core` + `ship-safe-part-first`
**Addition:** these ship as *user* values, not just toolkit-internal: prefer portability over lock-in
(runnable across hosts/runtimes via adapters), invest in reusable/modular scaffolding over one-offs,
make idempotent operations a *true* no-op (no churn commits/writes/downloads when nothing changed),
and challenge complexity-adding assumptions (lean on platform-native capability before adding infra).
Ship the usable part first and layer complexity after.

## 8. Strip personal/internal details from shareable artifacts  →  augments `no-personal-identifiers`
**Addition:** before emitting anything the user will paste elsewhere (a handoff, release notes, a PR
body), strip personal email and real name, internal-config references (e.g. `CLAUDE.md`), and the
model identifier — keep those to chat only. This is the *active-correction* facet: it has been a
fresh, emphatic correction, not just a standing rule.

## 9. Gerund openers, not "Let me…"  →  augments the shipped output style
**Addition:** open action narration with a gerund or imperative-noun phrase ("Reading…", "Verifying…",
"Adding…"), not "Let me read/verify/add…". A pure phrasing rule, applies every turn.

## 10. Privacy / repo-hygiene sharpenings  →  augment `no-personal-identifiers` + `no-memory-rules-in-repo`
**Additions:**
- **Real name:** even a *surname initial* used as a placeholder is off-limits; when you find an
  offending reference, sweep it without asking, and use neutral language in the scrub commit message
  (don't name the offending token). Use clearly-fictional generic placeholders.
- **Memory/instruction files:** a *minimal, user-maintained* `CLAUDE.md` of genuine project
  conventions is fine; don't *create* a `CLAUDE.md`/`AGENTS.md` for agent preferences or expand an
  existing one — keep cross-session rules in the memory layer (this harvest), not committed repo files.
