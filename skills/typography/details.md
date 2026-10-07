# Details

Numerals, truncation, punctuation, decorative text and selection.

## Numerals

```swift
// Good: every digit keeps one width, so the column stays aligned
Text(line.price, format: .currency(code: line.currencyCode))
    .monospacedDigit()

// Good: a running timer does not jitter as its digits change
Text(elapsed, format: .time(pattern: .minuteSecond))
    .font(.title.monospacedDigit())
```

`Text(_:format:)` takes the locale's digits, separators and currency placement. Where the app treats numbers as its subject, such as a math or finance tool, check each locale's numeral system rather than relying on the default.

## Truncation

```swift
// The end of a file name carries its extension, so truncate the middle
Text(file.name)
    .lineLimit(1)
    .truncationMode(.middle)

// Every card in the grid keeps two lines of height, whatever the title's length
Text(album.title)
    .lineLimit(2, reservesSpace: true)

// Bad: shrinks text a person enlarged
Text(product.name)
    .lineLimit(1)
    .minimumScaleFactor(0.5)
```

The HIG asks for as much useful text at the largest accessibility size as at the largest standard one. A line limit that holds at the default size may hide most of a title at AX5. Whether the row has room or a way to the full text is `layout`'s.

## Punctuation

| Instead of | Use | Escape |
| --- | --- | --- |
| Straight double quotes | The language's quotation marks, left and right double quotation marks in English | `\u{201C}`, `\u{201D}` |
| A straight apostrophe | The right single quotation mark | `\u{2019}` |
| Three periods | The ellipsis character | `\u{2026}` |
| A hyphen in a range, as in 9-5 | The en dash | `\u{2013}` |
| A space between a number and its unit | The no-break space | `\u{00A0}` |

Put the characters into the String Catalog values themselves. Each translation carries its own language's marks, such as guillemets in French.

```swift
// Stored in natural case, displayed in capitals
Text("New")
    .textCase(.uppercase)
```

## Decorative text

```swift
Text("Year in Review")
    .font(.largeTitle.bold())
    .foregroundStyle(Color.accentColor.gradient)
```

The text keeps its text style, scales, reads under VoiceOver and translates. Which colors fill it belongs to `color`.

## Selection

```swift
Text(order.number)
    .textSelection(.enabled)
```

`.textSelection(.enabled)` lets people copy the text with a long press. A long passage people quote, such as a message, takes it too.
