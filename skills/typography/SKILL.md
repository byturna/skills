---
name: typography
description: Sets and reviews how text renders in SwiftUI and UIKit apps, from Dynamic Type text styles and custom fonts to weights, numerals, truncation and punctuation.
---

# Typography

This skill decides how text on an iOS screen is set: its text style, font, weight, leading, numerals, line limits, direction and punctuation. It writes every fix through text styles first, so the text keeps scaling with Dynamic Type.

Whether text must scale, how far it must scale and the Large Content Viewer belong to `accessibility`, and so does the header trait. How a layout changes at accessibility sizes belongs to `layout`, and so does whether truncated text has room or a way to expand. The words and their capitalization belong to `writing`, text color and contrast to `color` and a symbol's size beside text to `ui`. The UIKit form of every API here is in [cheat-sheet.md](cheat-sheet.md).

## Text styles first, values second

SF Pro and the text styles already carry size, weight, leading and per-size tracking at every Dynamic Type size, and they follow Bold Text. Most findings here are code that overrides them. Typical ones are a fixed point size, added tracking, a line spacing carried over from a web design and a light weight on small text.

The text-style table, the 17pt default and 11pt minimum, `relativeTo:` on every custom font and `.monospacedDigit()` on changing values are exact. How many fonts a project uses and how they pair are heuristics, reported only where they break the project's own scale. Never propose a new typeface unless the task asks for a type change.

## Text styles are the type scale

Every piece of text takes a text style, from `.largeTitle` to `.caption2`. Each one carries size, weight and leading at every Dynamic Type size. Never set `.system(size:)` on body or control text, because a fixed size does not scale. Choose a style by role, and change its look with `.bold()`, `.fontDesign` or `.fontWidth` rather than a size. The table is in [text-styles.md](text-styles.md).

## Headings descend with their level

