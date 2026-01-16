
- Use idiomatic code style.
- Follow "Effective Go" guidelines.
- Follow the "Go Code Review Comments" guidelines.


### Testing

- Prefer black-box testing over white-box testing.
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
