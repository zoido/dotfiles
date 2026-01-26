---
description: Review changes for bugs, security, maintainability, and style
note: Based on the Claude Code Code Review Code Command
---

## Instructions

Please perform a comprehensive code review of the current changes with the mindset of a seasoned senior engineer on the current changes:


## Identification of Changes.

- If there are staged changes, review only those those.
- If there are no staged changes, review the entire uncommitted diff.
- If there are no uncommitted changes, review the diff between the current branch and last forking point.

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

For each issue identified:
1. Provide the specific line number or code snippet
2. Explain the issue clearly
3. Rate the severity (Critical, High, Medium, Low)
4. Provide a specific recommendation for improvement
5. Include sample code when appropriate

## Summary

Conclude with:
1. Overall assessment (3-5 bullet points)
2. Key strengths of the code
3. Priority improvements (top 3)
4. Any architectural considerations

---

Be thorough but pragmatic. Focus on real issues, not nitpicks. If changes are good, say so!
