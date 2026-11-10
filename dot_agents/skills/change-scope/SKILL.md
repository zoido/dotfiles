---
name: change-scope
description: Use when a task needs the set of code changes to work on, for example a code review, a summary of changes ("what changed", "summarize my changes", "what is new since main"), or a PR description. Finds the changes from a commit, branch, PR number or URL, or the local working tree, with a git-only fallback for PRs.
---

# Change Scope

Find the changes that a task applies to, from an optional input. Use only read-only commands: do not stage, commit, check out, reset, or stash anything.

## Pick the source

Pick the source from the input. If the input is ambiguous, use your judgement and state which source you picked.

| Input | Source |
|---|---|
| None | [Local changes](#local-changes) |
| Local or remote branch name, for example `main` or `origin/main` | [Branch](#branch) |
| Short or full commit SHA | `git show <sha>` |
| PR number, `#123`, or PR URL | [Pull request](#pull-request) |

Check for a branch first, and only then for a commit. A branch name also resolves as a commit, and `git show` would then show only its last commit.

1. Local branch: `git show-ref --verify --quiet refs/heads/<input>`.
2. Remote branch: `git show-ref --verify --quiet refs/remotes/<input>`.
3. Commit: `git rev-parse --verify --quiet <input>^{commit}`.

## Branch

A branch can be the base to compare against ("what is new since main") or the branch to look at ("review z/foo"). Decide with `git merge-base --is-ancestor <branch> HEAD`:

- It is an ancestor of `HEAD` and does not point at `HEAD`: it is the base. Use `git diff <branch>...HEAD` and `git log --oneline <branch>..HEAD`.
- Otherwise it is the branch to look at. Compare it with its parent branch: `git diff <parent>...<branch>` and `git log --oneline <parent>..<branch>`. If git-spice tracks the branch, `gs ls --all` shows its parent. Otherwise use the [default branch](#default-branch).

State which way you read it.

## Local changes

Use the first step that has changes:

1. Uncommitted changes: `git diff HEAD` shows staged and unstaged changes together. Also list untracked files with `git status --short`. Untracked files are not in the diff, so read them in full.
2. The current branch against its parent branch:
   ```sh
   fish -c 'git diff (git_parent_branch)...HEAD'
   ```
   If `fish` or `git_parent_branch` is not available, or it prints nothing, use the [default branch](#default-branch): `git diff <default>...HEAD`.

If no step has changes, say so and stop.

## Default branch

Use the first one that works:

1. `git symbolic-ref --short refs/remotes/origin/HEAD`. This is often not set in local clones.
2. `origin/main` or `origin/master`, whichever `git rev-parse --verify --quiet` finds.
3. The local `main` or `master` branch.

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
