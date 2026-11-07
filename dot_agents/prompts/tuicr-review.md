---
description: Review code changes and post findings as tuicr comments
argument-hint: "[commit | branch | PR number or URL]"
---

Review code changes and give actionable feedback. This is a read-only task: do not edit, stage, commit, or check out anything. The only exception is the tuicr review session, where you add your findings as comments.

Input: `$ARGUMENTS`

1. Load the `change-scope` skill and follow it with the input above to find the changes.
2. Load the `code-review` skill and follow it to review those changes.
3. Post the findings to tuicr as described below.

## Post findings to tuicr

### Pick the tuicr scope

Map the source that `change-scope` picked to tuicr arguments:

| Source | tuicr arguments |
|---|---|
| Staged or unstaged changes | `-w` |
| Commit `<sha>` | `-r <sha>` |
| Branch, or current branch against its parent | `-r <base>..HEAD` |
| Pull request `<n>` | `pr <n>` |

### Find or create the session

Run all `tuicr` commands from the repository root.

1. Run `tuicr review list --repo .` and look for a session whose slug matches the scope. The slug contains the source, for example `…/staged-and-unstaged/<head>`, `…/commits/<a>..<b>`, or `gh:<owner>/<repo>/pr/<n>`.
2. If no session matches, create one. Only the tuicr TUI can create a session, so start it in a pseudo-terminal, wait until it reports a new active session, and then kill it:

   ```bash
   before=$(tuicr review list --repo . | jq -r '.[] | select(.active) | .slug')
   script -qc "tuicr --no-update-check <tuicr arguments>" /dev/null >/dev/null 2>&1 &
   pid=$!
   slug=
   for _ in $(seq 120); do
     sleep 0.25
     slug=$(tuicr review list --repo . | jq -r '.[] | select(.active) | .slug' | grep -vxF -e "$before" -e '' | head -n1)
     [ -n "$slug" ] && break
   done
   kill -KILL "$pid" 2>/dev/null
   echo "$slug"
   ```

   Kill it with `SIGKILL`. On a normal exit, tuicr deletes a session that has no comments. If the script prints no slug, tuicr found no changes for the scope or failed to start.
3. If you still have no slug, print the findings in chat only, and say that the tuicr session could not be created.

### Add the comments

Add one comment for each finding. Use the `code-review` finding text without the location line:

```bash
tuicr review add --session "<slug>" --repo . \
  --username "pi ($PI_MODEL)" \
  --target-file <path> --line <line> [--end-line <line>] [--side old] \
  "[<severity>] <short title>

<what is wrong>

Suggested fix: <fix>"
```

- Anchor each comment to lines that are in the diff. Use `--side old` only for removed lines.
- If a finding has no line in the diff, omit `--line` to make a file-level comment.
- If a finding is not about one file, omit `--target-file` to make a review-level comment.
- If tuicr fails with `session does not contain file`, add the finding as a review-level comment and put `path:line` at the start of the text. tuicr does not add new files to an existing session.
- Add each comment once. If a command fails, fix the arguments and retry only that comment.

### Report

In chat, give the one-line scope summary, the session slug, and a short list of the findings: severity, `path:line`, and title. Then tell me the command that opens the review, for example `tuicr -w` or `tuicr pr 123`.
