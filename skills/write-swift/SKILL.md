---
name: write-swift
description: Writes, reviews and migrates modern Swift, from value types and generics to Swift 6 concurrency, performance and Swift Testing.
---

# Write Swift

This skill writes, reviews and migrates Swift at the language level. It chooses the type, the isolation, the abstraction and the test, starting from the simplest form that works.

It owns no interface rules. Those belong to the domain skills such as `layout`, `accessibility` and `motion`, and a review of interface code goes through `design-review`.

## Simplest first, and name the reason to move

The toolchain is Swift 6.2, the compiler in Xcode 26.3, and nothing here needs a later one. The concurrency rules assume the Swift 6.2 model, so they do not hold on Swift 6.1 or earlier.

Start with the simplest, most static and most single-threaded form that works. Move down a row only with a reason you can state:

| Need | Start with | Move down only when |
| --- | --- | --- |
| Data | `struct` or `enum` | You need identity, sharing or inheritance |
| Abstraction | A concrete type | Code repeats across types |
| Polymorphism | `some P` | You need to store different types together, then `any P` |
| Execution | Synchronous, on the main actor | Instruments shows a hang, then `async`, `@concurrent` and `actor` in that order |
| Memory | `Array` and `String` | Instruments shows the cost, then `InlineArray` or `Span` |
| Safety | A safe API | C interop or a measured hot path, then `Unsafe*` |

Match the project before applying any rule here: its language mode, its default isolation, its test framework and its toolchain. Never change a target's language mode or default isolation as a side effect of other work.

A finding is code that is wrong or that will force a rewrite. That means a data race, a reachable crash, undefined behavior, a deadlock, a leak or a regression you measured. Where two forms both compile and perform, the choice is a preference, so follow the project and write nothing. A performance claim without a measurement is a question, not a finding.

## Value types by default

- Use `struct` and `enum` by default. Use `class` only for identity, shared mutable state, inheritance or a resource's lifetime. A window or a database connection has identity, and a point or a color does not.
- Declare `let` unless the value mutates.
- A struct with a mutable reference-type property is neither a value nor a reference, because its copies share the object. Keep the referenced type immutable, forward to it through computed properties or put it behind copy-on-write.
- Copy-on-write gives out-of-line storage with value semantics. Wrap a final class in a struct and check `isKnownUniquelyReferenced(_:)` before mutating, copying first when it returns `false`. `Array`, `String` and `Dictionary` work this way.
- Model a fixed set of things, or mutually exclusive state, as an enum. One `enum State` in place of several optionals makes invalid combinations unrepresentable and changes state in one assignment.
- A struct whose stored properties are all values has value semantics, so undo, diffing and state restoration need one code path.

```swift
struct Material {
    var roughness: Double
    private var _texture: Texture  // a class

    var color: Color {
        get { _texture.color }
        set {
            if !isKnownUniquelyReferenced(&_texture) { _texture = Texture(copying: _texture) }
            _texture.color = newValue
        }
    }
}
```

Mark a type `~Copyable` for unique ownership, such as a file descriptor or an open transaction. A second use becomes a compile error, and a `deinit` on a struct becomes meaningful. Mark the finishing method `consuming` so the compiler proves it is the last use. A noncopyable parameter names its ownership: `borrowing` to read it, `consuming` to take it and `inout` to write to it for the call.

## Make the failure paths visible

- Throw for a recoverable error. Use `precondition` or `fatalError` for a programmer mistake, such as an index out of bounds, so the program halts before the bug spreads.
- Model errors as enums whose associated values carry the context, as in `case duplicateFriend(String)`.
- Use `guard` for an error condition, since it forces the exit, and `if let` for an ordinary unwrap.
- Use typed throws, `throws(MyError)`, for internal functions, generic code that forwards errors and constrained environments where boxing `any Error` costs too much. Public API keeps untyped `throws`, so its error type can change later.
- Force-unwrap only where you can state the invariant. Prefer `precondition` with a message, or `try #require` in a test, to a bare `!`.

## Stay on the main actor until a profile says otherwise

Most apps run correctly on the main thread alone. Take these steps in order, and take the next one only with a reason:

1. Synchronous code on the main actor.
2. `async` and `await` to wait on the network or the disk. SDK calls such as `URLSession`'s `data(from:)` leave the main thread on their own.
3. `@concurrent` on an expensive function of your own, after Instruments shows a hang.
4. An `actor` to move state off the main actor, when main-actor state forces tasks to hop back constantly.

Turn on Approachable Concurrency in every target. Set Default Actor Isolation to `MainActor` in app and interface modules, as new Xcode 26 app projects already do. A package sets it with `.defaultIsolation(MainActor.self)` in `swiftSettings`. A general-purpose library keeps nonisolated defaults and lets the caller decide where work runs.

