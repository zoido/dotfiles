# Git-Spice Command Reference

Complete reference for all git-spice commands relevant to stack management.

## Command Structure

```
gs <category> <command> [args] [flags]
```

Categories: `repo`, `branch`, `stack`, `upstack`, `downstack`, `commit`, `rebase`, `log`, `auth`

Navigation commands (`up`, `down`, `top`, `bottom`, `trunk`) are top-level.

## Navigation Commands

### gs up

Move up one or more branches in the stack.

```bash
gs up [<n>]
gs u [<n>]
```

| Flag | Description |
|------|-------------|
| `-n, --dry-run` | Print target branch without checking out |
| `--detach` | Detach HEAD after checkout |

**Examples:**
```bash
gs up        # Move up one branch
gs up 3      # Move up three branches
gs u -n      # Print what branch would be checked out
```

### gs down

Move down one or more branches in the stack.

```bash
gs down [<n>]
gs d [<n>]
```

| Flag | Description |
|------|-------------|
| `-n, --dry-run` | Print target branch without checking out |
| `--detach` | Detach HEAD after checkout |

**Examples:**
```bash
gs down      # Move down one branch
gs down 2    # Move down two branches
gs d         # Shorthand
```

### gs top

Move to the topmost branch in the current stack.

```bash
gs top
gs U
```

| Flag | Description |
|------|-------------|
| `-n, --dry-run` | Print target branch without checking out |
| `--detach` | Detach HEAD after checkout |

### gs bottom

Move to the bottommost branch in the current stack.

```bash
gs bottom
gs D
```

| Flag | Description |
|------|-------------|
| `-n, --dry-run` | Print target branch without checking out |
| `--detach` | Detach HEAD after checkout |

### gs trunk

Move to the trunk branch.

```bash
gs trunk
```

| Flag | Description |
|------|-------------|
| `-n, --dry-run` | Print target branch without checking out |
| `--detach` | Detach HEAD after checkout |

---

## Repository Commands

### gs repo init

Initialize git-spice in a repository.

```bash
gs repo init
gs r i
```

| Flag | Description |
|------|-------------|
| `--trunk=BRANCH` | Name of the trunk branch |
| `--remote=NAME` | Name of the remote |
| `--reset` | Discard all stored information |

**Examples:**
```bash
gs repo init                          # Interactive setup
gs repo init --trunk main --remote origin  # Non-interactive
gs repo init --reset                  # Reset all git-spice data
```

### gs repo sync

Pull latest changes and clean up merged branches.

```bash
gs repo sync
gs r s
```

| Flag | Description |
|------|-------------|
| `--restack` | Restack current stack after syncing |

### gs repo restack

Restack all tracked branches in the repository.

```bash
gs repo restack
gs r r
```

---

## Log Commands

### gs log short

List branches in a compact format.

```bash
gs log short
gs l s
gs ls
```

| Flag | Description |
|------|-------------|
| `-a, --all` | Show all tracked branches, not just current stack |
| `-S, --cr-status` | Include Change Request (PR) status |
| `--json` | Output as JSON stream |

**Example output:**
```
    ┌── feature-c (#103)
  ┌─┴ feature-b (#102) ◀
┌─┴ feature-a (#101)
main
```

### gs log long

List branches with commit details.

```bash
gs log long
gs l l
gs ll
```

| Flag | Description |
|------|-------------|
| `-a, --all` | Show all tracked branches |
| `-S, --cr-status` | Include PR status |
| `--json` | Output as JSON stream |

---

## Branch Commands

### gs branch create

Create a new branch stacked on current branch.

```bash
gs branch create [<name>]
gs b c [<name>]
gs bc [<name>]
```

| Flag | Description |
|------|-------------|
| `-m, --message=MSG` | Commit message |
| `-a, --all` | Stage all modified/deleted files |
| `--no-commit` | Create branch without committing |
| `--insert` | Move upstack branches onto new branch |
| `--below` | Create below current branch |
| `-t, --target=BRANCH` | Branch to create above/below |
| `--no-verify` | Bypass pre-commit hooks |

