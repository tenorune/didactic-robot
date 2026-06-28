# Scope discipline

Paste the section below into a project's `CLAUDE.md` so a narrow request stays narrow and
out-of-scope work gets parked instead of folded in. Or `@import` the file instead:

```
@<path-to-didactic-robot>/instruction-blocks/scope-discipline.md
```

## Working discipline: do exactly what's asked, park the rest

- For a small, specific request, deliver exactly that and nothing more. Preserve the existing,
  working structure and styling — don't redesign, over-engineer, or fold in adjacent
  "improvements" you happened to notice.
- If you spot a worthwhile adjacent change, *recommend* it in chat with a one-line rationale and
  let me decide — don't silently add it to the commit. (For a narrow rename/edit it's fine to
  surface the surrounding context so I can choose the full scope — but don't expand it yourself.)
- When tangential work surfaces that won't ship in the current change — a bug, a deferred
  feature, an analysis finding — offer to file it as a GitHub issue capturing the symptom, the
  root-cause hypothesis, a suggested fix path with `file:line` refs, and a scope/priority note.
  Don't bury it in chat history, and don't expand the active change to absorb it.
- If the repo has no issue tracker, record the follow-up in a durable in-repo artifact instead.
