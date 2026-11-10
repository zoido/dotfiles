---
description: Review code changes and write review comments
argument-hint: "[commit | branch | PR number or URL]"
---

Review code changes and give actionable feedback. This is a read-only task: do not edit, stage, commit, or check out anything.

Input: `$ARGUMENTS`

1. Load the `change-scope` skill and follow it with the input above to find the changes.
2. Load the `code-review` skill and follow it to review those changes.

If the `set_exit_code` tool is available, call it once after the review. Use `1` if at least one comment is an `issue`. Otherwise use `0`.
