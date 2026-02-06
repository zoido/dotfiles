---
name: release-please
description: Use this skill if you want to release a new version of a project.
---

# Releasing new versions

This skill allows you to release new versions in the git/Github repository, if it uses release-please.

## Steps

- Make sure that that there is a Pull Request with the label `autorelease: pending` in the repository. This means that there is a new version ready to be released.
- If there are multiple Pull Requests with the label `autorelease: pending`, ask user to select the one they want to release. User should be able to select multiple.
- For each selected Pull Request, checkout the branch to the worktree, pull the latest changes and make sure that the branch is up to date with the base branch. If not, ask user if they want to update the branch.
- On each branch:
- activate the PR: `git commit --allow-empty --message "Activate Release PR"`
- push the commit to the remote: `git push`
- mark PR as ready for review: `gh pr ready` (PR can already be ready, but this will make sure that it is)
- approve the PR: `gh pr review --approve`
- merge the PR: `pr merge --auto --squash`
