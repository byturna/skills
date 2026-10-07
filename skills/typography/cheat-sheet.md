# Cheat sheet

Every typography API this skill names, with its UIKit equivalent. Match whichever the view under review is written in.

## Fonts and scaling

| Need | SwiftUI | UIKit |
| --- | --- | --- |
| Text style | `.font(.body)` | `UIFont.preferredFont(forTextStyle: .body)` with `adjustsFontForContentSizeCategory = true` |
| Emphasized style | `.font(.body.bold())`, `.bold()` | `UIFontDescriptor` with `.traitBold` |
| Weight | `.fontWeight(_:)` | `UIFont.systemFont(ofSize:weight:)` scaled through `UIFontMetrics` |
| New York, SF Rounded, SF Mono | `.fontDesign(.serif)`, `.rounded`, `.monospaced` | `UIFontDescriptor.withDesign(_:)` |
| Condensed or expanded | `.fontWidth(_:)` | `UIFont.systemFont(ofSize:weight:width:)` scaled through `UIFontMetrics` |
| Custom font that scales | `Font.custom(_:size:relativeTo:)` | `UIFontMetrics(forTextStyle:).scaledFont(for:)` |
| Custom font that never scales | `Font.custom(_:fixedSize:)` | `UIFont(name:size:)` |
| Bold Text | `@Environment(\.legibilityWeight)` | `traitCollection.legibilityWeight` |
| Dimension that scales with text | `@ScaledMetric(relativeTo:)` | `UIFontMetrics(forTextStyle:).scaledValue(for:)` |
| Current text size | `@Environment(\.dynamicTypeSize)` | `traitCollection.preferredContentSizeCategory` |

## Lines

| Need | SwiftUI | UIKit |
| --- | --- | --- |
| Loose or tight leading | `Font.leading(.loose)`, `.tight` | `UIFontDescriptor` with `.traitLooseLeading` or `.traitTightLeading` |
| Line height for a custom font | `.lineHeight(_:)` | `NSParagraphStyle.lineHeightMultiple` |
| Space added between lines | `.lineSpacing(_:)` | `NSParagraphStyle.lineSpacing` |
| Line limit | `.lineLimit(_:)` | `numberOfLines` |
| Line limit that keeps its height | `.lineLimit(_:reservesSpace:)` | No direct equivalent |
| Truncation position | `.truncationMode(.middle)` | `lineBreakMode = .byTruncatingMiddle` |
| Alignment | `.multilineTextAlignment(.leading)` | `textAlignment = .natural` |

## Characters

| Need | SwiftUI | UIKit |
| --- | --- | --- |
| Tabular digits | `.monospacedDigit()` | `UIFont.monospacedDigitSystemFont(ofSize:weight:)` |
| Formatted number | `Text(_:format:)` | `formatted(_:)` on the value |
| Displayed capitals | `.textCase(.uppercase)` | `uppercased(with:)` on the string |
| Tracking for a custom font | `.tracking(_:)` | `NSAttributedString.Key.tracking` |
| Typesetting language | `.typesettingLanguage(_:)` | No direct equivalent |
| Selectable text | `.textSelection(.enabled)` | `UITextView` with `isSelectable = true` and `isEditable = false` |
