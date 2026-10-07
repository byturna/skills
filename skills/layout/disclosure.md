# Disclosure

Cues for content past an edge, collapsed sections and the way to a truncated value.

## Peeking rows

```swift
// The content margins leave the next card visible past the edge
ScrollView(.horizontal) {
    LazyHStack(spacing: 12) {
        ForEach(collections) { collection in
            CollectionCard(collection: collection)
                .containerRelativeFrame(.horizontal)
        }
    }
    .scrollTargetLayout()
}
.contentMargins(.horizontal, 24, for: .scrollContent)
.scrollTargetBehavior(.viewAligned)
```

Each card takes the scroll view's width less its margins, so the next one shows by the margin less the spacing. `.viewAligned` settles each swipe on a card's leading edge. A row that ends exactly at the screen's edge looks complete, and nobody scrolls it.

Where the length of a scrolling area is not obvious, `.scrollIndicatorsFlash(onAppear: true)` shows its indicator once.

## Collapsed sections

```swift
DisclosureGroup("Advanced Options") {
    Toggle("Keep original files", isOn: $keepsOriginals)
    Toggle("Include hidden items", isOn: $includesHidden)
}
```

The label names what is inside, never a bare "More". The options people use most stay outside it.

## The way to a truncated value

```swift
struct ReviewText: View {
    let text: String
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(text)
                .lineLimit(isExpanded ? nil : 4)
            Button(isExpanded ? "Show Less" : "Show More") {
                isExpanded.toggle()
            }
        }
    }
}
```

A row in a list instead leads to a detail view that shows the full value. The HIG asks that text in a scrolling region truncate only where people can open such a view.
