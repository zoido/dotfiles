
# Go Code Style and Testing Guidelines

- Use idiomatic code style.
- Follow "Effective Go" guidelines.
- Follow the "Go Code Review Comments" guidelines.
- Make sure that code uses the latest features according to the Go version in the `go.mod` file.

## Testing

- Prefer black-box testing over white-box testing.
  - `package x_test` is preferred over `package x` for test files.
- Use of `t.Context()` where context is needed in tests.
- Use Given-When-Then structure for tests.
  - Given: Setup the initial state.
  - When: Execute the code under test.
  - Then: Verify the results.
  - Example:
    ```
    func Test(t *testing.T)
	  // Given

	  // When

	  // Then
    }
  ```
- Assertions:
  - Use the `testify` package for assertions.
    - Prefer `require` for critical assertions that should stop the test immediately.
    - Use `assert` for non-critical assertions that allow the test to continue.
  - Do not use assertions outside of the assertion (Then), use standard if err and t.Fatal or t.Error for error handling in Given and When sections.
- Call `t.Helper()` in helper functions to improve error reporting.
  - Do not call `t.Helper()` when the function does not fail the test, or does not call another function that fails the test.
- Prefer table-driven tests when multiple test cases are needed.
  - Use this structure for table-driven tests:
    ```
      func Test(t *testing.T) {
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

## Reviews

Always consult with the documentation according to the Go version in the `go.mod` file when reviewing code.
