---
name: git-branch-stacking
description: Use when working with branch stacks, splitting a change into multiple dependent branches or PRs, creating dependent branches, submitting stacked PRs to GitHub, restacking after a parent branch changed, syncing after a stacked PR merged, or reorganizing branch dependencies. Use it even when the user only says "split this into smaller PRs" or "put this on top of my other branch". Covers managing and navigating stacked Git branches with git-spice (gs).
---

# Git Branch Stacking with git-spice

git-spice (`gs`) manages stacked branches: each branch builds on the one below it, so every PR stays small and focused.

## Run commands without prompts

You cannot answer prompts or use an editor. Many `gs` commands open one when an argument is missing, and the command then hangs or fails. So:

- Pass every name, target, and message as an argument.
- Add `--no-prompt` when a command could still ask for something.
- Give commit messages with `-m`, or use `--no-edit` to keep the existing message.
- Do not use commands that are always interactive: `gs branch checkout` without a name, and `gs commit split`, which asks you to pick hunks.

Commit messages follow the `pr-guidelines` skill. In the examples below, `<message>` stands for such a message.

## Setup

git-spice stores its state in `.git/spice`. If that is missing, initialize it:

```bash
gs repo init --trunk main --no-prompt
```

## Branch names

Name branches as the user's rules say. The examples below use `z/feature=part1`.

## See the stack

```bash
gs ls          # Branches in the current stack (gs log short)
gs ll          # Branches and their commits (gs log long)
gs ls --all    # All tracked branches
```

Check the stack before and after you change it, so you know which branch you are on and what is above it.

## Create a stack

```bash
gs trunk                                          # Check out the trunk branch
git add <files>
gs branch create z/feature=part1 -m "<message>"   # Commits the staged changes
git add <files>
gs branch create z/feature=part2 -m "<message>"   # Stacks on part1
```

A new branch always stacks on the current branch. Use `--target <branch>` to stack on a different one, and `--insert` or `--below` to put it inside an existing stack.

Track a branch that was created with plain git:

```bash
gs branch track z/existing-branch --base <parent-branch>
```

## Navigate

```bash
gs up | gs down | gs top | gs bottom | gs trunk
gs branch checkout z/feature=part2   # Always pass the name
```

## Commit

Use the `gs` commit commands instead of `git commit`. They restack the branches above the current one, so the stack stays consistent.

```bash
gs commit create -m "<message>"   # gs cc
gs commit amend --no-edit                           # gs ca, keeps the message
gs commit fixup <sha>                               # Puts staged changes into an older commit below HEAD
```

## Split and reorganize

```bash
gs branch split --at HEAD~2:z/feature=part1 --at HEAD~1:z/feature=part2   # Split a branch at commits
gs branch onto <new-base>        # Move only this branch. The branches above stay on the old base.
gs upstack onto <new-base>       # Move this branch and everything above it
gs branch fold                   # Merge this branch into its base and delete it
gs branch squash -m "<message>"  # Squash this branch into one commit
gs branch rename <new-name>
gs branch delete <branch>
```

To split one commit without `gs commit split`, undo it with `git reset HEAD~`. Then stage each part with `git add <files>` (or `git apply --cached <patch>` for parts of a file) and commit it with `gs commit create -m`.

## Restack

When a branch below changed, for example after you amended it or the trunk moved:

```bash
gs upstack restack   # This branch and the branches above it
gs stack restack     # The whole stack
```

If a restack stops because of a conflict:

1. Run `git status` to see the files with conflicts, and fix them.
2. `git add <files>`
3. `gs rebase continue --no-edit`

To give up, run `gs rebase abort`. Do not use `git rebase --continue` here, because it does not resume the git-spice operation.

## Submit PRs

PRs must be drafts by default (see the `pr-guidelines` skill). Always pass `--draft` unless the user asks for a ready PR, because without `spice.submit.draft` set the draft state is not reliable. `--fill` takes the PR title and body from the commits, so it does not prompt.

```bash
gs branch submit --fill --draft      # This branch (gs bs)
gs stack submit --fill --draft       # The whole stack (gs ss)
gs downstack submit --fill --draft   # This branch and the branches below it (gs dss)
gs upstack submit --fill --draft     # This branch and the branches above it (gs uss)
```

- `gs <...> submit --no-publish` pushes the branches but does not create PRs. Without `--no-publish`, a submit creates PRs.
- `--dry-run` shows what would be submitted.
- An existing PR keeps its draft state unless you pass `--draft` or `--no-draft`.

## Sync after a merge

```bash
gs repo sync    # gs rs: pulls the trunk and deletes branches whose PRs merged
gs stack restack
```

## Documentation

`gs <command> --help` describes all flags. The full docs are at https://abhinav.github.io/git-spice/.
