---
name: push-so-user-can-review-on-remote
description: On Web sessions the agent's local artifacts are invisible to the user (cloud sandbox) — push or surface work so they can review it on the remote, especially at integration
metadata:
  type: feedback
---

On Claude Code **Web** sessions, anything the agent generates locally — code, a doc, a mockup, a
status file — lives only in the cloud sandbox and is **invisible to the user**. They review on the
remote (GitHub), so describing a local artifact is not enough; they cannot see it until it is
pushed or otherwise surfaced. (Less acute in the CLI, where the filesystem is shared — but the
review-on-the-remote habit still applies.)

**Why:** the user can only act on what they can see, and a local-only artifact in a Web sandbox
might as well not exist to them. This bites hardest when work is ready to review or about to
merge to the integration branch.

**How to apply:** to let the user see or review *repo* content, push the branch to the remote
(still confirming per [[commit-push-only-when-asked]] — "show me X", "is it ready?", or a review
request is that signal). For content that is not a repo file (a summary, a handoff/kickoff
message), surface it as a paste-able block instead ([[paste-ready-deliverables]]). Don't leave
something the user asked to see sitting only in the sandbox. Relates: [[branch-hygiene]]
(keep the branch current before they review it).