Use `.largeTitle`, `.title`, `.title2`, `.title3` and `.headline` in order, so a lower heading never outranks the one above it. A heading never sets smaller than the body text beneath it. `.headline` matches `.body` in size and stands apart by weight, which holds at every Dynamic Type size. See [text-styles.md](text-styles.md#headings).

## 17pt body, 11pt floor

Body text is `.body`, 17pt at the default size. Nothing sets smaller than `.caption2`, which is 11pt at the default size and at every smaller one. A custom font with a thin weight sets larger than these. See [text-styles.md](text-styles.md#the-table).

## Regular weight and up

Reading text uses Regular, Medium, Semibold or Bold. `.ultraLight`, `.thin` and `.light` are hard to read, above all at small sizes, so keep them to text of 28pt and up, which is `.title` and larger. Apple publishes no threshold, so 28pt is a working line. Emphasize within a style with `.bold()`, which gives each style its emphasized weight, or with `.fontWeight`. Never emphasize by stepping up a size.

## Leave SF Pro's spacing alone

The system font sets its own tracking at every point size and blends its optical sizes continuously. Never add `.tracking` or `.kerning` to system text, and never choose a Text or Display cut by name. Never bundle or name the SF or New York files. Reach New York, SF Rounded and SF Mono through `.fontDesign(.serif)`, `.rounded` and `.monospaced`, and SF's widths through `.fontWidth`. A mockup's tracking values describe the system font and never move into code. See [text-styles.md](text-styles.md#tracking).

## Leading comes from the font

Text styles carry their leading. Loosen it with `Font.leading(.loose)` for long passages in wide columns, and tighten it with `.tight` for a height-constrained row. Never use tight leading on text that runs to three lines or more. `.lineSpacing` adds points between lines, so it never stands in for a web line-height. See [text-styles.md](text-styles.md#leading).

## One custom family, scaled to a style

Use as few typefaces as the design allows, often the system font and at most one custom family. A custom font is registered in `UIAppFonts` and named by its PostScript name. It takes `Font.custom(_:size:relativeTo:)` with the text style it stands in for, at that style's default size.

SwiftUI falls back to the system font without an error when it cannot find a face, and never synthesizes bold or italic. Bundle every face the design uses. Define each role once, rather than repeating a name and a size at every call site. See [custom-fonts.md](custom-fonts.md).

## Custom fonts follow Bold Text

Text styles get heavier under Bold Text on their own, and a custom font does not. Read `@Environment(\.legibilityWeight)` and switch to the next heavier face when it is `.bold`. The recipe is in [custom-fonts.md](custom-fonts.md#bold-text).

## What sits with text scales with it

An icon frame, a thumbnail, padding or a fixed height that sits beside text takes `@ScaledMetric(relativeTo:)` with the text's style. A fixed number beside scaling text crowds it at larger sizes. SF Symbols scale with their font on their own. See [custom-fonts.md](custom-fonts.md#scaled-dimensions).

## Tabular digits on changing values

Timers, counters, scores and prices in a column take `.monospacedDigit()`, so each digit keeps one width and nothing shifts. Numbers in running text stay proportional. Format every number with a format style, so each locale gets its own digits and separators. Animating a changing number belongs to `motion`. See [details.md](details.md#numerals).

## Widgets and Live Activities read at a glance

Text in a widget or a Live Activity keeps its text styles, and widgets scale it from Large up to AX5. Keep a custom font to a widget's large figure, and set the rest in the system font. A Live Activity uses Medium weight or heavier, and keeps small text to secondary details.

A countdown or a running clock is `Text(timerInterval:countsDown:)` or `Text(_:style:)` with `.timer`. The system keeps both current without a timeline reload, and both take `.monospacedDigit()` like any changing value.

## Wrap by default, truncate on purpose

Text wraps until the layout stops it. `.lineLimit` belongs where the design truncates on purpose, such as a list row title. Use `.truncationMode(.middle)` for a file name or an identifier whose end matters, and `.lineLimit(_:reservesSpace:)` to keep rows of a grid aligned. Never use `.minimumScaleFactor` on body or control text, because it shrinks text a person enlarged. See [details.md](details.md#truncation).

## Align text with its reading direction

Multiline text aligns to `.leading`, which is `.natural` in UIKit, and never to a physical side. Center only one or two lines, such as an empty state's message. A paragraph of three lines or more aligns to its own language, even inside an interface in another direction. Every item in a list aligns the same way. See [direction.md](direction.md#alignment).

## Mixed scripts keep their order and height

The digits of a number never reverse. A user value whose direction differs from the sentence around it, such as an Arabic name in English text, is wrapped in Unicode isolates if it reorders. Text in a script the interface language does not use takes `.typesettingLanguage`, so its line height fits tall glyphs. See [direction.md](direction.md#mixed-direction-text).

## Natural case, typographic punctuation

Store strings in natural case and display capitals with `.textCase(.uppercase)`, so a design change never means rewriting copy. Rendered strings use typographic characters: the language's own quotation marks, an ellipsis, an en dash in a range and a no-break space before a unit. Code keeps straight quotes. The table is in [details.md](details.md#punctuation).

## Real text, never pictures of text

Gradients and shadows on text are modifiers on a `Text`, never a rendered image. An image of text does not scale with Dynamic Type or translate, and VoiceOver reads it only through a label someone wrote. See [details.md](details.md#decorative-text).

## Selectable where people copy

Text on iOS is not selectable by default. Add `.textSelection(.enabled)` to the content people copy, such as an order number, an address, an error code or a message. Never add it to labels and controls. See [details.md](details.md#selection).

## Before you finish

| Pattern | Fix |
| --- | --- |
| `.font(.system(size:))` on body or control text | A text style |
| `Font.custom(_:size:)` on text that is not body, with no `relativeTo:` | `relativeTo:` the style it stands in for |
| `Font.custom(_:fixedSize:)` on content | `Font.custom(_:size:relativeTo:)` |
| A `Font.custom` name missing from `UIAppFonts`, or not a PostScript name | Register the file and use its PostScript name |
| `Font.custom` naming SF Pro or New York, or their files in the bundle | `.fontDesign` and `.fontWidth` |
| `.tracking` or `.kerning` on system text | Remove it |
| `.ultraLight`, `.thin` or `.light` below 28pt, under `.title` | `.regular` or heavier |
| A size below 11pt | `.caption2` at the smallest |
| A heading style smaller than the heading below it, or than body text | The next style up the scale |
| `.lineSpacing` on interface text | Remove it, or `Font.leading(.loose)` on a long passage |
| `.leading(.tight)` on text that can reach three lines | `.standard` |
| A custom font with no `legibilityWeight` branch | The Bold Text recipe |
| A fixed `.frame` or padding beside text | `@ScaledMetric(relativeTo:)` |
| A timer, counter, score or price column without `.monospacedDigit()` | Add it |
| `.minimumScaleFactor` on body or control text | Wrap, or truncate with a way back |
| `.lineLimit(1)` with no reason to truncate | Remove the limit |
| A centered paragraph, or `.left` alignment in UIKit | `.leading`, or `.natural` |
| Capitals typed into a string | Natural case with `.textCase(.uppercase)` |
| `...`, `--`, a hyphenated range or straight quotes in a user-facing string | The typographic character |
| Text drawn into an image asset | A `Text` with its styling |
| `.textSelection(.enabled)` on a container of labels and controls | Only on the content people copy |
| A UIKit label with `preferredFont(forTextStyle:)` and no `adjustsFontForContentSizeCategory` | Set it to `true` |
| A Live Activity's main text in `.body`, or in a weight below `.medium` | `.headline`, or `.weight(.medium)` and heavier |
| A countdown driven by a `Timer`, or by a timeline entry each second | `Text(timerInterval:countsDown:)` |

## Reporting

**Severity.** `HIGH` makes text unreadable, as text below 11pt or a light weight at body size does. Body or control text that does not scale with Dynamic Type is one of `design-review`'s escalation triggers, so it is `HIGH` on sight. Truncated content with no way to the full value is `layout`'s trigger, and this skill reports the line limit that causes it. `MEDIUM` breaks the type system: a broken heading order, a custom font that ignores Bold Text, added tracking or one role set two ways. `LOW` is isolated polish.

**Verification.** Without Xcode, read every `.font`, `Font.custom`, weight, tracking, leading, line limit and alignment in scope against the rules above. Check each custom font name against `UIAppFonts` and the bundled files. A PostScript name needs Font Book on a Mac to confirm. With Xcode, preview each screen at the xSmall, Large and xxxLarge sizes and at AX1 and AX5, and turn on Bold Text through Environment Overrides. Run once in the right-to-left pseudolanguage with real content. Report every check you could not run as `Not verified`.

**Format.** Group findings under the principle each violates, ordered by severity, one row per root cause listing every location it appears in:

| Severity | Location | Before | After | Why |
| --- | --- | --- | --- | --- |

`Location` is `path/to/file.swift:line`. `Why` names the principle and the user impact.

End with `Block` when any `HIGH` remains, `Approve` otherwise, leaving the rest in the table as work to do. Never `Approve` coverage you did not inspect. With nothing to report, state "No actionable typography findings" and report verification.
