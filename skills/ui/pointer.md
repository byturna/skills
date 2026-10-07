# Pointer

Hover effects on iPad, hit regions and the rule that nothing waits for hover.

## Effects

| Element | Effect | SwiftUI |
| --- | --- | --- |
| Small, on a transparent background, such as a bar button | Highlight | `.hoverEffect(.highlight)` |
| Small and opaque, such as a tile | Lift | `.hoverEffect(.lift)` |
| Large, such as a card or a row | A background change, scaled only where it has room | `.onHover(perform:)` |

```swift
Button(action: showMore) {
    Label("More", systemImage: "ellipsis")
        .labelStyle(.iconOnly)
        .frame(width: 44, height: 44)
}
.hoverEffect(.highlight)

AlbumTile(album: album)
    .contentShape(.hoverEffect, .rect(cornerRadius: 12))
    .hoverEffect(.lift)
```

The lift effect morphs the pointer into the element's shape, so a tile whose corners differ from the system's declares them with `.contentShape(.hoverEffect, _:)`.

A row changes tone:

```swift
struct OrderRow: View {
    let order: Order
    @State private var isHovered = false

    var body: some View {
        OrderSummary(order: order)
            .padding()
            .background(isHovered ? Color(.quaternarySystemFill) : Color.clear, in: .rect(cornerRadius: 12))
            .onHover { isHovered = $0 }
    }
}
```

Never add a shadow without scale, because an element that does not grow does not read as closer. Use `.onContinuousHover` only for content that reads the pointer's position, such as a value shown under the pointer on a chart. Never add a purely decorative pointer effect.

## Hit regions

Pad an element's hit region by about 12pt around a bezel, and about 24pt around an element with none. Adjacent custom bar buttons keep their hit regions touching, so the pointer does not snap back to a circle between them. The touch target minimums belong to `accessibility`.

## Hover never gates

```swift
// Bad: the actions appear only under the pointer
MessageRow(message: message)
    .overlay(alignment: .trailing) {
        if isHovered {
            RowActions(message: message)
        }
    }
    .onHover { isHovered = $0 }

// Good: the same actions reach touch through swipe actions and the context menu
MessageRow(message: message)
    .swipeActions {
        RowActions(message: message)
    }
    .contextMenu {
        RowActions(message: message)
    }
```

Hover may still reveal the actions as a shortcut once touch reaches them another way. The same goes for controls that fade out, such as playback controls: the pointer can reveal them, and so can a tap.
