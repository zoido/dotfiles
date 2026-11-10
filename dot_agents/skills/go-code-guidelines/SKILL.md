---
name: go-code-guidelines
description: Use when writing, reviewing, refactoring, or testing Go code, including `_test.go` files, table-driven tests, benchmarks, raising the `go` version in `go.mod`, or "modernize this Go code". Covers idiomatic style, Go features newer than the model's knowledge, error handling, and testing patterns with testify.
---

# Go Code Style and Testing Guidelines

## Style

- Write idiomatic Go. Follow "Effective Go" and "Go Code Review Comments".
- Use the newest language and library features that the `go` directive in `go.mod` allows. Old idioms make code longer and hide intent.
  - Read [recent-go-changes.md](recent-go-changes.md) for the changes in Go 1.25 – 1.27. They came after your knowledge cutoff, so you do not know them otherwise.
  - Check the version that added a symbol with `go doc <pkg>.<Symbol>` or in `$(go env GOROOT)/api/go1.*.txt`.
  - After you raise the `go` version, run `go fix ./...` to apply the modernizers.
- To learn what a function, type, or interface does, use `go doc` or the LSP instead of memory. Your memory of an API can be out of date.
- When you review Go code, check every API claim against the docs for the Go version in `go.mod`.

## Errors

- Return errors with `fmt.Errorf("...: %v", err)`, not `%w`. Wrapping with `%w` makes the inner error part of the API: callers start to match it with `errors.Is` or `errors.As`, and you can no longer change it. Use `%w` only when callers must be able to check the inner error, and the API documents it.

## Testing

- Write black-box tests: put test files in `package x_test`, not `package x`. Tests that use only the exported API do not break when the internals change, and they show how callers use the package.
- Use `t.Context()` where a test needs a context.
- Split each test into Given, When, and Then sections. This makes clear what is setup, what is under test, and what is checked:

  ```go
  func TestParse(t *testing.T) {
    // Given

    // When

    // Then
  }
  ```

- Assertions:
  - Use `testify` only in the Then section. Use `require` when the test cannot continue after a failure, and `assert` when it can.
  - In Given and When, handle setup errors with `if err != nil { t.Fatal(err) }`. A testify assertion there looks like a check of the code under test, but it only checks the setup.
- Call `t.Helper()` in helper functions that fail the test, or that call a function that fails it. Then a failure points at the caller's line. Do not call it in helpers that cannot fail the test.
- Use table-driven tests when there are several cases. Put the test body in a `run` function, so the loop stays short and each case reads like a normal test:

  ```go
  func TestParse(t *testing.T) {
    type testCase struct {}

    run := func(t *testing.T, tc testCase) {
      // Given

      // When

      // Then
    }

    testCases := map[string]testCase{
      "": {},
    }

    for name, tc := range testCases {
      t.Run(name, func(t *testing.T) { run(t, tc) })
    }
  }
  ```
