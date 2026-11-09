---
description: Review code changes and report actionable findings
argument-hint: "[commit | branch | PR number or URL]"
---

Review code changes and give actionable feedback. This is a read-only task: do not edit, stage, commit, or check out anything.

Input: `$ARGUMENTS`

1. Load the `change-scope` skill and follow it with the input above to find the changes.
2. Load the `code-review` skill and follow it to review those changes.

In the output, start the first line of each finding with the location as plain text: `path/to/file.ext:line`, relative to the repository root. Do not put backticks, brackets, or other characters around it, so it stays clickable. Then add the severity and the title:

```
path/to/file.ext:42 [bug] Short title
```

If the `set_exit_code` tool is available, call it once after the review. Use `1` if at least one finding is a `bug` or a `risk`. Otherwise use `0`.
