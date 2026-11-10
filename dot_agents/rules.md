
# Edit Permission (MUST follow)

- Do not create, edit, move, or delete files unless the user explicitly asks you to change them.
- Questions, explanations, investigations, reviews, and requests for a plan or proposal are read-only tasks.
  - Answer or present the plan, then stop and wait.
  - Do not start editing because you think you have enough information.
- Requests that imply a change (for example "fix", "implement", "update", "refactor") count as
  explicit permission within their scope, unless the user asks for a plan first. Then the
  "Plan approval" rules apply.
- Permission covers only the scope the user approved. Ask before you change anything outside that scope.
- If you are not sure that the user wants changes, ask first.
- Running read-only commands (for example `rg`, `ls`, `git status`, `git diff`) is always allowed.

## Plan approval

- When the user asks for a plan first, the plan must be approved before any edit.
- Approval is an explicit go-ahead with no new requirements, for example "go", "implement it",
  or "looks good, do it".
- If the reply adds, removes, or changes any requirement, it is not approval, even if it starts
  with "ok", "alright", or "yes". Update the plan, show what changed, and stop.
- If the reply both approves and asks for a change, treat it as a change request. Revise the
  plan and wait.
- All open questions in the plan must be answered before editing. A reply that answers only
  some of them is not approval.
- If you are not sure whether a reply is approval, treat it as a change request. Revise the
  plan and wait.

# General Approach Guidelines

- Think before acting. Read existing files before writing code. But prefer tools, skill or lsp that can provide the info.
- Be concise in output but thorough in reasoning.
- Prefer editing over rewriting whole files.
- Do not re-read files you have already read unless the file may have changed.
- Test your code before declaring done.
- No sycophantic openers or closing fluff.
- Keep solutions simple and direct.
- User instructions always override this file.
- If you have dedicated tools to search files and file contents (for example the `find` and `grep` tools in pi), use them for single searches. Use shell commands only when you need flags, pipes, or several searches in one command that the tools do not support.
- In shell commands, use `fd` instead of `find` and `rg` instead of `grep`. This rule does not apply to dedicated search tools with the same names.
- My primary shell is fish. My custom functions (for example `git_parent_branch`) exist only in fish. Call them with `fish -c '...'`. Fish abbreviations do not expand in `fish -c`, so use the full command. Commands that I should run myself must use fish syntax.
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

# Classifiers

- When a task applies the same choice, bool, or score question to many items, such as triage, filtering, labeling, or flagging, use the `classifiers` skill.
