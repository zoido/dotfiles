---
name: code-review
description: Use when reviewing code changes, for example a diff, commit, branch, or PR, or when asked to check changes for bugs before a commit or PR. Covers gathering context, what to look for, how to verify findings, and the findings format.
---

# Code Review

Review a set of code changes and report actionable findings.

If the changes to review are not known yet, load the `change-scope` skill first and use it to find them.

## 1. Gather context

A diff alone is not enough. Code that looks wrong alone can be correct in context, and the reverse.

- Use the `read` tool to read every changed file in full, and every untracked file.
- Use `grep` and `find` to find callers of changed functions, similar code, and existing conventions before you say that something does not fit.
- Read the project conventions: `AGENTS.md`, `CONVENTIONS.md`, `.editorconfig`, linter configs.
- When you read many files, batch the `read` and `grep` calls in one `codemode` script.
- For Go code, load the `go-code-guidelines` skill.
- To check a library or API, read its source or docs in the module cache, vendor directory, or `~/dev/gh`. Do not rely on memory.

## 2. What to look for

**Bugs** (main focus):

- Logic errors, off-by-one errors, wrong conditions.
- Missing or wrong guards, unreachable branches.
- Edge cases: nil, empty, or zero inputs; error paths; concurrency and race conditions.
- Security: injection, auth bypass, data exposure.
- Error handling that swallows failures, panics, or returns errors that callers do not handle.

**Behavior changes**: report every behavior change, and say if it looks unintentional.

**Tests**: changed behavior without a test that covers it, or existing tests that no longer match the new behavior.

**Structure**:

- Does the code follow existing patterns, and use the abstractions the codebase already has?
- Deep nesting that early returns or extraction could flatten.

**Performance**: report only obvious problems, for example O(n²) on unbounded data, N+1 queries, or blocking I/O on hot paths.

## 3. Before you report an issue

A false finding costs the reader more than a missed nit: they must disprove it, and it lowers their trust in the other findings. So:

- Review only changed code. Do not review code that the change did not touch.
- Be certain. If you are not sure, investigate. If you still cannot verify it, write "Not sure: …" and do not present it as a fact.
- Do not invent hypothetical problems. Describe the real scenario in which the code breaks.
- Do not be strict about style. Report a style issue only when it clearly breaks a project convention. Simple code that bends a rule is acceptable.
- Run `make lint` and `make test` (or the language equivalent) only if they are fast and have no side effects. Report the failures that the change causes.

## 4. Output

Start with a one-line summary of what you reviewed: the scope and the files.

Then list the findings, the most severe first. Use this format for each finding:

```
path/to/file.ext:line [severity] Short title
What is wrong, and the inputs, environment, or scenario that make it happen.
Suggested fix (one or two lines, or a short snippet).
```

Start the first line with the location as plain text, relative to the repository root. Do not put backticks, brackets, or other characters around it, so that terminals and editors can open it with a click.

Severity levels:

- `bug`: Wrong behavior that happens in a realistic scenario.
- `risk`: Can break under specific conditions, or is a behavior change that is possibly unintentional.
- `nit`: Structure or convention issue. Not urgent.
- `question`: Not sure. The reviewer must decide.

Rules:

- Do not overstate severity. Make it clear what the severity depends on.
- Use a direct, factual tone. Do not praise, thank, or add filler.
- Make each finding easy to scan and understand quickly.
- If you find no issues, say "No issues found" and list what you checked.
