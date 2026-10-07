# Adaptivity

Size classes and container sizes, structure at accessibility text sizes and room for longer text.

## Size classes

```swift
// Good: the columns come from the space the grid gets
LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))]) {
    ForEach(albums) { album in
        AlbumTile(album: album)
    }
}

// Bad: the device type says nothing about the window's width
let columnCount = UIDevice.current.userInterfaceIdiom == .pad ? 4 : 2
```

```swift
// A row of actions that stacks only when it runs out of width
ViewThatFits(in: .horizontal) {
    HStack(spacing: 12) {
        Button("Share", systemImage: "square.and.arrow.up", action: share)
        Button("Duplicate", systemImage: "plus.square.on.square", action: duplicate)
    }
    VStack(alignment: .leading, spacing: 12) {
        Button("Share", systemImage: "square.and.arrow.up", action: share)
        Button("Duplicate", systemImage: "plus.square.on.square", action: duplicate)
    }
}
```

| Signal | Use for |
| --- | --- |
| `horizontalSizeClass` | Screen-level structure, such as a sidebar or columns |
| `ViewThatFits`, `GridItem(.adaptive(minimum:))` | A component that should change when its content no longer fits |
| `containerRelativeFrame` | A size that is a share of the container |
| `onGeometryChange(for:of:action:)` | A value read from a view's geometry, acted on only when it changes |

A `GeometryReader` takes all the space it is offered, so one wrapped around a whole screen changes how everything inside it sizes. Reach for it last.

## Accessibility sizes

```swift
struct StatRow: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    let title: String
    let value: String

    var body: some View {
        let isStacked = dynamicTypeSize.isAccessibilitySize
        let layout = isStacked
            ? AnyLayout(VStackLayout(alignment: .leading, spacing: 4))
            : AnyLayout(HStackLayout(alignment: .firstTextBaseline))

        layout {
            Text(title)
            if !isStacked {
                Spacer()
            }
            Text(value)
                .foregroundStyle(.secondary)
        }
    }
}
```

`AnyLayout` keeps the children's identity when it switches, so their state survives the change. Inline items such as a timestamp or a glyph beside a title move below it. A grid with fixed columns drops to fewer.

## Growth

```swift
// Good: the label sets the button's width
Button("Save", action: save)
    .buttonStyle(.bordered)

// Bad: a fixed width that a longer language overflows
Button("Save", action: save)
    .frame(width: 80)
```

Test with the scheme's App Language set to the Double-Length and Bounded String pseudolanguages, and with one long real language such as German. A one-word button label is the riskiest string on the screen.

Long-form text in a wide iPad window keeps a readable width. In UIKit, constrain it to `readableContentGuide`. In SwiftUI, cap the text's frame with one `maxWidth` the project defines.
