# Cheat sheet

Every color API this skill names, with its UIKit equivalent. Match whichever the view under review is written in.

## System colors

| Need | SwiftUI | UIKit |
| --- | --- | --- |
| Text levels | `.primary`, `.secondary`, `.tertiary`, `.quaternary` | `UIColor.label`, `.secondaryLabel`, `.tertiaryLabel`, `.quaternaryLabel` |
| Placeholder, link, separator | `.placeholder`, `.link`, `.separator` | `UIColor.placeholderText`, `.link`, `.separator` |
| Backgrounds | `Color(.systemBackground)` and its levels | `UIColor.systemBackground` and its levels |
| Grouped backgrounds | `Color(.systemGroupedBackground)` and its levels | `UIColor.systemGroupedBackground` and its levels |
| Fills | `Color(.systemFill)` through `Color(.quaternarySystemFill)` | `UIColor.systemFill` through `.quaternarySystemFill` |
| Grays | `Color(.systemGray)` through `Color(.systemGray6)` | `UIColor.systemGray` through `.systemGray6` |
| Status | `.red`, `.green` and the other system colors | `UIColor.systemRed`, `.systemGreen` and the rest |
| Accent | The `AccentColor` asset, `.tint(_:)` | The `AccentColor` asset, `tintColor` |

## Custom colors

| Need | SwiftUI | UIKit |
| --- | --- | --- |
| Color set from the asset catalog | `Color(.brandAccent)` | `UIColor(resource: .brandAccent)` |
| Color computed per appearance | A color set | `UIColor(dynamicProvider:)` |
| Current appearance | `@Environment(\.colorScheme)` | `traitCollection.userInterfaceStyle` |
| Increase Contrast | `@Environment(\.colorSchemeContrast)` | `traitCollection.accessibilityContrast` |
| Display P3 components | `Color(.displayP3, red:green:blue:opacity:)` | `UIColor(displayP3Red:green:blue:alpha:)` |
| Mix two colors | `Color.mix(with:by:in:)` | No direct equivalent |
| Perceptual gradient | `.colorSpace(.perceptual)` on a gradient | No direct equivalent |
| Resolve to components | `Color.resolve(in:)` | `UIColor.resolvedColor(with:)` |
| Color picker | `ColorPicker` | `UIColorPickerViewController` |

## On glass and materials

| Need | SwiftUI | UIKit |
| --- | --- | --- |
| Vibrant text on a material | `.foregroundStyle(.secondary)` | `UIVibrancyEffect` with `.secondaryLabel` |
| Tinted glass | `Glass.tint(_:)` | `UIGlassEffect.tintColor` |
| Prominent tinted button | `.buttonStyle(.glassProminent)` | `UIButton.Configuration.prominentGlass()` |
