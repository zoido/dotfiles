---
description: Review changes for bugs, security, maintainability, and style
note: Based on the Claude Code Code Review Code Command
---

## Instructions

Please perform a comprehensive code review of the current changes with the mindset of a seasoned senior engineer on the current changes:


## Identification of Changes

- If there are staged changes, review only those.
   ```sh
   git diff --cached
   ```
- If there are no staged changes but uncommitted changes, review those.
   ```sh
   git diff
   ```
- If there are no uncommitted changes review diff between current branch and closest immediate ancestor branch.
   - you can find the closest ancestor branch with the following script:
      ```sh
      current=$(git rev-parse --abbrev-ref HEAD)
      git for-each-ref --format='%(refname:short)' refs/heads/ | while read -r candidate; do
         [ "$candidate" = "$current" ] && continue

         if git merge-base --is-ancestor "$candidate" HEAD 2>/dev/null; then
            distance=$(git rev-list --count "${candidate}..HEAD")
            printf "%s %s\n" "$distance" "$candidate"
         fi
      done | sort -n | head -n 1 | awk '{print $2}'
      ```
- If nothing from the above yields changes, ask for new changes to review.

## Review Focus Areas

1. **Code Quality**
   - Clean code principles
   - Readability and maintainability
   - Code organization and structure
   - Function/method length and complexity
   - Variable/function naming conventions
   - Comments and documentation
   - Use of idioms and best practices

2. **Bugs & Issues**
   - Logic errors
   - Edge cases not handled
   - Potential null/undefined references
   - Off-by-one errors
   - Race conditions (for concurrent code)
   - Memory leaks

3. **Performance Considerations**
   - Time complexity analysis
   - Space complexity analysis
   - Efficient algorithm choices
   - Potential bottlenecks
   - Resource usage

4. **Security**
   - Input validation
   - Authorization checks
   - SQL/NoSQL injection risks
   - XSS vulnerabilities
   - Data exposure risks
   - Secure credential handling

5. **Testing**
   - Test coverage assessment
   - Missing test cases
   - Testability issues

## Review Format

- Provide a clear verdict:
   - **READY FOR REVIEW**: Changes are solid, ship it!
   - **NEEDS CHANGES**: List the must-fix issues before committing
   - **NEEDS REVIEW**: Suggest getting human review for complex changes


For each issue identified:
  1. Provide the specific line number and/or code snippet
  2. Explain the issue clearly
  3. Rate the severity (Critical, High, Medium, Low)
  4. Provide a specific recommendation for improvement
  5. Include sample code when appropriate


### Output format

Structure your review as:

```
## Changes Review

[What kind of changes were identified, staged, uncommitted, or branch diff ]

**Files Changed:** [count] files with [+X / -Y lines]
[list of changed files]


### Code Quality
[findings or "Looks good"]

### Bugs & Issues
[findings or "None found"]

### Performance Considerations
[findings or "No performance issues detected"]

### Security
[findings or "No security issues detected"]

### Testing
[findings or "Testing coverage looks adequate"]

### Result
[READY FOR REVIEW | NEEDS CHANGES | NEEDS REVIEW]

[explanation and any actionable items]
```

---

Be thorough but pragmatic. Focus on real issues, not nitpicks. If changes are good, say so!
Do not bother with positive feedback, only point out issues or confirm readiness.
