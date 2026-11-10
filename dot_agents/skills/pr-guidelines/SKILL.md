---
name: pr-guidelines
description: Use whenever you run `git commit` or `gs commit`, including creating commits, splitting changes into several commits, amending or rewording commits, writing commit messages, opening PRs, or writing or reviewing PR titles and descriptions, including a plain "commit this" or "open a PR" request. Covers conventional commits with gitmoji, commit bodies, PR descriptions, drafts, and PR size.
---

# Commit and PR Guidelines

## Commit message and PR title

Use the same format for commit subjects and PR titles: a conventional commit with a gitmoji after the type.

```
<type>: <gitmoji> <subject>
```

Examples, with `<gitmoji>` standing for the emoji:

- `feat: <gitmoji> add retry to the upload client`
- `fix: <gitmoji> handle empty config files`
- `docs: <gitmoji> describe the release process`

Parts of the message:

- **Type**: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, or `revert`.
- **Gitmoji**: load the `gitmoji` skill to pick it. It lists the default for each type and the more specific ones.
- **Scope**: do not add one by default. Add it only when the repository already uses scopes, for example `feat(api): …`.
- **Subject**: imperative mood ("add", not "added" or "adds"), lowercase start, no period at the end, about 50 characters and at most 72. It says what the change does, so the history reads as a list of actions.
- **Breaking change**: add `!` after the type (`feat!: …`), use the breaking-change gitmoji, and explain the break in the body.

## Commit body

Add a body when the subject cannot explain the change alone. Leave one blank line after the subject and wrap at 72 characters.

- Explain why the change is needed and what it changes in behavior. The diff already shows how.
- Write `BREAKING CHANGE: <what breaks and how to migrate>` as the last paragraph of a breaking change.
- Skip the body for small, obvious changes.

## PR description

The PR title follows the commit format above. For a single-commit PR, use the commit subject.

Use this structure for the body. Leave out sections that would be empty:

```markdown
## Why

<The problem or the goal, in one to three sentences.>

## What

- <Main change.>
- <Other notable change.>

## Testing

<How you checked the change: tests added, commands run, manual steps.>
```

- Write for a reviewer who has not seen the work. Link the issue if there is one.
- Mention anything the reviewer must look at closely, for example a behavior change or a migration.
- Keep it short and factual. Load the `simple-english` skill and then the `humanizer` skill, and apply both to the description.

## Drafts

Create every PR as a draft unless the user asks otherwise. A draft lets the user check it before reviewers are notified.

- `gh pr create --draft --title "<title>" --body-file <file>`
- For stacked branches, use the `git-branch-stacking` skill. Its submit commands pass `--draft`.

## Size

- Keep each PR small and focused on one change or feature.
- Aim for at most 300 changed lines. This is a guideline, not a hard limit. Small PRs get faster and better reviews.
- If a change is much bigger, propose splitting it into stacked PRs with the `git-branch-stacking` skill.
