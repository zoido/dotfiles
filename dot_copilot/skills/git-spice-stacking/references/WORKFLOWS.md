# Git-Spice Workflow Patterns

Common workflows and patterns for managing stacked branches with git-spice.

## Starting a New Feature Stack

### Basic Feature Stack

Create a series of dependent branches for a large feature:

```bash
# Start from trunk
gs trunk

# Create the foundation branch
gs bc foundation -m "Add base infrastructure"

# Stack the next logical piece
gs bc api-layer -m "Add API endpoints"

# Stack the final piece
gs bc ui-integration -m "Add UI components"

# View the stack
gs ls
```

Result:
```
    ┌── ui-integration ◀
  ┌─┴ api-layer
┌─┴ foundation
main
```

### Feature Stack with Shared Base

When multiple features share a common base:

```bash
gs trunk
gs bc shared-utils -m "Add shared utilities"

# First feature branch
gs bc feature-a -m "Feature A using shared utils"

# Go back to shared base for second feature
gs down
gs bc feature-b -m "Feature B using shared utils"
```

Result:
```
  ┌── feature-b ◀
  ├── feature-a
┌─┴ shared-utils
main
```

---

## Iterating on Feedback

### Amend a Branch Mid-Stack

When you need to fix something in a branch that has branches above it:

```bash
# Current stack:
#     ┌── feature-c ◀
#   ┌─┴ feature-b
# ┌─┴ feature-a
# main

# Navigate to the branch needing changes
gs down 2  # Now on feature-a

# Make your changes
vim src/feature-a.ts

# Amend the commit (auto-restacks upstack)
gs commit amend

# Or if adding new files:
git add src/new-file.ts
gs commit amend
```

### Add a Commit to a Branch Mid-Stack

When a branch needs an additional commit:

```bash
# Navigate to the branch
gs branch checkout feature-a

# Make changes and create new commit
git add .
gs commit create -m "Address review feedback"

# Upstack branches are automatically restacked
```

### Insert a New Branch Into Existing Stack

When you realize you need an intermediate branch:

```bash
# Current: feature-c depends on feature-b depends on feature-a
# Want to insert feature-a-part-2 between feature-a and feature-b

gs branch checkout feature-a
gs bc feature-a-part-2 --insert -m "Additional work for feature A"

# Result:
#       ┌── feature-c
#     ┌─┴ feature-b
#   ┌─┴ feature-a-part-2 ◀
# ┌─┴ feature-a
# main
```

---

## Reorganizing Stacks

### Move a Branch to a Different Base

When a branch should depend on something else:

```bash
# Current:
#   ┌── feature-b
# ┌─┴ feature-a
# main

# Move feature-b to depend directly on main
gs branch checkout feature-b
gs branch onto main

# Result:
# ┌── feature-b ◀
# ├── feature-a
# main
```

### Move Branch and Its Upstack

When a whole subtree needs to move:

```bash
# Current:
#       ┌── feature-c
#     ┌─┴ feature-b
#   ┌─┴ feature-a
# ┌─┴ shared-base
# main

# Move feature-b and feature-c to depend on main directly
gs branch checkout feature-b
gs upstack onto main

# Result:
#     ┌── feature-c
#   ┌─┴ feature-b ◀
#   │ ┌── feature-a
# ┌─┴─┴ shared-base
# main
```

### Reorder Branches

When branches need to be in a different order:

```bash
gs stack edit

# Editor opens with:
# feature-c
# feature-b
# feature-a

# Reorder to:
# feature-c
# feature-a
# feature-b

# Save and close - stack is automatically reordered and restacked
```

---

## Submitting Pull Requests

### Submit Entire Stack at Once

Most efficient way to create all PRs:

```bash
# Preview what will happen
gs stack submit --dry-run

# Submit all branches as PRs
gs stack submit --fill

# Submit as drafts
gs stack submit --fill --draft
```

### Submit Incrementally

When you want to get feedback before submitting everything:

```bash
# Submit just the bottom branch first
gs bottom
gs branch submit --fill

# After approval, submit the next one
gs up
gs branch submit --fill
```

### Update PRs After Changes

After making changes to the stack:

```bash
# Update all PRs in the stack
gs stack submit

# Update only current branch's PR
gs branch submit

# Force push if needed (e.g., after rebase)
gs stack submit --force
```

---

## Handling Merged PRs

### After Bottom PR is Merged

```bash
# Sync with remote - this:
# 1. Pulls latest trunk
# 2. Deletes the merged branch
# 3. Rebases remaining branches onto trunk
gs repo sync

# If conflicts occur during rebase:
# 1. Resolve conflicts
git add <resolved-files>
# 2. Continue
gs rebase continue
```

### After Middle PR is Merged

When a PR in the middle of the stack is merged:

```bash
gs repo sync

# The branch is deleted and upstack branches now stack on its former base
```

---

## Splitting and Combining

### Split a Large Branch

When a branch has too many changes:

```bash
gs branch checkout large-feature

# Interactive split - select which changes go to new branch
gs branch split --at HEAD~3:large-feature-part-1

# Result: large-feature-part-1 is inserted below large-feature
```

### Combine Adjacent Branches

When two branches should be one:

```bash
# Fold current branch into its base
gs branch checkout feature-part-2
gs branch fold

# Commits from feature-part-2 are now in feature-part-1
# feature-part-2 is deleted
```

### Squash Before Submitting

When you want clean single-commit branches:

```bash
gs branch checkout feature-a
gs branch squash -m "Feature A: complete implementation"

gs up
gs branch squash -m "Feature B: complete implementation"
```

---

## Conflict Resolution

### During Restack

```bash
gs stack restack

# If conflict occurs:
# 1. Edit conflicting files
vim src/conflicting-file.ts

# 2. Stage resolved files
git add src/conflicting-file.ts

# 3. Continue restack
gs rebase continue

# Or abort and return to previous state
gs rebase abort
```

### During Sync

```bash
gs repo sync

# If conflict occurs:
# 1. Resolve conflicts
# 2. Stage files
git add .

# 3. Continue
gs rebase continue
```

---

## Branch Cleanup

### Delete Abandoned Branches

```bash
# Delete a single branch
gs branch delete abandoned-feature

# Delete with unmerged changes
gs branch delete abandoned-feature --force

# Delete entire upstack from current branch
gs upstack delete --force

# Delete entire stack
gs stack delete --force
```

### Untrack Without Deleting

When you want to stop managing a branch with git-spice but keep it:

```bash
gs branch untrack feature-x

# The branch still exists, just not tracked by gs
```

---

## Multi-Stack Management

### View All Tracked Branches

```bash
# See all tracked branches, not just current stack
gs log short --all

# With PR status
gs log short --all --cr-status
```

### Switch Between Stacks

```bash
# Interactive branch selection
gs branch checkout

# Or directly
gs branch checkout other-stack-branch
```

---

## Daily Workflow Example

A typical day working with stacked branches:

```bash
# Morning: sync with remote
gs repo sync

# Check current stack status
gs ls --cr-status

# Navigate to branch needing work
gs branch checkout feature-b

# Make changes
vim src/feature.ts
git add src/feature.ts
gs commit amend

# Check the stack looks good
gs ls

# Submit updated PRs
gs stack submit

# Start a new branch for the day's work
gs top
gs bc todays-feature -m "Start new feature"

# End of day: push everything
gs stack submit --fill --draft
```
