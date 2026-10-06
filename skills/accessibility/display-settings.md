# Display settings

What each display setting requires of a screen. Larger Text, Sufficient Contrast, Dark Interface and Differentiate Without Color Alone are App Store accessibility labels; their criteria are what this file states.

## Larger Text

Body text and primary content scale to the largest accessibility size, AX5, which takes body text past 300% of the default. Check at the small, medium, large and extra large accessibility sizes, not only at the end.

At every size:

- Nothing overlaps and nothing clips.
- Text wraps rather than truncating to the point of ambiguity. A list row may truncate to a line or two when a detail view shows the full text.
- The hierarchy survives: headings stay larger than the text below them.
- Side-by-side elements stack when they no longer fit. How is `layout`'s.

Repeated, predictable chrome may stay small, such as the Back button, the tab bar and toolbar items. Give each of them the Large Content Viewer, so a long press shows an enlarged copy:

```swift
Button("Settings", systemImage: "gear", action: openSettings)
    .labelStyle(.iconOnly)
    .accessibilityShowsLargeContentViewer()
```

System bars already do this. Cap the size range only on such chrome, never on content:

```swift
CustomTabBar(selection: $tab)
    .dynamicTypeSize(...DynamicTypeSize.accessibility1)
    .accessibilityShowsLargeContentViewer()
```

Zoom and Hover Text are system features available whatever the app does, so they never count as support. Text styles and custom font scaling are `typography`'s.

## Bold Text

Text styles and SF Pro respond to Bold Text on their own. A custom font must too, through `legibilityWeight`, which `typography` owns. Custom symbols and strokes drawn beside text should follow the text's weight.

## Increase Contrast

Semantic colors and system controls switch to higher-contrast variants on their own. Custom colors need a High Contrast variant in the asset catalog, read through `colorSchemeContrast`. The variants are `color`'s.

A pair that fails the contrast table by default passes only if Increase Contrast brings it up to the table. Test with Increase Contrast in both appearances.

## Reduce Transparency

System materials and Liquid Glass become more opaque on their own. Custom translucency, such as a color at reduced opacity behind text, checks `accessibilityReduceTransparency` and goes opaque:

```swift
@Environment(\.accessibilityReduceTransparency) private var reduceTransparency

Text(caption)
    .padding()
    .background(.black.opacity(reduceTransparency ? 1 : 0.6))
```

Check text on any translucent surface twice: with Reduce Transparency on and with it off. Surfaces are `ui`'s.

## Smart Invert

Smart Invert inverts the interface colors but should leave media alone. Photos, video, maps, avatars and illustrations take `.accessibilityIgnoresInvertColors()`. Check that no semantic color flips meaning under inversion, such as a red Delete turning green.

## Button Shapes

System button styles draw a shape when Button Shapes is on. A custom `ButtonStyle` whose label is plain text reads `accessibilityShowButtonShapes` and adds an underline or a background shape.

## Differentiate Without Color Alone

Color may carry meaning only alongside a second cue: a symbol, a shape, text or a position.

```swift
// Good: the symbol and the word carry the status, the color reinforces it
Label(status.title, systemImage: status.symbolName)
    .foregroundStyle(status.color)

// Bad: a dot whose color is the only difference between states
Circle()
    .fill(isOnline ? .green : .red)
    .frame(width: 8, height: 8)
```

Charts label their series directly or order the colors to match the legend. Where color is the only differentiator, as in a team color in a game, offer a choice of color schemes. `accessibilityDifferentiateWithoutColor` may add further cues; it never replaces the default ones. Test the screen with the Grayscale color filter.

## Dark interface

A screen that supports dark mode stays dark for every common task. A white flash between screens, a white web view or a bright default background counts against it. Contrast holds in dark mode too, and gray-on-black reading text is a common failure.