**Examples:**
```bash
gs bc feature-x                    # Create with auto-generated name
gs bc feature-x -m "Add feature"   # Create with commit message
gs bc feature-x --insert           # Insert into middle of stack
gs bc feature-x --below            # Create below current
gs bc feature-x --target main      # Create above main
```

### gs branch track

Track an existing branch.

```bash
gs branch track [<branch>]
gs b tr [<branch>]
```

| Flag | Description |
|------|-------------|
| `-b, --base=BRANCH` | Explicit base branch |

### gs branch untrack

Stop tracking a branch (doesn't delete it).

```bash
gs branch untrack [<branch>]
gs b untr [<branch>]
```

### gs branch checkout

Switch to a tracked branch.

```bash
gs branch checkout [<branch>]
gs b co [<branch>]
```

| Flag | Description |
|------|-------------|
| `-n, --dry-run` | Print target without checking out |
| `--detach` | Detach HEAD after checkout |
| `-u, --untracked` | Show untracked branches in prompt |

### gs branch delete

Delete a branch and restack upstack branches.

```bash
gs branch delete [<branches>...]
gs b d [<branches>...]
gs b rm [<branches>...]
```

| Flag | Description |
|------|-------------|
| `--force` | Force deletion even with unmerged changes |

### gs branch fold

Merge current branch commits into its base.

```bash
gs branch fold
gs b fo
```

| Flag | Description |
|------|-------------|
| `--branch=NAME` | Branch to fold |

### gs branch split

Split a branch at specific commits.

```bash
gs branch split
gs b sp
```

| Flag | Description |
|------|-------------|
| `--at=COMMIT:NAME` | Commit and new branch name |
| `--branch=NAME` | Branch to split |

**Example:**
```bash
gs branch split --at HEAD^:feature-part-1
```

### gs branch squash

Squash all commits in branch into one.

```bash
gs branch squash
gs b sq
```

| Flag | Description |
|------|-------------|
| `-m, --message=MSG` | Commit message |
| `--no-edit` | Don't open editor |
| `--branch=NAME` | Branch to squash |

### gs branch restack

Rebase current branch onto its base.

```bash
gs branch restack
gs b r
```

| Flag | Description |
|------|-------------|
| `--branch=NAME` | Branch to restack |

### gs branch onto

Move branch to a different base (upstack stays in place).

```bash
gs branch onto [<onto>]
gs b on [<onto>]
```

| Flag | Description |
|------|-------------|
| `--branch=NAME` | Branch to move |

### gs branch rename

Rename a branch.

```bash
gs branch rename [<old-name> [<new-name>]]
gs b rn [<old-name> [<new-name>]]
gs b mv [<old-name> [<new-name>]]
```

### gs branch edit

Interactive rebase of commits in current branch.

```bash
gs branch edit
gs b e
```

### gs branch submit

Submit current branch as a PR.

```bash
gs branch submit
gs b s
gs bs
```

| Flag | Description |
|------|-------------|
| `-n, --dry-run` | Don't actually submit |
| `-c, --fill` | Fill title/body from commits |
| `--draft / --no-draft` | Mark as draft |
| `--title=TITLE` | PR title |
| `--body=BODY` | PR body |
| `--force` | Force push |
| `-w, --web` | Open in browser |
| `-l, --label=LABEL` | Add labels (repeatable) |
| `-r, --reviewer=USER` | Add reviewers (repeatable) |
| `-a, --assign=USER` | Add assignees (repeatable) |

---

## Stack Commands

### gs stack submit

Submit entire stack as PRs.

```bash
gs stack submit
gs s s
gs ss
```

Flags are the same as `gs branch submit`.

### gs stack restack

Restack all branches in current stack.

```bash
gs stack restack
gs s r
gs sr
```

| Flag | Description |
|------|-------------|
| `--branch=NAME` | Branch whose stack to restack |

### gs stack edit

Edit branch order in the stack interactively.

```bash
gs stack edit
gs s e
```

| Flag | Description |
|------|-------------|
| `--editor=STRING` | Editor to use |
| `--branch=NAME` | Branch whose stack to edit |

### gs stack delete

Delete all branches in a stack.

```bash
gs stack delete
gs s d
```

| Flag | Description |
|------|-------------|
| `--force` | Required to confirm deletion |

---

## Upstack Commands

### gs upstack submit

Submit current branch and all branches above it.

```bash
gs upstack submit
gs us s
```

Flags are the same as `gs branch submit`, plus:

| Flag | Description |
|------|-------------|
| `--branch=NAME` | Branch to start from |

### gs upstack restack

Restack current branch and all above.

```bash
gs upstack restack
gs us r
```

| Flag | Description |
|------|-------------|
| `--skip-start` | Don't restack starting branch |
| `--branch=NAME` | Branch to start from |

### gs upstack onto

Move current branch and upstack onto a new base.

```bash
gs upstack onto [<onto>]
gs us o [<onto>]
```

| Flag | Description |
|------|-------------|
| `--branch=NAME` | Branch to start from |

### gs upstack delete

Delete all branches above current branch.

```bash
gs upstack delete
gs us d
```

| Flag | Description |
|------|-------------|
| `--force` | Required to confirm deletion |

---

## Downstack Commands

### gs downstack submit

Submit current branch and all branches below it.

```bash
gs downstack submit
gs ds s
```

Flags are the same as `gs branch submit`, plus:

| Flag | Description |
|------|-------------|
| `--branch=NAME` | Branch to start from |

### gs downstack track

Track all untracked branches below current branch.

```bash
gs downstack track [<branch>]
gs ds tr [<branch>]
```

### gs downstack edit

Edit branch order below current branch.

```bash
gs downstack edit
gs ds e
```

| Flag | Description |
|------|-------------|
| `--editor=STRING` | Editor to use |
| `--branch=NAME` | Branch to start from |

---

## Commit Commands

### gs commit create

Create a commit and restack upstack.

```bash
gs commit create
gs c c
gs cc
```

| Flag | Description |
|------|-------------|
| `-m, --message=MSG` | Commit message |
| `-a, --all` | Stage all changes |
| `--allow-empty` | Allow empty commit |
| `--no-verify` | Bypass hooks |

### gs commit amend

Amend current commit and restack upstack.

```bash
gs commit amend
gs c a
gs ca
```

| Flag | Description |
|------|-------------|
| `-m, --message=MSG` | New commit message |
| `-a, --all` | Stage all changes |
| `--no-edit` | Keep existing message |
| `--no-verify` | Bypass hooks |

### gs commit split

Split current commit interactively.

```bash
gs commit split
gs c sp
```

### gs commit fixup

Apply staged changes to an older commit.

```bash
gs commit fixup [<commit>]
gs c f [<commit>]
```

---

## Rebase Commands

### gs rebase continue

Continue an interrupted rebase operation.

```bash
gs rebase continue
gs rb c
gs rbc
```

| Flag | Description |
|------|-------------|
| `--no-edit` | Don't open editor |

### gs rebase abort

Abort an interrupted rebase operation.

```bash
gs rebase abort
gs rb a
gs rba
```

---

## Authentication Commands

### gs auth login

Authenticate with GitHub.

```bash
gs auth login
```

| Flag | Description |
|------|-------------|
| `--refresh` | Force re-authentication |

### gs auth status

Check authentication status.

```bash
gs auth status
```

### gs auth logout

Remove stored authentication.

```bash
gs auth logout
```

---

## Global Flags

These flags work with any command:

| Flag | Description |
|------|-------------|
| `-h, --help` | Show help |
| `--version` | Print version |
| `-v, --verbose` | Enable verbose output |
| `-C, --dir=DIR` | Run in different directory |
| `--no-prompt` | Disable interactive prompts |
