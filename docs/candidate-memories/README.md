# Candidate memories

Staging area for memory fact-files that are **tracked in the repo but not shipped** by the
`toolkit` plugin. The plugin only loads memories under `plugins/toolkit/memories/`; nothing here
is in scope for a live session.

Use this folder to draft, review, and keep history on a memory before deciding whether it earns a
place in the shipped set. To promote one: move it into `plugins/toolkit/memories/` and add a line
to that directory's `MEMORY.md` index.

The drafts below came from a multi-project review of past sessions. All are written
generic/scrubbed (no project names or identifiers). Several have since been **promoted** (marked ✅ below and moved into the shipped set); the rest remain sifting drafts.

**Confirmed candidates** (the harvest *and* the user's own stored memories on a second machine
independently produced these):

| Candidate | Status |
|-----------|--------|
| `memory-portability-audience.md` | Portable-vs-local memory-placement rule. Confirmed both ways. Strong promote candidate. |
| `backup-claude-state-for-machine-switching.md` | Personal-infra practice (state backup for machine-switching), built and running. Confirmed; may stay user-level only. |

**Net-new theme drafts** (no shipped equivalent; ≥2–3 projects each):

| Candidate | Status |
|-----------|--------|
| `paste-ready-deliverables.md` | ✅ **PROMOTED** (2026-06-28) → `plugins/toolkit/memories/`. Copy-paste output as one self-contained block; matters most on Web, CLI copy-paste fine. |
| `do-exactly-whats-asked.md` | ✅ **PROMOTED** (2026-06-28) → `plugins/toolkit/memories/`. Scope discipline: change only what's asked; recommend extras, don't auto-apply. |
| `config-secrets-via-gitignored-env.md` | Secrets/config/identity in a gitignored `.env` + committed `.env.example`. |
| `durable-handoff-artifacts.md` | ✅ **PROMOTED** (2026-06-28) → `plugins/toolkit/memories/`. In-repo docs as cross-session memory; read on start, update at end. |
| `user-owns-outward-actions.md` | Agent drafts + pushes branches; user merges/publishes/posts/tags. |
| `authorize-destructive-actions-per-occasion.md` | Per-occasion consent + a checklist before irreversible ops. |
| `branch-hygiene.md` | ✅ **PROMOTED** (2026-06-28) → `plugins/toolkit/memories/`. Descriptive announced branch names; keep the branch synced with integration; one concern per branch. Complements shipped `branch-workflow` (which covers only where-to-cut + who-merges). |
| `push-so-user-can-review-on-remote.md` | ✅ **PROMOTED** (2026-06-28) → `plugins/toolkit/memories/`. On Web, local artifacts are invisible (sandbox), so push/surface them; user reviews on the remote. |
| `offer-to-file-followups-as-issues.md` | ✅ **PROMOTED** (2026-06-28) → `plugins/toolkit/memories/`. Offer to file out-of-scope work as a GitHub issue (symptom + root-cause + fix path). |
| `idempotent-operations-true-no-op.md` | An idempotent op leaves no trace when nothing changed (no churn commits/writes/downloads). Preserved from reinforced #7 — no clean shipped home to fold into. |

**Reinforced themes** (augment memories the toolkit already ships — fold in rather than add files):

| Candidate | Status |
|-----------|--------|
| `reinforced-themes.md` | ✅ **FOLDED** (2026-06-28) into the live memories + output style (see the file's status note). One facet left unfolded: idempotence/no-churn — **now preserved as `idempotent-operations-true-no-op.md`** (above). |
