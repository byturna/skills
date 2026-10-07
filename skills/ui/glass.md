# Glass and materials

Which layer a surface belongs to, the bars and toolbars the system draws, custom glass and the materials of the content layer.

## Which layer

| Surface | Layer | Takes |
| --- | --- | --- |
| Navigation bar, toolbar, tab bar, sidebar | Functional | The system's glass, with no background of yours |
| Sheet, popover, menu, alert, action sheet | Functional | The system's glass |
| A control floating over content, such as a map's buttons | Functional | `.buttonStyle(.glass)`, or `.glassEffect` |
| A custom bar pinned over scrolling content | Functional | `.safeAreaBar` |
| A card, a row, a list, a screen background | Content | A background level |
| A region of content over an image or a map | Content | A standard material |
| A slider or toggle knob | Content | Glass while dragged, drawn by the system |

## Bars and scroll edges

```swift
// Bad: a color laid over the navigation bar's glass
NavigationStack {
    InboxList()
        .toolbarBackground(Color.indigo, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
}
```

Delete both modifiers. The same goes for `.presentationBackground` on a sheet or popover, and for a visual effect view added to a popover's content.

`.safeAreaBar` insets the safe area as `.safeAreaInset` does:

```swift
// Good: the bar gets the scroll edge effect
ScrollView {
    ArticleBody()
}
.safeAreaBar(edge: .bottom) {
    ReplyBar()
}

// Bad: a hand-built bar with its own background and divider
ScrollView {
    ArticleBody()
}
.safeAreaInset(edge: .bottom) {
    VStack(spacing: 0) {
        Divider()
        ReplyBar()
            .background(.bar)
    }
}
```

Keep the scroll edge effect's automatic style unless the design names one. `.scrollEdgeEffectStyle(.hard, for: .top)` draws a nearly opaque boundary, and `.soft` a subtle blur.

On iPad, a hero image beside a sidebar or inspector takes `.backgroundExtensionEffect()`. It mirrors and blurs the image's edge beneath the sidebar, so no content has to scroll under the glass:

```swift
ProductHero(product: product)
    .backgroundExtensionEffect()
```

## Toolbars

Two groups and an item that appears only when it applies:

```swift
.toolbar {
    ToolbarItemGroup(placement: .topBarTrailing) {
        Button("Undo", systemImage: "arrow.uturn.backward", action: undo)
        Button("Redo", systemImage: "arrow.uturn.forward", action: redo)
    }
    ToolbarSpacer(.fixed, placement: .topBarTrailing)
    if canShare {
        ToolbarItem(placement: .topBarTrailing) {
            ShareLink(item: documentURL)
        }
    }
}
```

```swift
// Bad: the share link disappears but its item stays
ToolbarItem(placement: .topBarTrailing) {
    ShareLink(item: documentURL)
        .opacity(canShare ? 1 : 0)
}
```

An item that must stand without glass, such as an avatar, takes `.sharedBackgroundVisibility(.hidden)`.

## Custom glass

A button takes a glass style:

```swift
Button("Add Stop", systemImage: "plus", action: addStop)
    .buttonStyle(.glass)
```

`.glassEffect()` defaults to the regular variant in a capsule, and a larger element takes a rounded rectangle:

```swift
RouteSummary(route: route)
    .padding()
    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 20))
```

Where glass shapes must morph into one another, each takes `.glassEffect` and an ID inside one `GlassEffectContainer`:

```swift
struct MapControls: View {
    @Namespace private var namespace
    @State private var isExpanded = false
    let centerOnUser: () -> Void

    var body: some View {
        GlassEffectContainer(spacing: 12) {
            VStack(spacing: 12) {
                Button {
                    withAnimation(.smooth) { isExpanded.toggle() }
                } label: {
                    Label("Map Options", systemImage: "square.3.layers.3d")
                        .labelStyle(.iconOnly)
                        .frame(width: 44, height: 44)
                }
                .glassEffect(.regular.interactive(), in: .circle)
                .glassEffectID("options", in: namespace)

                if isExpanded {
                    Button(action: centerOnUser) {
                        Label("Current Location", systemImage: "location")
                            .labelStyle(.iconOnly)
                            .frame(width: 44, height: 44)
                    }
                    .glassEffect(.regular.interactive(), in: .circle)
                    .glassEffectID("location", in: namespace)
                }
            }
        }
    }
}
```

- The container's `spacing` sets how close two shapes come before they blend. A value larger than the stack's spacing merges them at rest.
- Shapes within that spacing morph by default. Ones farther apart take `.glassEffectTransition(.materialize)`.
- `.glassEffectUnion(id:namespace:)` merges views that are not neighbors in a stack into one shape.
- Every effect outside a container renders on its own, so many of them cost performance.

## Clear glass

Over bright media:

```swift
PlaybackControls()
    .padding()
    .glassEffect(.clear, in: .capsule)
    .background(.black.opacity(0.35), in: .capsule)
```

Over dark media, or with AVKit's standard playback controls, leave the dimming out.

## Materials

```swift
// Good: a caption over a photo, on a material in the content layer
PhotoView(photo: photo)
    .overlay(alignment: .bottomLeading) {
        Text(photo.caption)
            .padding(8)
            .background(.thinMaterial, in: .rect(cornerRadius: 8))
            .padding(8)
    }

// Bad: glass in the content layer
PhotoView(photo: photo)
    .overlay(alignment: .bottomLeading) {
        Text(photo.caption)
            .padding(8)
            .glassEffect(in: .rect(cornerRadius: 8))
            .padding(8)
    }
```