In Swift 6.2, marking a function `async` does not move it off the caller's actor:

- `@concurrent` always runs on the concurrent thread pool. Put it on your CPU-heavy work.
- `nonisolated` runs wherever the caller runs, which makes it the default for library API. On a type, it makes every member nonisolated.
- With neither, the function stays on the caller's actor.

```swift
nonisolated struct PhotoProcessor {
    @concurrent
    func process(_ data: Data) async -> ProcessedPhoto {
        async let sticker = extractSticker(data)
        async let colors = extractColors(data)
        return await ProcessedPhoto(sticker: sticker, colors: colors)
    }
}
```

Make the code faster without concurrency before offloading it. A task costs an allocation and scheduling, so never spawn one for trivial work such as reading `UserDefaults`. Put work that must happen in order in one task, and give independent operations their own.

Every `await` is a suspension point. State can change and the thread can differ when it resumes, so re-check assumptions after it. Never hold a lock or rely on thread-local storage across one. Actor reentrancy and bridging older APIs are in [concurrency.md](concurrency.md).

## Send values, not shared objects

`Sendable` marks a type as safe to share across isolation domains, and the compiler checks it at every task and actor boundary.

- A non-public value type is `Sendable` when its stored properties are. A public type never infers it, because `Sendable` on a public type is a promise to clients that you write out.
- Actors and `@MainActor` classes are `Sendable`, since their state is isolated.
- Keep most model classes neither `@MainActor` nor `Sendable`, so no two domains can mutate one at once. To move one off the main actor, make it `nonisolated`, not `Sendable`.
- A non-`Sendable` value can still be sent when the sender stops using it. Finish every mutation before the handoff.
- Mark a function type `@Sendable` only when it crosses domains.
- Reserve `@unchecked Sendable` for a type with real internal synchronization, such as a `Mutex`. `nonisolated(unsafe)` on a global is the last resort, never a way to silence a warning.

Fix a data-race error in this order:

1. Stop sharing it. Give each concurrent job its own instance through a local, which fixes most real errors.
2. Make it a `Sendable` value type, so sharing becomes copying.
3. Isolate it to the main actor or to an actor of your own.
4. Only then use `Mutex` or `Atomic` from the `Synchronization` module, stored in a `let`, or `@unchecked Sendable`.

Global and static variables cause the most errors. Make one a `let`, put it on `@MainActor`, wrap it in a `Mutex` or, last, mark it `nonisolated(unsafe)`. Swift initializes globals lazily and atomically.

## Structured tasks first

Structured tasks end with their scope, are awaited automatically and inherit cancellation, priority and task-local values. Unstructured tasks get none of that unless you manage it.

- Use `async let` for a fixed number of children and a task group for a dynamic number.
- Use `Task { }` only when the work outlives any scope, as in a response to a button tap or a delegate callback. It inherits isolation and priority, and you own its cancellation.
- Use `Task.detached` almost never, since it inherits nothing.

