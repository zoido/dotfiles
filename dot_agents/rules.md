
# Edit Permission (MUST follow)

- Do not create, edit, move, or delete files unless the user explicitly asks you to change them.
- Questions, explanations, investigations, reviews, and requests for a plan or proposal are read-only tasks.
  - Answer or present the plan, then stop and wait.
  - Do not start editing because you think you have enough information.
- Requests that imply a change (for example "fix", "implement", "update", "refactor") count as explicit permission within their scope.
- Permission covers only the scope the user approved. Ask before you change anything outside that scope.
- If you are not sure that the user wants changes, ask first.
- Running read-only commands (for example `rg`, `ls`, `git status`, `git diff`) is always allowed.

# General Approach Guidelines

- Think before acting. Read existing files before writing code. But prefer tools, skill or lsp that can provide the info..
- Be concise in output but thorough in reasoning.
- Prefer editing over rewriting whole files.
- Do not re-read files you have already read unless the file may have changed.
- Test your code before declaring done.
- No sycophantic openers or closing fluff.
- Keep solutions simple and direct.
- User instructions always override this file.
- These rules apply only to shell commands run through the `bash` tool. They do not apply to the built-in `find` and `grep` tools, which already use `fd` and `rg` internally.
  - In shell commands, use `fd` instead of `find` to search for files.
  - In shell commands, use `rg` instead of `grep` to search for patterns in files.
- Prefer the built-in `find` and `grep` tools for single searches. Use `fd` or `rg` in `bash` only when you need flags, pipes, or several searches in one command that the tools do not support.
- Do not use Python for ad-hoc work. Use `jq` for JSON in shell, the `edit` tool for file changes, and `codemode` for data processing or generating files.

# Significant paths

- All code is in the `~/dev`. Direct sub repositories further organize git repositories.
- `~/dev/gh` are random clones of the github repositories.
- `~/dev/zoido` are my personal projects. Dirs matches `zoido/*` Github repos and `github.com/zoido/*` go packages.
- `~/dev/h2o.ai` are my personal projects. Dirs matches `h2oai/*` Github repos and `github.com/h2oai/*` go packages.
- `~dev/*/.worktrees` is where git worktrees are created (managed by worktrunk tool).

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
- When using git worktrees use worktrunk tool via `worktrunk` skill.
- For PR commit and PRs use `pr-guidelines` skill.
- When one feature is split into multiple branches, use the `feature=` prefix.
  - Example: `lp/awesome-feature=refactoring-module`, `lp/awesome-feature=adding-tests`
  - Example: `z/awesome-feature=mixing-stats`, `z/awesome-feature=adding-visualizations`

# Language Specific Guidelines

- When writing or reviewing Go code use `go-code-guidelines` skill.

# Local Classifiers

- When a task applies the same choice, bool, or score question to many items, such as triage, filtering, labeling, or flagging, use the `local-classifiers` skill.
