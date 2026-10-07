# Palettes

Custom colors: color sets and their variants, roles, ramps, meaning, gamut and gradients.

## Color sets

A color set's `Contents.json` holds one entry per variant. A complete set has four:

```json
{
  "colors" : [
    {
      "color" : { "color-space" : "srgb", "components" : { "red" : "0.000", "green" : "0.478", "blue" : "0.478", "alpha" : "1.000" } },
      "idiom" : "universal"
    },
    {
      "appearances" : [ { "appearance" : "luminosity", "value" : "dark" } ],
      "color" : { "color-space" : "srgb", "components" : { "red" : "0.243", "green" : "0.784", "blue" : "0.784", "alpha" : "1.000" } },
      "idiom" : "universal"
    },
    {
      "appearances" : [ { "appearance" : "contrast", "value" : "high" } ],
      "color" : { "color-space" : "srgb", "components" : { "red" : "0.000", "green" : "0.361", "blue" : "0.361", "alpha" : "1.000" } },
      "idiom" : "universal"
    },
    {
      "appearances" : [ { "appearance" : "luminosity", "value" : "dark" }, { "appearance" : "contrast", "value" : "high" } ],
      "color" : { "color-space" : "srgb", "components" : { "red" : "0.420", "green" : "0.882", "blue" : "0.882", "alpha" : "1.000" } },
      "idiom" : "universal"
    }
  ],
  "info" : { "author" : "xcode", "version" : 1 }
}
```

In Xcode, set the color set's Appearances to Any, Dark and check High Contrast. The high-contrast value moves away from its usual background in each appearance, so it is darker in light and lighter in dark.

```swift
// Good: a role color from the asset catalog, with every variant
CategoryBadge(category: category)
    .background(Color(.categoryTravel), in: .capsule)

// Bad: one color branched by hand, with no high-contrast value
struct CategoryBadgeBackground: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Capsule()
            .fill(colorScheme == .dark
                ? Color(red: 0.243, green: 0.784, blue: 0.784)
                : Color(red: 0, green: 0.478, blue: 0.478))
    }
}
```

Where a color must be computed in UIKit, `UIColor(dynamicProvider:)` reads the trait collection's `userInterfaceStyle` and `accessibilityContrast`, and covers all four cases.

## Roles

An asset catalog cannot point one color set at another, so the two tiers sit in different places:

| Tier | Lives in | Named for | Referenced by views |
| --- | --- | --- | --- |
| Palette | The design source, or a `Palette` folder of fixed color sets | Hue and step, as `teal600` | Never |
| Role | A color set with four variants, filled from the palette | Its job, as `categoryTravel` or `accentFill` | Always |

Name roles in lower camel case and by one grammar, so a reader can guess the next name. Separator and border are separate roles even while they share a value. Where the brand color needs a name of its own, call it `accent` or `brand`, never `primary`.

## Ramps

A finished ramp also shows these, checkable in any tool that reads OKLCH:

- Lightness changes steadily in OKLCH `L`. HSL lightness is not perceptual, so an HSL ramp bunches at one end.
- Light-end steps sit about `0.04`–`0.05` of `L` apart, and mid-ramp steps `0.07`–`0.10`.
- No two neighbors sit less than `0.03` of `L` apart.
- Neither end reaches pure black or white.

Compute the ramp with a color library at design time, such as culori or colorjs.io, then store each step's components. A brand color meant for filled buttons sits on the solid-fill step. Where white text on it fails its threshold, it stays the brand color and a darker step fills controls. Never darken the brand quietly.

Several ramps agree step for step. The same step reads equally bright across hues, and each hue takes the same share of its own maximum vividness, since hues do not share one.

## Meaning

Red reads as danger, orange as warning and green as success, so status colors start there. A destructive action that cannot move away from the brand's hue takes a symbol beside its label. In a finance app, gains and losses are roles chosen per locale.

## Gamut and gradients

| Need | Use |
| --- | --- |
| A color from a design tool | Its sRGB components, as given |
| A color designed for wide-color displays | Display P3 components in the color set |
| Two P3 colors that must stay distinct | A separate sRGB value for each in the color set, checked on an sRGB display |
| A color derived from two others | `Color.mix(with:by:in:)` |
| A gradient with an even transition | `.colorSpace(.perceptual)` on the gradient |

```swift
let hover = Color(.accentFill).mix(with: .black, by: 0.1)

Rectangle()
    .fill(Gradient(colors: [.blue, .pink]).colorSpace(.perceptual))
```

A gradient between two hues on opposite sides of the wheel turns gray in the middle. Add a stop between them rather than changing the color space.
