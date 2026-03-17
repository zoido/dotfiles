---
name: git-branch-stacking
description: Manage and navigate stacked Git branches using git-spice (gs). Use when working with branch stacks, creating dependent branches, submitting stacked PRs to GitHub, or reorganizing branch dependencies. Enables efficient stacked diff workflows.
---

# Git Branch Stacking with git-spice

Use git-spice (`gs`) to manage stacked branches - a workflow where branches build on top of each other, enabling small, focused PRs that are easier to review.

## When to Use This Skill

- Splitting large changes into multiple reviewable PRs
- Creating dependent/stacked branches
- Submitting multiple related PRs to GitHub
- Reorganizing or reordering branch dependencies
- Navigating between branches in a stack

## Setup

Initialize git-spice in a repository if not already initialized (check for `.git/spice` directory):

```bash
# Only if .git/spice does not exist
gs repo init
```

## Creating a Stack

Create branches that stack on each other. Use `z/` prefix for branches, and `feature=` prefix when splitting a feature:

```bash
# Start from trunk (main/master)
git checkout main

# Create first branch in the stack
# Stage your changes first, then:
gs branch create z/feature=part1

# Continue working, stage more changes
gs branch create z/feature=part2  # Stacks on z/feature=part1

# Each new branch stacks on the current one
gs branch create z/feature=part3  # Stacks on z/feature=part2
```

Track an existing branch with git-spice:

```bash
gs branch track z/existing-branch
```

## Navigating the Stack

Move between branches in a stack:

```bash
gs up       # Move to branch above (child)
gs down     # Move to branch below (parent)
gs top      # Jump to topmost branch
gs bottom   # Jump to bottommost branch

# Interactive branch selection
gs branch checkout  # or: gs bco
```

## Committing Changes

Use git-spice commit commands to automatically restack dependent branches:

```bash
# Create a new commit (auto-restacks upstack branches)
gs commit create    # or: gs cc

# Amend the current commit (auto-restacks upstack branches)
gs commit amend     # or: gs ca
```

## Restacking Branches

After rebasing or making changes to a base branch, restack dependent branches:

```bash
# Restack current branch onto its base
gs branch restack   # or: gs br

# Restack all branches in the stack
gs stack restack    # or: gs sr
```

## Submitting PRs

Submit branches as GitHub Pull Requests. Use `--publish --fill` to create PRs non-interactively.

Submit a single branch:

```bash
gs branch submit --publish --fill    # or: gs bs --publish --fill
```

Submit the entire stack:

```bash
gs stack submit --publish --fill     # or: gs ss --publish --fill
```

Submit partial stacks:

```bash
# Current branch and all branches below it
gs downstack submit --publish --fill  # or: gs dss --publish --fill

# Current branch and all branches above it
gs upstack submit --publish --fill    # or: gs uss --publish --fill
```

Push branches without creating PRs:

```bash
gs stack submit    # Only pushes, no PR creation (default config)
```

Flags:
- `--publish`: Create/update PR on GitHub (required to submit PRs)
- `--fill`: Non-interactive mode, auto-fill PR title/body from commits
- `--no-draft`: Create as ready for review instead of draft

## Syncing with Upstream

After PRs are merged, sync the repository:

```bash
gs repo sync    # or: gs rs
```

This will:
- Pull latest trunk (main/master)
- Delete branches whose PRs were merged
- Restack remaining branches

## Reorganizing Stacks

Move a branch (and its upstack) to a different base:

```bash
# Move current branch to stack on top of z/other-branch
gs upstack onto z/other-branch    # or: gs uso z/other-branch
```

Delete a branch from the stack:

```bash
gs branch delete z/branch-name    # or: gs bd z/branch-name
```

## Command Reference

| Command | Shorthand | Purpose |
|---------|-----------|---------|
| `gs repo init` | `gs ri` | Initialize git-spice |
| `gs repo sync` | `gs rs` | Sync with upstream |
| `gs branch create` | `gs bc` | Create stacked branch |
| `gs branch track` | `gs btr` | Track existing branch |
| `gs branch checkout` | `gs bco` | Checkout branch (interactive) |
| `gs branch restack` | `gs br` | Restack current branch |
| `gs branch submit` | `gs bs` | Submit branch as PR |
| `gs branch delete` | `gs bd` | Delete branch |
| `gs stack restack` | `gs sr` | Restack entire stack |
| `gs stack submit` | `gs ss` | Submit entire stack |
| `gs downstack submit` | `gs dss` | Submit downstack |
| `gs upstack submit` | `gs uss` | Submit upstack |
| `gs upstack onto` | `gs uso` | Move branch to new base |
| `gs commit create` | `gs cc` | Commit with auto-restack |
| `gs commit amend` | `gs ca` | Amend with auto-restack |
| `gs up` | - | Move up in stack |
| `gs down` | - | Move down in stack |
| `gs top` | - | Jump to top of stack |
| `gs bottom` | - | Jump to bottom of stack |

## Integration Notes

- Follow conventional commit guidelines with gitmoji for commit messages
- Keep each branch small and focused on a single change
- Use PR navigation comments added by git-spice to help reviewers understand stack order

## Documentation

Full documentation: https://abhinav.github.io/git-spice/
