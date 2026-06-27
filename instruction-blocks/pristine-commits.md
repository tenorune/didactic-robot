# Pristine commits

Paste the section below into a project's `CLAUDE.md` to hold every commit to a clean build/test
bar. Or `@import` the file instead:

```
@<path-to-didactic-robot>/instruction-blocks/pristine-commits.md
```

## Quality bar: pristine commits

- Hold each commit to a pristine bar: it builds, tests pass, and it introduces no new
  compiler/linter warnings in the files it touches — not just no new errors.
- Before committing, read the actual build/test output and clear any warnings in your changed
  files. Don't assume the output is clean — check it.
- "Pristine output" is the standard; don't let warning noise accumulate commit over commit.
