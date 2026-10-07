# Text styles

The text-style table, the heading order, leading and why the system font needs no tracking.

## The table

Sizes and leading are in points, at the default Large text size, with the smallest size and AX5 for comparison:

| Style | SwiftUI | Weight | Size | Leading | Emphasized | xSmall | AX5 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Large Title | `.largeTitle` | Regular | 34 | 41 | Bold | 31 | 60 |
| Title 1 | `.title` | Regular | 28 | 34 | Bold | 25 | 58 |
| Title 2 | `.title2` | Regular | 22 | 28 | Bold | 19 | 56 |
| Title 3 | `.title3` | Regular | 20 | 25 | Semibold | 17 | 55 |
| Headline | `.headline` | Semibold | 17 | 22 | Semibold | 14 | 53 |
| Body | `.body` | Regular | 17 | 22 | Semibold | 14 | 53 |
| Callout | `.callout` | Regular | 16 | 21 | Semibold | 13 | 51 |
| Subhead | `.subheadline` | Regular | 15 | 20 | Semibold | 12 | 49 |
| Footnote | `.footnote` | Regular | 13 | 18 | Semibold | 12 | 44 |
| Caption 1 | `.caption` | Regular | 12 | 16 | Semibold | 11 | 43 |
| Caption 2 | `.caption2` | Regular | 11 | 13 | Semibold | 11 | 40 |

The HIG lists every size from xSmall to AX5. `.bold()` gives a style its emphasized weight.

```swift
// Good: text styles carry size, weight and leading at every Dynamic Type size
VStack(alignment: .leading, spacing: 4) {
    Text(article.title)
        .font(.title2)
    Text(article.byline)
        .font(.subheadline)
        .foregroundStyle(.secondary)
    Text(article.summary)
        .font(.body)
}

// Bad: fixed sizes that never scale
Text(article.title)
    .font(.system(size: 22, weight: .bold))
```

A style takes a design, a width or emphasis without leaving the scale:

```swift
Text(article.title)
    .font(.title2.bold())

Text(article.pullQuote)
    .font(.title3)
    .fontDesign(.serif)

Text(stats.headline)
    .font(.headline)
    .fontWidth(.condensed)
```

## Headings

| Level | Style |
| --- | --- |
| Screen title | `.largeTitle`, or the navigation title |
| Section | `.title2` or `.title3` |
| Group within a section | `.headline` |

Skip a step where a screen needs fewer levels.

## Leading

```swift
Text(chapter.text)
    .font(.body.leading(.loose))
```

`.lineSpacing(10)` puts 10pt between the bottom of one line and the top of the next, on top of the font's leading. It is not a multiplier, and it does not grow with Dynamic Type.

## Tracking

The system font applies its own tracking at every point size: positive below 12pt, negative from 13pt to 23pt and positive again from 24pt. Some values from the HIG's SF Pro table:

| Size | Tracking |
| --- | --- |
| 11pt | +0.06pt |
| 13pt | -0.08pt |
| 17pt | -0.43pt |
| 20pt | -0.45pt |
| 28pt | +0.38pt |
| 34pt | +0.40pt |

These exist for mockups drawn in a design tool. In the app, the font applies them on its own, so tracking added by hand stacks on top of them.
