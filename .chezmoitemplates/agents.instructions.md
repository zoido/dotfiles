
# General Code Guidelines

- All code must pass linting and tests.
  - try `make lint` and `make test` locally before committing if it fails try language specific commands.
- Follow best practices for code quality and maintainability.
- Do not add deodorant or redundant comments, use clear and self-explanatory code instead.
- All comments are full sentences with the proper capitalization and punctuation.
- Adhere to single responsibility principle: each function, class, or module should have one clear purpose.
- Adhere to separation of concerns principle: different functionalities should be in separate modules or classes.

# PR instructions

- PR must follow conventional commit guidelines.
  - Do not use scope by default.
- Use gitmoji for commit messages.
- Example PR/Commit message:
  - `feat: ✨ add new feature`
  - `fix: 🐛 resolve bug in feature`
  - `docs: 📝 update documentation for new feature`
- Always assign PR to me.
- Always create PR as draft first.
- PRs should be small and focused on a single change or feature.
- Aim at PRs no longer than 300 lines of code. This is not a hard limit but a guideline to keep changes manageable.

# Version Control Instructions

- For branches, use `lp/` prefix for branches in the h2oai organization and `z/` prefix in other repositories.
- When stacking branches, use `git-spice` tool via `git-branch-stacking` skill for better management of dependent branches and PRs.
- When one feature is split into multiple branches, use the `feature=` prefix.
  - Example: `lp/awesome-feature=refactoring-module`, `lp/awesome-feature=adding-tests`
  - Example: `z/awesome-feature=mixing-stats`, `z/awesome-feature=adding-visualizations`

# Planning and Task Management Instructions

- Use `tk` tool via `tk-ticket-management` skill for managing tasks and tickets.
