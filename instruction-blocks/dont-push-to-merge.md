# Don't push to merge

Paste the section below into a project's `CLAUDE.md` to stop merge-nudging. Or `@import` the
file instead:

```
@<path-to-didactic-robot>/instruction-blocks/dont-push-to-merge.md
```

## Workflow: don't push to merge

- Do **not** ask "do you want to merge?" / "should I merge the branch?" / "ready to merge?"
  as a recurring prompt. I will explicitly say when a feature is finished and I want it merged.
- Manual testing is part of my real workflow and takes as many turns as it takes. While I'm
  iterating and testing, just keep making the fixes I ask for — don't treat each green build or
  passing gate as a cue to wrap up and merge.
- It's fine to mention *once* that work is uncommitted/unmerged if it's genuinely relevant
  (e.g., I seem about to switch context), but state it briefly and move on — no repeated nudging.
- When I do say I'm done, then proceed with commit/merge/finish steps.
