---
description: Review code changes and post the review comments to tuicr
argument-hint: "[commit | branch | PR number or URL]"
---

Review code changes and give actionable feedback. This is a read-only task: do not edit, stage, commit, or check out anything. The only exception is the tuicr review session, where you add your review comments.

Input: `$ARGUMENTS`

1. Load the `change-scope` skill and follow it with the input above to find the changes.
2. Load the `code-review` skill and follow it to review those changes.
3. Post the comments to tuicr as described below.

## Post comments to tuicr

### Pick the tuicr scope

Map the source that `change-scope` picked to tuicr arguments:

| Source | tuicr arguments |
|---|---|
| Uncommitted changes | `-w` |
| Commit `<sha>` | `-r <sha>` |
| Base branch, or current branch against its parent | `-r <base>..HEAD` |
| Branch to look at | `-r <parent>..<branch>` |
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
3. If you still have no slug, print the comments in chat only, and say that the tuicr session could not be created.

### Add the comments

Add one tuicr comment for each `code-review` comment. Pass the comment type with `--type`, and pass only the comment text as the content. tuicr shows the type as a tag, so do not repeat the type or the location in the text:

```bash
tuicr review add --session "<slug>" --repo . \
  --username "pi ($PI_MODEL)" \
  --type <type> \
  --target-file <path> --line <line> [--end-line <line>] [--side old] \
  "<comment text>"
```

- Use only the type ids from the `code-review` skill: `qq`, `optional`, `nit`, `issue`, `fyi`, `nice`. They replace the default tuicr types (`issue`, `suggestion`, `note`, `praise`) in the `tuicr` skill. If tuicr warns that a type is not configured, the comment is still stored. Tell me about the warning in the report.
- Anchor each comment to lines that are in the diff. Use `--side old` only for removed lines.
- If a comment has no line in the diff, omit `--line` to make a file-level comment.
- If a comment is not about one file, omit `--target-file` to make a review-level comment.
- If tuicr fails with `session does not contain file`, add it as a review-level comment and put `path:line` at the start of the text. tuicr does not add new files to an existing session.
- Add each comment once. If a command fails, fix the arguments and retry only that comment.

### Report

In chat, give the one-line scope summary, the session slug, and a short list of the comments: type, `path:line`, and the first sentence of the text. Then tell me the command that opens the review, for example `tuicr -w` or `tuicr pr 123`.
