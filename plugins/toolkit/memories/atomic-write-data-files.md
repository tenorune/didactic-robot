---
name: atomic-write-data-files
description: Write data files atomically — temp file + os.replace — so a crash never leaves a corrupt file
metadata:
  type: feedback
---

When persisting a data file that matters (state, inventory, config), don't write in place. Write to a temp file, then atomically swap it in: `os.replace(tmp, target)` (atomic on POSIX, and cross-platform — unlike `os.rename`, which fails on Windows when the destination exists).

**Why:** A crash or kill mid-write then leaves either the complete old file or the complete new one — never a truncated, corrupt mash.

**How to apply:** Any program that writes stateful files to disk. Language-agnostic; `os.replace` is the Python form (use the equivalent atomic-rename primitive elsewhere).
