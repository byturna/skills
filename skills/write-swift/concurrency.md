# Concurrency

Actor reentrancy, task groups, cancellation, task-local values and bridging older APIs, for when the rules in `SKILL.md` lead to an actor or a task.

## Actors are not transactions

An actor guarantees mutual exclusion, not atomicity across an `await`. Between two suspensions on one actor, other work runs.

- Mutate actor state in synchronous methods. Synchronous code on an actor runs to completion, so it is the transaction boundary.
- Keep async actor methods thin, built from synchronous steps, and leave the state consistent at every `await`.
- Watch for a check, an `await` and then a write. Two tasks both miss a cache, both download and the second overwrites the first. Re-check after the `await`, or deduplicate the work in flight.
- An actor is not FIFO. It runs higher-priority work first to avoid priority inversion. For ordering, use one task, which runs start to finish, or an `AsyncStream`.

## Task groups

- A task group is an `AsyncSequence`, so iterate the results of `withTaskGroup` as they finish.
- Use `withDiscardingTaskGroup` when children return nothing, since it frees each child as it finishes. `withThrowingDiscardingTaskGroup` also cancels the rest on the first error.
- Bound the fan-out. Start a fixed number of children, then add one each time one finishes, rather than one child per item of an unbounded list.
- Where a detached root is unavoidable, put a task group inside it rather than detaching repeatedly.

## Cancellation

Check with `Task.isCancelled` or `try Task.checkCancellation()`, in synchronous helpers too.

Work that is suspended rather than running, such as an `AsyncSequence` waiting in `next()`, needs `withTaskCancellationHandler`. Its handler runs immediately and concurrently with the body. The state it touches needs a `Mutex` or an atomic, because an actor cannot guarantee the order.

## Task-local values

`@TaskLocal` carries context such as a request ID down the task tree without a parameter in every signature. Declare it optional, so a read outside any binding has a sensible default.

## Bridging older APIs

- Wrap a callback with `withCheckedContinuation` or `withCheckedThrowingContinuation`, and resume exactly once on every path. A continuation never resumed hangs the caller, and one resumed twice traps. For a delegate that fires later, store the continuation and set it to `nil` when you resume.
- Adapt a handler or delegate API with `AsyncStream` or `AsyncThrowingStream`. Create the source inside the closure, `yield` from the handler and clean up in `onTermination`. Iterate with `for await` or `for try await`.
- Annotate a delegate protocol you own with `@MainActor`. For one you do not own, mark the method `nonisolated` and wrap its body in `MainActor.assumeIsolated { }`, which traps rather than racing. `@preconcurrency` on the conformance does the same for every method.
- `@preconcurrency import` silences sendability warnings from a module that has not migrated. Remove it once the module does, and the warnings return correctly.
