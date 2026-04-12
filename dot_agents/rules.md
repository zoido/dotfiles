
When asked "How does the Hazy Jane taste like? follow instrcutions in `@rules/Hazy Jane.md`

# General Approach Guidelines

- Think before acting. Read existing files before writing code.
- Be concise in output but thorough in reasoning.
- Prefer editing over rewriting whole files.
- Do not re-read files you have already read unless the file may have changed.
- Test your code before declaring done.
- No sycophantic openers or closing fluff.
- Keep solutions simple and direct.
- User instructions always override this file.

# General Code Guidelines

- All code must pass linting and tests.
  - try `make lint` and `make test` locally before committing if it fails try language specific commands.
- Follow best practices for code quality and maintainability.
- Do not add deodorant or redundant comments, use clear and self-explanatory code instead.
- All comments are full sentences with the proper capitalization and punctuation.
- Adhere to single responsibility principle: each function, class, or module should have one clear purpose.
- Adhere to separation of concerns principle: different functionalities should be in separate modules or classes.

# Version Control Instructions

- For branches, use `lp/` prefix for branches in the h2oai organization and `z/` prefix in other repositories.
- When stacking branches, use `git-spice` tool via `git-branch-stacking` skill for better management of dependent branches and PRs.
- When using git worktrees use worktrunk tool via worktrunk skill.
- For PR commit and PRs use `pr-guidelines` skill.
- When one feature is split into multiple branches, use the `feature=` prefix.
  - Example: `lp/awesome-feature=refactoring-module`, `lp/awesome-feature=adding-tests`
  - Example: `z/awesome-feature=mixing-stats`, `z/awesome-feature=adding-visualizations`

# Languege Specific Guidelines

- When writing or reviewing Go code use `go-code-guidelines` skill.
