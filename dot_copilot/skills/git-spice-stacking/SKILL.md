---
name: git-spice-stacking
description: Manage and navigate stacked Git branches using git-spice (gs). Use when working with branch stacks, creating dependent branches, submitting stacked PRs to GitHub, or reorganizing branch dependencies. Enables efficient stacked diff workflows.
compatibility: Requires git-spice (gs) CLI tool installed and available in PATH.
---

# Git-Spice Stacked Branches Skill

This skill enables navigation and management of stacked Git branches using the `gs` (git-spice) command-line tool.

## Quick Reference

| Action | Command | Shorthand |
|--------|---------|-----------|
| Move up one branch | `gs up` | `gs u` |
| Move down one branch | `gs down` | `gs d` |
| Move to top of stack | `gs top` | `gs U` |
| Move to bottom of stack | `gs bottom` | `gs D` |
| Move to trunk | `gs trunk` | - |
| Show stack (short) | `gs log short` | `gs ls` |
| Show stack (detailed) | `gs log long` | `gs ll` |
| Create branch | `gs branch create <name>` | `gs bc <name>` |
| Submit current branch PR | `gs branch submit` | `gs bs` |
| Submit entire stack | `gs stack submit` | `gs ss` |
| Restack current branch | `gs branch restack` | `gs br` |
| Restack entire stack | `gs stack restack` | `gs sr` |
| Sync with remote | `gs repo sync` | `gs rs` |

## Prerequisites

Before using git-spice commands, ensure:
1. The repository has been initialized with `gs repo init`
2. You are in a git repository with a configured remote

To check if initialized, run `gs log short`. If it fails, initialize first.

## Core Workflows

### Initialize a Repository

```bash
# Initialize with prompts for trunk branch and remote
gs repo init

# Or specify directly
gs repo init --trunk main --remote origin
```

### Navigate the Stack

```bash
# Move up to the branch above current
gs up
# Move up multiple branches
gs up 2

# Move down to the branch below current
gs down
# Move down multiple branches
gs down 2

# Jump to top of current stack
gs top

# Jump to bottom of current stack
gs bottom

# Return to trunk branch
gs trunk

# Checkout a specific branch (with interactive selection)
gs branch checkout
# Or directly
gs branch checkout feature-x
```

### Visualize the Stack

```bash
# Short view - branch names only
gs log short
# With PR status from GitHub
gs log short --cr-status

# Long view - includes commits
gs log long

# Show all tracked branches (not just current stack)
gs log short --all
```

Example output:
```
    ┌── feature-c
  ┌─┴ feature-b ◀ (current)
┌─┴ feature-a
main
```

### Create Branches

```bash
# Create and commit staged changes to new branch
gs branch create feature-x

# Create with commit message
gs branch create feature-x -m "Add feature X"

# Create without committing (just create branch)
gs branch create feature-x --no-commit

# Create and insert into stack (upstack branches move onto new branch)
gs branch create feature-x --insert

# Create below current branch
gs branch create feature-x --below

# Create above a specific branch
gs branch create feature-x --target feature-a
```

### Track Existing Branches

```bash
# Track current branch
gs branch track

# Track with explicit base
gs branch track --base main

# Track a specific branch
gs branch track feature-x

# Track entire downstack at once
gs downstack track
```

### Manage Branches

```bash
# Delete a branch (rebases upstack onto next downstack branch)
gs branch delete feature-x

# Force delete (even with unmerged changes)
gs branch delete feature-x --force

# Fold branch into its base (merge commits down)
gs branch fold

# Split branch at specific commits
gs branch split --at HEAD^:new-branch-name

# Squash all commits in branch into one
gs branch squash
gs branch squash -m "Combined commit message"

# Rename branch
gs branch rename old-name new-name
```

### Reorganize the Stack

```bash
# Restack current branch onto its base
gs branch restack

# Restack entire stack
gs stack restack

# Restack all tracked branches in repo
gs repo restack

# Move current branch onto a different base
gs branch onto main
gs branch onto feature-a

# Move branch and all upstack branches onto new base
gs upstack onto main

# Edit branch order interactively
gs stack edit
gs downstack edit
```

### Submit Pull Requests

```bash
# Submit current branch as PR
gs branch submit

# Submit as draft
gs branch submit --draft

# Submit with metadata
gs branch submit --title "Add feature" --body "Description"

# Fill title/body from commit messages
gs branch submit --fill

# Submit entire stack
gs stack submit

# Submit only branches below current
gs downstack submit

# Submit current and all above
gs upstack submit

# Dry run (see what would happen)
gs stack submit --dry-run
```

### Sync with Remote

```bash
# Pull latest and clean up merged branches
gs repo sync

# Sync and restack current stack
gs repo sync --restack
```

### Handle Conflicts

When a rebase conflict occurs during restack:

```bash
# 1. Resolve conflicts in files
# 2. Stage resolved files
git add <resolved-files>

# 3. Continue the operation
gs rebase continue

# Or abort and return to previous state
gs rebase abort
```

## Common Patterns

### Start a New Feature Stack

```bash
gs trunk                           # Start from trunk
gs branch create feature-base      # Create base feature branch
# ... make changes, commit ...
gs branch create feature-part-2    # Stack next part on top
# ... make changes, commit ...
gs branch create feature-part-3    # Continue stacking
```

### Update Stack After Review Feedback

```bash
gs down 2                          # Go to branch needing changes
# ... make changes ...
gs commit amend                    # Amend the commit
gs upstack restack                 # Rebase all branches above
```

### Reorder Branches in Stack

```bash
gs stack edit                      # Opens editor with branch list
# Reorder lines in editor, save and close
# Stack is automatically restacked
```

### After PR is Merged

```bash
gs repo sync                       # Pulls latest, deletes merged branches
                                   # Upstack branches are rebased onto trunk
```

## Tips

1. **Always restack after amending**: Use `gs commit amend` instead of `git commit --amend` to auto-restack.

2. **Use dry-run for submit**: `gs stack submit --dry-run` shows what PRs will be created/updated.

3. **Check PR status**: `gs log short --cr-status` shows PR state (draft, approved, merged).

4. **Batch operations**: Prefer `gs stack submit` over individual `gs branch submit` for efficiency.

5. **Navigation shortcuts**: `gs u`, `gs d`, `gs U`, `gs D` are faster than full commands.

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "branch not tracked" | Run `gs branch track` on the branch |
| "no trunk configured" | Run `gs repo init --trunk main` |
| Rebase conflicts | Resolve conflicts, `git add`, then `gs rebase continue` |
| Branch renamed outside gs | `gs branch untrack old-name` then `gs branch track new-name` |
| Need to see all branches | `gs log short --all` shows all tracked branches |

## Reference Documentation

For complete command details, see:
- [Command Reference](references/COMMANDS.md) - Full command documentation
- [Workflow Patterns](references/WORKFLOWS.md) - Detailed workflow examples
