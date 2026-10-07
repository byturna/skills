# Custom fonts

Registering a font, mapping its roles onto text styles, Bold Text, line height and the dimensions that scale with text.

## Registering

1. Add the font files to the app target.
2. List each file's path under `UIAppFonts` in `Info.plist`:

```xml
<key>UIAppFonts</key>
<array>
    <string>Fonts/BrandSans-Regular.otf</string>
    <string>Fonts/BrandSans-Semibold.otf</string>
    <string>Fonts/BrandSans-Bold.otf</string>
</array>
```

3. Name each face by its PostScript name, which Font Book shows under Font Info. It often differs from the file name.

A name SwiftUI cannot resolve renders in the system font with no error, so a missing face looks like a design choice. SwiftUI never synthesizes bold or italic, so bundle each weight and style the design uses.

## Roles

Each role maps onto the text style it stands in for, at that style's default size. Define the roles once, and read Bold Text in the same place:

```swift
enum BrandTextStyle {
    case title, headline, body, caption

    var size: CGFloat {
        switch self {
        case .title: 28
        case .headline: 17
        case .body: 17
        case .caption: 12
        }
    }

    var relativeStyle: Font.TextStyle {
        switch self {
        case .title: .title
        case .headline: .headline
        case .body: .body
        case .caption: .caption
        }
    }

    func faceName(isBold: Bool) -> String {
        switch self {
        case .title, .headline: isBold ? "BrandSans-Bold" : "BrandSans-Semibold"
        case .body, .caption: isBold ? "BrandSans-Semibold" : "BrandSans-Regular"
        }
    }
}

struct BrandFont: ViewModifier {
    @Environment(\.legibilityWeight) private var legibilityWeight
    let style: BrandTextStyle

    func body(content: Content) -> some View {
        content.font(.custom(
            style.faceName(isBold: legibilityWeight == .bold),
            size: style.size,
            relativeTo: style.relativeStyle
        ))
    }
}

extension View {
    func brandFont(_ style: BrandTextStyle) -> some View {
        modifier(BrandFont(style: style))
    }
}
```

```swift
// Good: one role, scaled like the style it stands in for
Text(order.title)
    .brandFont(.title)

// Bad: scales with body, so the title grows at body's rate and outgrows .title at accessibility sizes
Text(order.title)
    .font(.custom("BrandSans-Semibold", size: 28))
```

`Font.custom(_:size:)` without `relativeTo:` scales with `.body`. `Font.custom(_:fixedSize:)` never scales, and suits only text that must not grow, such as a logotype.

A face whose x-height runs small or large may need a different size from the system style's. Set it once in the role, judged on screen next to the system font.

## Bold Text

`legibilityWeight` is `.bold` while Bold Text is on. The role above moves each face one step heavier. A family with no heavier face moves to the heaviest it has.

## Line height

A custom font brings its own line metrics, which may not suit the design. Where they do not, set the line height on the text rather than adding spacing:

```swift
Text(chapter.text)
    .brandFont(.body)
    .lineHeight(.loose)
```

`.lineHeight` takes `.tight`, `.normal` and `.loose`, or `.multiple(factor:)` for the value a type design specifies. It scales with the font size, so it holds across Dynamic Type sizes.

## Scaled dimensions

```swift
struct AttachmentRow: View {
    @ScaledMetric(relativeTo: .body) private var thumbnailSize: CGFloat = 28
    let attachment: Attachment

    var body: some View {
        HStack {
            AttachmentThumbnail(attachment: attachment)
                .frame(width: thumbnailSize, height: thumbnailSize)
            Text(attachment.name)
        }
    }
}
```

Scale relative to the style of the text the dimension sits with. Spacing between sections belongs to `layout`.
