---
name: change-scope
description: Use when a task needs the set of code changes to work on, for example a code review, a summary of changes, or a PR description. Finds the changes from a commit, branch, PR number or URL, or the local working tree, with a git-only fallback for PRs.
---

# Change Scope

Find the changes that a task applies to, from an optional input. Use only read-only commands: do not stage, commit, check out, reset, or stash anything.

## Pick the source

Pick the source from the input. If the input is ambiguous, use your judgement and state which source you picked.

| Input | Source |
|---|---|
| None | [Local changes](#local-changes) |
| Short or full commit SHA | `git show <sha>` |
| Branch name | `git diff <branch>...HEAD` |
| PR number, `#123`, or PR URL | [Pull request](#pull-request) |

To tell a SHA from a branch name, check with `git rev-parse --verify --quiet <input>^{commit}` and `git show-ref --verify --quiet refs/heads/<input>`.

## Local changes

Use the first step that has changes:

1. Staged changes: `git diff --cached`.
2. Unstaged changes, `git diff`, and untracked files from `git status --short`. Untracked files are not in the diff, so read them in full.
3. The current branch against its parent branch:
   ```sh
   fish -c 'git diff (git_parent_branch)...HEAD'
   ```
   If `fish` or `git_parent_branch` is not available, or it prints nothing, use the default branch:
   ```sh
   git diff "$(git symbolic-ref --short refs/remotes/origin/HEAD)...HEAD"
   ```

If no step has changes, say so and stop.

## Pull request

### With `gh`

1. Get the context: `gh pr view <pr> --json number,title,body,baseRefName,headRefName,url`.
2. Get the diff: `gh pr diff <pr>`.

### Git fallback

Use this fallback if `gh` is not installed, is not authenticated, or fails.

1. Get the PR number from the input. For a URL such as `https://github.com/<owner>/<repo>/pull/<n>`, also get `<owner>/<repo>`.
2. Pick the remote:
   - If the URL repo matches a remote in `git remote -v`, use that remote.
   - If there is no URL, use `origin`.
   - If no remote matches, use the URL `https://github.com/<owner>/<repo>.git` as the remote.
3. Find the base branch. Without `gh` the PR base is not known, so use the default branch of the remote:
   ```sh
   base_branch=$(git ls-remote --symref <remote> HEAD | sed -n 's|^ref: refs/heads/\(.*\)\tHEAD|\1|p')
   ```
   If you already know the base from the PR context, use it instead.
4. Fetch the base and the PR head without a checkout. Read `FETCH_HEAD` right after each fetch, because the next fetch replaces it:
   ```sh
   git fetch <remote> "$base_branch" && base=$(git rev-parse FETCH_HEAD)
   git fetch <remote> "pull/<n>/head" && head=$(git rev-parse FETCH_HEAD)
   ```
5. Get the diff and the commits:
   ```sh
   git diff "$base...$head"
   git log --oneline "$base..$head"
   ```

Tell the user that you used the fallback, and which base branch you assumed.

## Result

Report in one line which source you used and which files changed. Then continue with the task that asked for the changes.
