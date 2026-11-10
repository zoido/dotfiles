---
name: code-review
description: Use when reviewing code changes, for example a diff, commit, branch, or PR, or when asked to check changes for bugs before a commit or PR. Covers gathering context, what to look for, how to verify findings, the comment types (qq, optional, nit, issue, fyi, nice), and how to word review comments so that they read like a mild, human reviewer.
---

# Code Review

Review a set of code changes and write review comments the way the user writes them: short, mild, and about the code.

If the changes to review are not known yet, load the `change-scope` skill first and use it to find them.

The checklist follows Google's [What to look for in a code review](https://google.github.io/eng-practices/review/reviewer/looking-for.html). The comment style follows Google's [How to write code review comments](https://google.github.io/eng-practices/review/reviewer/comments.html).

## 1. Gather context

A diff alone is not enough. Code that looks wrong alone can be correct in context, and the reverse.

- Use the `read` tool to read every changed file in full, and every untracked file. Four new lines can sit in a 50-line function that now needs to be split.
- Use `grep` and `find` to find callers of changed functions, similar code, and existing conventions before you say that something does not fit.
- Read the project conventions: `AGENTS.md`, `CONVENTIONS.md`, `.editorconfig`, linter configs.
- When you read many files, batch the `read` and `grep` calls in one `codemode` script.
- For Go code, load the `go-code-guidelines` skill.
- To check a library or API, read its source or docs in the module cache, vendor directory, or `~/dev/gh`. Do not rely on memory.

## 2. What to look for

Look at every human-written line. You can skim generated code and data files. If you cannot understand a part of the code, say so in a `qq` comment. Other readers will probably have the same problem.

Go through these areas, the most important first:

- Design: Do the parts of the change work well together? Does the code belong here, or in a library or another package? Does it fit the rest of the system?
- Functionality: Does the code do what the author intended, and is that good for its users and for future developers? Look for logic errors, off-by-one errors, wrong conditions, missing guards, and edge cases (nil, empty, or zero input, error paths). Look for errors that are swallowed or not handled. For concurrent code, think through deadlocks and race conditions. Look for security problems: injection, auth bypass, data exposure.
- Behavior changes: Report every behavior change. Say if it looks unintentional.
- Complexity: Can a reader understand each line, function, and type quickly? Will the next developer introduce bugs when they change it? Watch for over-engineering: code that is more generic than the problem needs, or features that nobody needs yet.
- Tests: Is changed behavior covered? Will the tests fail when the code breaks? Are the assertions simple and useful? Tests are code too, so complexity in tests counts.
- Naming: Does each name say what the thing is or does, without being too long?
- Comments: Do code comments explain why, not what? If a comment explains what confusing code does, the code itself should be simpler. Look for TODOs that the change makes obsolete.
- Style and consistency: Follow the project conventions and the language style guide. If no rule applies, follow the surrounding code. A personal preference is a `nit` at most. Large reformatting mixed with real changes makes the change hard to review. Say so.
- Documentation: If the change affects how people build, test, use, or release the code, are the README and docs updated? Is the documentation of deleted code removed too?
- Performance: Report only clear problems, for example O(n²) on unbounded data, N+1 queries, or blocking I/O on hot paths.
- Code health: Does the change leave the codebase better or worse? Small additions of complexity add up.
- Good things: Note what the author did well, for example a cleaned-up algorithm or good tests. See `nice` below.

## 3. Before you write a comment

A false finding costs the author more than a missed nit. They must disprove it, and it lowers their trust in the other comments.

- Review only the changed code. Do not review code that the change did not touch.
- Be sure. If you are not sure, investigate. If you still cannot verify it, write it as a `qq` and ask. Do not present a guess as a fact.
- Do not invent problems. Describe the real scenario in which the code breaks.
- Do not repeat the linter. Do not be strict about style. Simple code that bends a rule is acceptable.
- Run `make lint` and `make test` (or the language equivalent) only if they are fast and have no side effects. Report the failures that the change causes.
- Do not comment on the same problem in many places. Write one comment and add "here and elsewhere", or list the other lines in it.

## 4. Comment types

Give each comment one type. Use only these ids. The tuicr configuration in `~/.config/tuicr/config.toml` uses the same ids and definitions.

| id | Meaning | What the author does |
|---|---|---|
| `qq` | A question. I do not understand something, or I am not sure if it is a problem. | Answers. Often the best answer is clearer code or a code comment. |
| `optional` | A possible improvement. Not required. | Decides. Applies it or ignores it. |
| `nit` | A small polish item, for example naming, wording, or a style preference. | Usually applies it. Can skip it. |
| `issue` | A problem that must be fixed before merge, for example a bug or a broken contract. | Fixes it, or explains why it is not a problem. |
| `fyi` | Information for later. No change expected in this change. | Reads it. |
| `nice` | Something done well, and why it is good. | Nothing. |

How to pick the type:

- Use `issue` only when you can name the scenario that breaks. Possible breakage that you cannot confirm is a `qq`.
- Prefer the milder type when two fit. Most comments are `qq`, `optional`, or `nit`.
- Use `nice` rarely: one or two per review at most, for something specific and worth repeating. Do not write generic praise. Do not write `nice` about code that another comment questions.
- Use `fyi` for follow-ups that are outside the scope of this change.

## 5. How to write a comment

Write like a colleague who leaves a quick comment in the review tool, not like an auditor writing a report.

- Comment on the code, never on the author. Write "this drops the error", not "you forgot the error".
- Be mild. Suggest and ask. Do not order. Use phrases such as "maybe", "I think", "could we…?", "what about…?", "wdyt?". Leave the decision to the author, unless the comment is an `issue`. One hedge per comment is enough. Do not stack "I think", "maybe", and "as far as I know" in one comment.
- Be short. One to three sentences is normal. Start with the point. Give the scenario that breaks, but leave out evidence that the author can see in the diff.
- Explain why when the reason is not obvious, for example the input that breaks it or the convention it bends.
- Point out the problem and let the author choose the fix. Add a fix or a small snippet only when it is shorter than the explanation, or when the fix is not obvious.
- If the code needs an explanation, ask for clearer code or a code comment. An answer in the review tool does not help the next reader.
- Do not praise, thank, or apologize as filler. Use a `nice` comment when you mean it.
- Do not use headings, bold text, or a fixed "Problem / Fix" template inside a comment.
- Do not write the type into the text, for example "Nit:". The type carries it.

Examples:

| Type | Too authoritative | Better |
|---|---|---|
| `issue` | Missing nil check. This will panic. Add a guard. | `cfg` is nil when the file is missing (line 40), so this panics on a fresh install. Maybe return early there? |
| `qq` | Why did you use a goroutine here? It adds no benefit. | Does this need to be a goroutine? I don't see the caller doing anything else while it waits. |
| `optional` | Extract this into a helper. | Could this be a small helper? The same three lines are in `Load` too. |
| `nit` | Rename `d` to `delay`. | `delay` reads a bit better than `d` here. |
| `fyi` | This should use the new client. | The new `authz.Client` has a retry option built in. Not for this change, but it could replace this loop later. |
| `nice` | Great job! | Nice, table tests make the edge cases much easier to see. |

## 6. Output

Start with a one-line summary of what you reviewed: the scope and the files.

Then list the comments. Put `issue` first, then `qq`, `optional`, `nit`, `fyi`, and `nice`. Use this format for each comment:

```
path/to/file.ext:line [type]
Comment text, written as you would post it in the review tool.
```

Start the first line with the location as plain text, relative to the repository root. Do not put backticks, brackets, or other characters around the location, so that terminals and editors can open it with a click. For a comment that is not about one line, use `path/to/file.ext` or `(general)`.

If you have no comments other than `nice` or `fyi`, write "LGTM" and list what you checked.
