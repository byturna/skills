# Modern syntax

Each row replaces an older form with the current one. The last column is the Swift version the replacement needs, and every row works with Swift 6.2.

| Instead of | Write | Since |
| --- | --- | --- |
| Nested ternaries, or a closure called immediately to initialize a `let` | `if` and `switch` expressions | 5.9 |
| Overloads for one, two and three arguments | Parameter packs, `each T`, with `for` over a pack | 6.0 |
| `ObservableObject` with `@Published` on every property | `@Observable` | 5.9 |
| Polling an object for changes | `Observations { }`, an `AsyncSequence` of transactional updates | 6.2 |
| `NotificationCenter` with string-keyed `userInfo` | Message types conforming to `NotificationCenter.MainActorMessage` or `NotificationCenter.AsyncMessage` | 6.2 |
| `Process` with pipes in a script | The Subprocess package, with `strings()` on its output sequence for line-by-line output | 6.2 |
| String index arithmetic by hand | Swift Regex, with literals for short patterns and `RegexBuilder` for structure | 5.7 |
| A fixed-size `[String]` on a hot path | `InlineArray<N, T>` | 6.2 |
| `withUnsafeBufferPointer` | `.span`, or its `.bytes` for a `RawSpan` | 6.2 |
| `withUnsafeMutableBufferPointer` | `.mutableSpan` | 6.2 |
| Parsing a binary format with pointers | The Swift Binary Parsing package, with `ParserSpan` and overflow-checked parsing initializers | 6.2 |
| An awkward test function name | A raw identifier, as in `` @Test func `fruits have a tropical climate`() `` | 6.2 |

## Regex

Swift Regex composes with Foundation's parsers, such as `.date(_:locale:timeZone:calendar:)` and `.localizedCurrency(code:locale:)`. Never hand-roll date or number parsing inside a regex, and pass the locale explicitly.

Use `NegativeLookahead`, or `Local` for an atomic group, to stop a pattern backtracking across the whole input.
