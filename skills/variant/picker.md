# The picker

The control that switches variants and the code that hosts them. It sits over the thing being judged, so build it as specified and leave it alone.

## Deliberately outside the design system

Never style the picker with the project's colors, fonts, tint or glass. A picker that looks native becomes part of what you are looking at, and one in Liquid Glass reads as the app's own control.

It is one dark capsule with white text in the system font, and it stays dark in both appearances.

## Behavior

- Tapping a name selects that variant. The choice lives in `@AppStorage("__variant")`, so it survives a relaunch.
- Switching is instant, with no animation, and keeps the scroll position.
- The chevron collapses the picker to the current name, for screenshots and recordings. Tapping the name brings it back.
- The selected name carries the selected trait for VoiceOver, and the picker reads as one labeled group.
- Where the names do not fit the width, the row scrolls sideways.
- Its strings are plain `String` values, never localized keys, so the picker adds nothing to the String Catalog.
- It sits at the bottom of the hosting screen's safe area, above a tab bar or toolbar. Where the piece itself sits there, move the picker to the top and say so.

## The picker

```swift
#if DEBUG
struct VariantPicker<Variant>: View
where Variant: CaseIterable & Hashable & RawRepresentable, Variant.RawValue == String {
    @Binding var selection: Variant
    @State private var isCollapsed = false
    private let hideTitle = "Hide Variants"

    var body: some View {
        Group {
            if isCollapsed {
                Button(selection.rawValue.capitalized, systemImage: "chevron.up") {
                    isCollapsed = false
                }
                .buttonStyle(VariantPickerButtonStyle(isSelected: true))
            } else {
                HStack(spacing: 2) {
                    ViewThatFits(in: .horizontal) {
                        names
                        ScrollView(.horizontal) { names }
                            .scrollIndicators(.hidden)
                    }
                    Button(hideTitle, systemImage: "chevron.down") {
                        isCollapsed = true
                    }
                    .labelStyle(.iconOnly)
                    .buttonStyle(VariantPickerButtonStyle(isSelected: false))
                }
            }
        }
        .padding(4)
        .background(Color.black.opacity(0.88), in: .capsule)
        .font(.footnote.weight(.medium))
        .environment(\.colorScheme, .dark)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(Text(verbatim: "Variants"))
        .padding(.horizontal)
    }

    private var names: some View {
        HStack(spacing: 2) {
            ForEach(Array(Variant.allCases), id: \.self) { variant in
                Button(variant.rawValue.capitalized) {
                    selection = variant
                }
                .buttonStyle(VariantPickerButtonStyle(isSelected: variant == selection))
                .accessibilityAddTraits(variant == selection ? .isSelected : [])
            }
        }
    }
}

private struct VariantPickerButtonStyle: ButtonStyle {
    let isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .foregroundStyle(.white.opacity(isSelected || configuration.isPressed ? 1 : 0.6))
            .background(.white.opacity(isSelected ? 0.14 : 0), in: .capsule)
            .contentShape(.capsule)
    }
}
#endif
```

## Hosting the variants

The variants are cases of one enum, and the hosting screen switches on the stored choice. Release builds keep the screen's current view, or nothing where the piece is new:

```swift
#if DEBUG
enum ActivityCardVariant: String, CaseIterable {
    case quiet, editorial, dense
}
#endif

struct ActivityScreen: View {
    let activity: Activity

    #if DEBUG
    @AppStorage("__variant") private var variant = ActivityCardVariant.quiet
    #endif

    var body: some View {
        ScrollView {
            #if DEBUG
            switch variant {
            case .quiet:
                QuietActivityCard(activity: activity)
            case .editorial:
                EditorialActivityCard(activity: activity)
            case .dense:
                DenseActivityCard(activity: activity)
            }
            #else
            ActivityCard(activity: activity)
            #endif
        }
        .navigationTitle("Activity")
        #if DEBUG
        .overlay(alignment: .bottom) {
            VariantPicker(selection: $variant)
        }
        #endif
    }
}
```

Keep the variant views, their previews and the enum in one folder named for the piece, such as `Variants/ActivityCard/`, so removal is one delete plus the hosting lines.
