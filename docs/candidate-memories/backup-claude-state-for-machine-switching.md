---
name: backup-claude-state-for-machine-switching
description: Proactively back up portable Claude state (memories, skills, settings, env) to external storage so switching machines needs no manual sync; keep the restore doc in sync with the backup script
metadata:
  type: feedback
---

Keep a portable backup of your Claude working state — global instructions, memories, skills,
settings, env files — in external storage, so moving between machines is a restore, not a rebuild.

**How to apply:** Maintain a script that bundles the backed-up files/dirs to the external
location, and run it proactively after any change to that state (new/edited memory, skill,
settings, env, or the script itself) rather than waiting to be asked. Keep a machine-setup/
restore doc alongside the backup and update it whenever the script's scope or process changes —
drift between script and doc breaks restores.

**Why:** State spread across `~/.claude` and repos is easy to lose when switching machines; a
current backup plus an accurate restore doc makes a new machine a quick restore.
