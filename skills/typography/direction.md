# Direction

Text alignment in both reading directions, mixed-direction text and scripts the interface language does not use. Mirroring the layout belongs to `layout`, and directional symbols to `ui`.

## Alignment

```swift
// Good: leading follows the reading direction
Text(item.details)
    .multilineTextAlignment(.leading)

// Bad: a centered paragraph is hard to scan in either direction
Text(item.details)
    .multilineTextAlignment(.center)
```

Where the app knows a paragraph's direction differs from the interface's, such as an English review in an Arabic interface, set it on that paragraph:

```swift
Text(review.body)
    .frame(maxWidth: .infinity, alignment: .leading)
    .environment(\.layoutDirection, review.isRightToLeft ? .rightToLeft : .leftToRight)
```

## Mixed-direction text

The digits of a number, a phone number or a card number keep their order in every language. Never reverse them by hand.

A value whose direction differs from the sentence around it can pull its neighbors out of order, such as a Hebrew file name in an English sentence. Check each such sentence in the right-to-left pseudolanguage with real values. Where one reorders, wrap the value in the Unicode isolates, U+2068 and U+2069:

```swift
let isolatedName = "\u{2068}\(file.name)\u{2069}"
Text("Shared \(isolatedName) with you")
```

## Scripts

Text in a script the interface language does not use, such as Thai inside an English interface, takes its language for typesetting. Line height, line breaks and spacing then fit that script:

```swift
Text(verbatim: post.text)
    .typesettingLanguage(post.language)
```

Arabic and Hebrew have no capitals, so they can look small next to uppercase Latin text in a title or a label. The HIG suggests setting the right-to-left text about 2pt larger there.
