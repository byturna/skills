# Testing

Expectations, suites, arguments, traits and known issues in Swift Testing.

## Expectations

- `@Test` goes on any function, global, static or instance, including `async`, `throws` and global-actor-isolated ones.
- `#expect` takes an ordinary expression, such as `#expect(a == b)` or `#expect(!list.isEmpty)`, and shows each subexpression's value on failure.
- `try #require` stops the test on failure and unwraps an optional. It replaces `continueAfterFailure = false` one expectation at a time.

## Suites

- A suite is a `struct`, and each test gets a fresh instance, so state cannot leak between tests. Set up in `init`.
- Use a `class` or an `actor` only when teardown needs `deinit`.
- Nest suites to group them.

## Arguments

`@Test(arguments:)` runs each case independently and in parallel. Each case reruns on its own, and a failure names its argument. Two argument collections run their full cross product, so pass `zip(_:_:)` for matched pairs.

## Traits

- `.enabled(if:)` and `.disabled(_:)` state a condition. A disabled test still compiles, so never comment a test out.
- `.bug(_:_:)` links a tracker, `.tags(_:)` relates tests across files and targets and `.timeLimit(_:)` caps a test's duration.
- Tests run in parallel and in random order by default, which surfaces hidden dependencies between them. Refactor such a dependency before reaching for `.serialized`.
- Gate a test on an OS version with `@available` rather than `#available`, so the testing library knows.

## Known issues and callbacks

- Wrap a failure outside your control in `withKnownIssue { }`. The test keeps compiling and running, and it reports when the issue is fixed.
- Check a callback that fires a set number of times with `confirmation(_:expectedCount:isolation:sourceLocation:_:)`. Use `withCheckedContinuation` for a one-shot callback with no async overload.
