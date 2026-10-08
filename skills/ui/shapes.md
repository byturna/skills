# Shapes and elevation

Concentric corners, the shapes of system controls, elevation through background levels and image outlines.

## Concentric corners

The card declares its shape, and the artwork inside follows it:

```swift
struct AlbumCard: View {
    let album: Album

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AlbumArtwork(album: album)
                .clipShape(ConcentricRectangle(corners: .concentric(minimum: 8)))
            Text(album.title)
                .font(.headline)
                .padding(.horizontal, 8)
        }
        .padding(8)
        .background(Color(.secondarySystemGroupedBackground), in: .rect(cornerRadius: 24))
        .containerShape(.rect(cornerRadius: 24))
    }
}
```

The artwork's top corners sit 8pt inside the card's, so they resolve to 16pt. Its bottom corners sit far from the card's and would resolve to square, so the minimum holds them at 8pt.

```swift
// Bad: the inner corners repeat the card's radius and bulge against it
AlbumArtwork(album: album)
    .clipShape(.rect(cornerRadius: 24))
```

| Corner | Style |
| --- | --- |
| Concentric with the container | `.concentric` |
| Concentric, never below a radius | `.concentric(minimum:)` |
| A fixed radius | `.fixed(_:)` |

Corners can differ. `ConcentricRectangle(uniformTopCorners: .fixed(24), uniformBottomCorners: .concentric)` keeps a fixed top and follows the container at the bottom. With `isUniform: true`, every corner takes the largest radius computed.

`ConcentricRectangle` is a `Shape` but not an `InsettableShape`. It works with `.clipShape` and `.fill`, but not with `.background(_:in:)` or `.strokeBorder`.

## Control shapes

```swift
// Good: the system sizes and shapes the control
Button("Continue", action: advance)
    .buttonStyle(.borderedProminent)
    .controlSize(.large)

// Bad: hard-coded metrics that miss the system's shape, press and hover
Button("Continue", action: advance)
    .frame(maxWidth: .infinity, minHeight: 50)
    .background(Color.accentColor)
    .foregroundStyle(.white)
    .clipShape(.rect(cornerRadius: 12))
```

| Need | Use |
| --- | --- |
| Size | `.controlSize(.mini)` through `.extraLarge` |
| Shape of a bordered button | `.buttonBorderShape(.capsule)`, `.roundedRectangle` or `.circle` |
| Primary action in content | `.borderedProminent` |
| Primary action in the glass layer | `.glassProminent` |

Clip with `.clipShape(.rect(cornerRadius:))`, since Apple's documentation marks `.cornerRadius(_:)` deprecated.

## Elevation

Each level separates from the one beneath it in both appearances:

| Surface | Grouped screen | Plain screen |
| --- | --- | --- |
| The screen | `systemGroupedBackground` | `systemBackground` |
| A card or grouped row on it | `secondarySystemGroupedBackground` | `secondarySystemBackground` |
| Content inside that card | `tertiarySystemGroupedBackground` | `tertiarySystemBackground` |

A custom card draws them itself:

```swift
// Good: the background levels separate the card
ScrollView {
    VStack(spacing: 16) {
        ForEach(orders) { order in
            OrderSummary(order: order)
                .padding()
                .background(Color(.secondarySystemGroupedBackground), in: .rect(cornerRadius: 16))
        }
    }
    .padding()
}
.background(Color(.systemGroupedBackground))

// Bad: a shadow and a border standing in for the levels
OrderSummary(order: order)
    .padding()
    .background(Color(.systemBackground), in: .rect(cornerRadius: 16))
    .shadow(radius: 8)
    .overlay {
        RoundedRectangle(cornerRadius: 16)
            .stroke(Color.gray.opacity(0.2))
    }
```

A shadow stays for something that floats over arbitrary content and is neither glass nor a sheet, with one definition for the project.

## Image outlines

```swift
AsyncImage(url: album.coverURL) { image in
    image
        .resizable()
        .scaledToFill()
} placeholder: {
    Color(.secondarySystemFill)
}
.frame(width: 64, height: 64)
.clipShape(.rect(cornerRadius: 8))
.overlay {
    RoundedRectangle(cornerRadius: 8)
        .strokeBorder(Color.primary.opacity(0.1), lineWidth: 1)
}
```

`.strokeBorder` draws inside the shape, so the image keeps its size. The overlay's shape matches the clip's radius.

## Widgets and Live Activities

The badge follows the widget's corner, and the background leaves when the system removes it:

```swift
struct TransitWidgetView: View {
    let entry: TransitEntry

    var body: some View {
        VStack(alignment: .leading) {
            Text("Next train")
                .font(.caption)
                .unredacted()
            Text(entry.line)
                .font(.headline)
            Spacer()
            Text(entry.departure, style: .relative)
                .font(.title2.bold())
                .monospacedDigit()
                .frame(maxWidth: .infinity)
                .padding()
                .background(.quaternary, in: ContainerRelativeShape())
        }
        .containerBackground(for: .widget) {
            Color(.transitBackground)
        }
    }
}
```

A circular Lock Screen widget sits on the system's backdrop:

```swift
ZStack {
    AccessoryWidgetBackground()
    Image(systemName: "tram")
}
```
