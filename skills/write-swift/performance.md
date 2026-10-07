# Performance

The four costs, what each looks like in a trace and the levers that reduce it, for after the algorithm is right and a profile shows the problem.

## The four costs

1. Function calls: argument copies, static or dynamic dispatch, frame allocation and the optimizations a call blocks.
2. Memory layout: inline or out-of-line storage, and dynamically sized types.
3. Allocation: global storage is free, the stack costs one subtraction and the heap costs a search plus locking.
4. Copies: retains, releases and recursive struct copies.

## Reading a trace

Profile a test through Profile in the context menu of its run button, so the trace covers only that code.

| In the trace | It means |
| --- | --- |
| `platform_memmove` dominates | Accidental copying |
| Millions of short-lived allocations | Intermediate arrays |
| `swift_beginAccess` | Runtime exclusivity checks |
| `swift_retain` and `swift_release` | Reference-counting traffic |

## Levers, roughly in order of what they buy

- Mark a class you do not subclass `final`, which makes dispatch static and allows inlining. Whole-module optimization proves the same for internal classes and enables generic specialization.
- Struct storage is inline and class storage is out of line. A large struct with three reference fields costs three retains per copy, against one for a class, so a struct copied often moves its storage behind copy-on-write.
- An `any P` existential holds a value of up to three words inline and heap-allocates a larger one on every copy. Copy-on-write storage brings a large type back under the limit.
- `[MyModel]` packs densely and specializes, while `[any Model]` pays for its flexibility on every element.
- A generic parameter constrained to `AnyObject` gives the compiler a known representation without specialization.
- `InlineArray<N, T>` stores a fixed number of elements inline, with no heap allocation and no reference counting. It is the wrong choice for a value that gets copied or shared.
- `Span`, `RawSpan` and `MutableSpan` cannot escape, so the compiler ties them to the container's lifetime and the retains and releases disappear.
- Moving stored properties out of a nested class into the parent struct removes runtime exclusivity checks.

## Async costs

An async function keeps its state in a per-task allocator rather than on the C stack, and splits at each suspension point. A call costs slightly more than a synchronous one, so a function with nothing to await stays synchronous.

Each hop to or from the main actor is a context switch. Batch the work, so a function such as `updateUI` takes an array once rather than hopping twice per element.