Cancellation is cooperative, so check for it before expensive work. Task groups, cancellation and task-local values are in [concurrency.md](concurrency.md#task-groups).

## SwiftUI isolation

- `View` is isolated to the main actor, and so is its `@State`. Never write `@MainActor` on a view.
- SwiftUI calls some of your code off the main actor. The `visualEffect` and `onGeometryChange` closures are `@Sendable`, and `Shape`'s `path(in:)` and `Layout`'s requirements are nonisolated. Inside one, copy the value you need into the capture list rather than capturing `self`.

```swift
.visualEffect { [pulse] effect, proxy in
    effect.blur(radius: pulse ? 2 : 0)
}
```

- SwiftUI's action closures are synchronous, so an animation starts on the frame of its event. Make the `withAnimation` state change in the closure, and open a `Task` only for the long work that follows.
- Put one piece of state between the view and its async work. The view starts a task, the async layer makes one synchronous mutation when it finishes and the view reacts. The async logic then tests without SwiftUI.

## Concrete types before protocols

Write concrete types, notice the code that repeats across them, factor the shared capability into a protocol and only then write generic code against it. Overloads with near-identical bodies are the signal to generalize.

- A protocol whose every conformer would use the default implementation should be a constrained extension instead. Deep protocol hierarchies cost compile time and binary size.
- Prefer has-a to is-a. When only some of a protocol's operations fit your type, wrap a value in a generic struct that exposes what you mean, as in `GeometricVector<Storage: SIMD>`.
- A protocol requirement is a customization point, dispatched dynamically. A method only in an extension is dispatched statically, so a conformer's version shadows it and code holding `any P` calls the extension's. Make anything a type may customize a requirement.
- Compose small values instead of inheriting from a class. Inheritance allows one superclass, brings its stored properties and initializers and leaves unwritten rules about overriding.
- A forced downcast usually means a type relationship was lost to a class hierarchy or an existential.

### `some` before `any`

- Write `some P` by default and change to `any P` when you must store values of different types. `some P` keeps one underlying type per scope, with its associated types, and lets the compiler specialize.
- `any P` is a box whose type varies at runtime. It erases associated types to their bounds and blocks optimization.
- A method that takes an associated type cannot be called on `any P`. Pass the existential to a function that takes `some P`, which opens it.
- A constrained type such as `some Collection<Element>` hides the concrete type and keeps the element type. Declare a primary associated type on your own protocol, as in `protocol Container<Item>`, for the type callers supply.
- Tie protocols together with same-type requirements in a `where` clause, as in `where Self.CropType.FeedType == Self`, so a wrong conformance fails to compile.

## Clarity at the point of use

Clarity at the point of use outranks brevity and every other API goal.

- Use no type prefixes in Swift-only API, since modules disambiguate. Keep a prefix only where the API mirrors an Objective-C one, and avoid names so general they read badly out of context.
- Drop a leading `get` from accessors and async functions that return their result, as in `persistentPosts`.
- State access control at every module boundary with `private`, `fileprivate`, `internal`, `package` or `public`. The boundary is where sendability and evolution get decided.
- Make illegal states unspellable, with private setters behind a validating `mutating` method, enums for closed sets and a typed identifier in place of a `String`.
- A property wrapper names an access policy in one word at the declaration, such as `@Published` or a defensive copy. Combined with `@dynamicMemberLookup` on a key path, it projects through to the wrapped value, which is how `$binding.title` works.
- Use result builders for declarative DSLs, and macros as **Macros only for code the compiler could write** describes.

## Measure, then optimize

Fix the algorithm first. Replace a hand-written loop with a standard algorithm, and know the complexity of what you call. `remove(at:)` is O(n), so calling it in a loop is O(n²), while `removeAll(where:)` is O(n) in total.

Chained `map`, `filter` and `flatMap` allocate an array per stage. On a per-element hot path, size the output once and write into it.

Then profile with Instruments' Time Profiler and Allocations. How to profile one test, the four costs and the levers for each are in [performance.md](performance.md).

## Lifetimes end at the last use

- An object's guaranteed lifetime ends at its last use, not at the closing brace. The optimizer changes observed lifetimes, so code that depends on when `deinit` runs is a latent bug.
- `weak` and `unowned` break reference cycles and do nothing else. A `weak` reference read after the owner's last use may be `nil`, and an optional binding there turns a crash into a silent wrong answer.
- Prefer not building the cycle. Move the shared data into a third type that both sides reference, which turns the cycle into a tree.
- Next, redesign the API so the object is reachable only through a strong reference. `withExtendedLifetime` works as a patch, not a design.
- Keep side effects outside the object out of `deinit`. Publish a metric with `defer` at the call site instead.
- The Optimize Object Lifetimes build setting shortens observed lifetimes toward the minimum, which surfaces these bugs.

## Swift Testing for new tests

Write new tests with Swift Testing. XCTest stays for UI automation with `XCUIApplication`, performance metrics with `XCTMetric` and tests in Objective-C. Both frameworks run in one target, so migrate one test at a time. Expectations, suites, arguments, traits and known issues are in [testing.md](testing.md).

## Macros only for code the compiler could write

- Macros are type-checked before expansion, so a misuse fails at the call site.
- A freestanding macro, `#name`, produces an expression or a declaration. An attached macro, `@Name`, adds to a declaration through its roles, such as member, peer, accessor, member attribute and extension. `@Observable` combines member, member attribute and extension.
- Test a macro as a syntax-tree transform with `assertMacroExpansion`. To learn a node's shape, set a breakpoint in `expansion` and print the node.
- Emit a diagnostic when the macro does not apply. Throw an error, or call `context.diagnose(_:)` for a warning or a fix-it at a location. Never let a macro generate code that fails to compile.
- Expanded code is ordinary Swift. Expand Macro in Xcode shows it, and the debugger steps through it.

## Logger, not print

- Log with `Logger` from `os`, one per subsystem and category. Messages are stored compactly and rendered only when displayed, so logging can stay in shipping code.
- Interpolated values other than numbers are redacted by default. Mark a value `privacy: .public` only when it is not personal, and use `.private(mask: .hash)` to correlate values without showing them.
- Levels run from `debug`, never persisted and cheapest, through `info`, `notice` and `error` to `fault`, the most persistent. `notice` is the default. Log what a bug report needs at `error` or `fault`.
- Log a correlation ID, such as a request UUID, so a failure's history can be filtered out of a device log archive. Collect one with `log collect --device`, then filter by subsystem in Console.
- Use the `format:` and `align:` interpolation options, so log columns line up.
- LLDB steps through `await` across threads, and `language swift task info` prints the task running on the current thread. Named tasks appear in the debugger and in Instruments' Swift Concurrency template.

## Unsafe code stays small

- Unsafe means the API cannot validate its input, so a broken precondition is undefined behavior rather than a crash. A safe API traps on purpose.
- Use `Span` rather than an `Unsafe*Pointer` for contiguous storage, and keep raw pointers for C interop.
- Where you need pointers, keep the unsafe region small and use buffer pointers so the count travels with the address. Never let a pointer escape the closure that vends it, and run the Address Sanitizer.
- Turn on strict memory safety in security-critical modules. It makes every unsafe use visible in source, which makes an audit possible.
- C, Objective-C and C++ types map into Swift directly, including C++ containers as Swift collections and move-only types as `~Copyable`. Adopt Swift one file at a time rather than rewriting.

## Write the current form

Agents often write an older, longer form of something Swift already has, such as `ObservableObject` where `@Observable` fits. The replacements and the Swift version each needs are in [modern-syntax.md](modern-syntax.md).

## Migrate one target at a time

Turn on Approachable Concurrency and, in app modules, main-actor default isolation before starting, since both remove most errors. Start with the app and interface layer, which the SDK already annotates, and take each target through these steps:

1. Build with the new compiler in the Swift 5 language mode, which should need no source changes.
2. Turn on complete concurrency checking.
3. Fix the warnings, cheapest first. A few root causes account for most of them, such as a `var` global that should be a `let` or a free function that belongs on `@MainActor`.
4. Switch the target to the Swift 6 language mode.
5. Move to the next target.

Refactor afterwards, in a separate change. A refactor mixed into data-race fixes has to be backed out with them. Every fix made under complete checking stays an improvement, even if checking goes back off.

## Before you finish

| Pattern | Fix |
| --- | --- |
| `Task.detached` or `DispatchQueue.global()` to leave the main actor | An `async` function marked `@concurrent`, once a profile shows the need |
| `async` on a function with no `await` inside | Drop `async` |
| A `Task { }` per element of an unbounded collection | A task group that keeps a fixed number of children running |
| `@unchecked Sendable` or `nonisolated(unsafe)` with no lock or `Mutex` behind it | Stop sharing the value, or isolate it to an actor |
| `DispatchSemaphore` or `NSCondition` around an `await` | Restructure, since nothing may block across a suspension |
| `@MainActor` on a `View` | Delete it |
| `self` captured in a `visualEffect` or `onGeometryChange` closure | Copy the one value into the capture list |
| `remove(at:)` inside a loop | `removeAll(where:)` |
| `withUnsafeBufferPointer` outside C interop | `.span` |
| `ObservableObject` with `@Published` in new code | `@Observable` |
| `[any P]` holding one concrete type | `[ConcreteType]`, or `some P` |
| `!` with no stated invariant | `guard`, or `precondition` with a message |
| `throws(SomeError)` on `public` API | Untyped `throws` |
| `withExtendedLifetime` keeping a `weak` reference alive | Restructure the cycle into a tree |
| A new `XCTestCase` for a unit test | `@Test` with `#expect` |
| `print(` in shipping code | `Logger` |

## Reporting

**Severity.** `HIGH` is a data race, a reachable crash, undefined behavior, a deadlock or a leak. `MEDIUM` is code that is correct today but will force a rewrite or hide a bug. Examples are a detached task where a structured one fits, `nonisolated(unsafe)` silencing a warning, a test that cannot fail or a measured regression. `LOW` is an older form with a direct replacement, or naming.

**Verification.** With Xcode or a Swift toolchain, build in the project's language mode and run its tests. Profile any performance claim in Instruments. Without them, as in a Linux or cloud session, read the code against the rules above and mark the build and the tests `Not verified`.

**Format.** Group findings under the heading each violates, ordered by severity, one row per root cause listing every location it appears in:

| Severity | Location | Before | After | Why |
| --- | --- | --- | --- | --- |

`Location` is `path/to/file.swift:line`. `Why` names the heading and the consequence.

End with `Block` when any `HIGH` remains, `Approve` otherwise, leaving the rest in the table as work to do. Never `Approve` code you did not read. With nothing to report, state "No actionable Swift findings" and report verification.
