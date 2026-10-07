# Symbols

The standard symbols for common actions, size and weight, variants, rendering modes, custom symbols, optical alignment and right-to-left.

## Standard symbols

The HIG names these symbols for common actions. Use them, so the same action looks the same as in every other app.

| Action | Symbol |
| --- | --- |
| Cut | `scissors` |
| Copy | `document.on.document` |
| Paste | `document.on.clipboard` |
| Done, Save | `checkmark` |
| Cancel, Close, Deselect | `xmark` |
| Delete | `trash` |
| Undo | `arrow.uturn.backward` |
| Redo | `arrow.uturn.forward` |
| Compose | `square.and.pencil` |
| Duplicate | `plus.square.on.square` |
| Rename | `pencil` |
| Move to, Folder | `folder` |
| Attach | `paperclip` |
| Add | `plus` |
| More | `ellipsis` |
| Select | `checkmark.circle` |
| Search | `magnifyingglass` |
| Find, Find and Replace | `text.page.badge.magnifyingglass` |
| Filter | `line.3.horizontal.decrease` |
| Share, Export | `square.and.arrow.up` |
| Print | `printer` |
| Account, User, Profile | `person.crop.circle` |
| Like | `hand.thumbsup` |
| Dislike | `hand.thumbsdown` |
| Bold, Italic, Underline | `bold`, `italic`, `underline` |
| Align left, center, justify, align right | `text.alignleft`, `text.aligncenter`, `text.justify`, `text.alignright` |
| Superscript, Subscript | `textformat.superscript`, `textformat.subscript` |
| Bring to Front, Send to Back | `square.3.layers.3d.top.filled`, `square.3.layers.3d.bottom.filled` |
| Bring Forward, Send Backward | `square.2.layers.3d.top.filled`, `square.2.layers.3d.bottom.filled` |
| Alarm | `alarm` |
| Archive | `archivebox` |
| Calendar | `calendar` |

## Size and weight

```swift
// Good: the symbol takes the label's size and weight
Label("Downloads", systemImage: "arrow.down.circle")
    .font(.headline)

// Good: a smaller symbol that still matches the text's weight
Label("Verified", systemImage: "checkmark.seal.fill")
    .imageScale(.small)

// Bad: a fixed frame breaks the weight, baseline and Dynamic Type match
HStack {
    Image(systemName: "checkmark.seal.fill")
        .resizable()
        .frame(width: 14, height: 14)
    Text("Verified")
}
```

`.imageScale` takes `.small`, `.medium` or `.large`, each set against the font's cap height, and `.medium` is the default. `.fontWeight` sets the symbol's weight with the text's, across the nine weights of San Francisco.

## Variants

```swift
// Good: outline names; the tab bar draws the fill
TabView {
    Tab("Library", systemImage: "books.vertical") {
        LibraryView()
    }
    Tab("Browse", systemImage: "square.grid.2x2") {
        BrowseView()
    }
}

// Good: a custom selected state through the variant
Toggle(isOn: $isBookmarked) {
    Label("Bookmark", systemImage: "bookmark")
        .symbolVariant(isBookmarked ? .fill : .none)
}
.toggleStyle(.button)
```

| Variant | Use |
| --- | --- |
| Outline | Toolbars, lists and beside text |
| `.fill` | A selected state in a custom control |
| `.slash` | An action or item that is unavailable |
| `.circle`, `.square` | A symbol that must stay legible at a small size |

A symbol with no such variant ignores the modifier. Set `\.symbolVariants` to `.none` in the environment to stop one symbol inheriting a variant.

## Rendering modes

| Mode | Use | SwiftUI |
| --- | --- | --- |
| Monochrome | The default | `.symbolRenderingMode(.monochrome)` |
| Hierarchical | Depth in one color | `.symbolRenderingMode(.hierarchical)` |
| Palette | The two or three colors a design names | `.symbolRenderingMode(.palette)` with `.foregroundStyle(_:_:)` |
| Multicolor | A symbol's own colors that carry meaning | `.symbolRenderingMode(.multicolor)` |
| Variable value | A quantity from `0` to `1` | `Image(systemName:variableValue:)` |
| Draw | A variable value shown as a drawn length | `.symbolVariableValueMode(.draw)` |
| Gradient | A gradient from one color, best at large sizes | `.symbolColorRenderingMode(.gradient)` |

```swift
Image(systemName: "cloud.sun.rain.fill")
    .symbolRenderingMode(.hierarchical)
    .foregroundStyle(.tint)

Image(systemName: "speaker.wave.3", variableValue: volume)
```

Which colors fill a palette or a tint belongs to `color`.

## Custom symbols

1. In the SF Symbols app, duplicate the closest symbol as a custom symbol, then export its template.
2. Draw in a vector app with flat filled paths. Convert strokes to paths, and add no effects and no hidden paths.
3. Import the file back into SF Symbols to validate it. Annotate its layers for the rendering modes and animations it should support.
4. Add the exported symbol to the asset catalog and load it with `Image("symbol.name")`.

Take badges and enclosures from the SF Symbols app's component library rather than drawing them in. A badge that widens the symbol gets negative side margins, so a column of symbols still aligns. Never customize or imitate a symbol that depicts an Apple product.

An icon that cannot be a symbol is a vector PDF or SVG in the asset catalog, drawn with `.renderingMode(.template)`. It then takes its color from `.foregroundStyle` like a symbol.

## Optical alignment

```swift
// Good: the enclosed variant is drawn as one symbol
Image(systemName: "play.circle.fill")
    .font(.largeTitle)

// Bad: a glyph centered by geometry in a circle of your own
Image(systemName: "play.fill")
    .padding()
    .background(.tint, in: .circle)
```

The HIG's example of an icon that needs padding is a download arrow, heavy at the bottom. Only where the asset cannot change does an `.offset` of a point or two stand in.

## Right to left

| Flip | Never flip |
| --- | --- |
| An icon that depicts text, such as left-aligned lines | Logos, even with text in them |
| An icon that shows forward or backward motion | The checkmark and other universal marks |
| An icon with sound waves leaving a speaker | Real-world objects such as a clock |
| | A right-handed tool such as a pen |
| | Photos, illustrations and artwork |

A custom icon that flips says so once:

```swift
Image("reply.arrow")
    .flipsForRightToLeftLayoutDirection(true)
```

Use one mechanism per icon, since two flips cancel out. In a composite icon, a slash or a badge that changes the meaning may keep its place while the base flips. A badge that shows a part of the interface flips with it.
