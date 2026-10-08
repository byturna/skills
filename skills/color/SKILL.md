---
name: color
description: Builds and checks the colors of SwiftUI and UIKit apps, from system semantic colors and the accent to custom palettes, dark and high-contrast variants and measured contrast.
---

# Color

This skill decides which colors an iOS screen uses and checks them. It starts from the system's semantic colors, builds custom colors in the asset catalog with every variant they need and measures rendered contrast pairs.

Whether a pair must pass belongs to `accessibility`, and so does the rule that no meaning rides on color alone. Where glass and materials go and how surfaces show elevation belong to `ui`. The UIKit form of every API here is in [cheat-sheet.md](cheat-sheet.md).

## Measured, not estimated

Never report a contrast value you did not measure, and never estimate a color you could compute. System colors adapt to dark mode, elevated backgrounds, Increase Contrast and vibrancy on their own. The values Apple documents for them are references for design, and they change between releases.

A role used against its meaning, a failing measured pair, a missing variant and a custom color standing in for a system one with no brand reason are findings. Notation, a tinted neutral and a gradient's color space are project choices. Perceived lightness throughout means OKLCH `L`, from `0` to `1`.

## System colors first

Text takes `.primary`, `.secondary`, `.tertiary` or `.quaternary`. Backgrounds take the system or grouped background levels, separators take `.separator` and links take `.link`. Neutral fills and grays come from the system too, unless the brand calls for its own. A status color is a system color such as `.red` or `.green`, which adapts to each appearance. Never hard-code the value of a system color.

Custom colors are for the brand, the accent and the categories a product defines. A brand may also define warm or cool neutrals, as a ramp whose colors carry every variant. A custom neutral still loses the elevated and vibrant behavior of the system's. So text on a material keeps the hierarchical styles, and sheets and popovers get checked in dark mode, where the system lifts its own backgrounds. The role table is in [system-colors.md](system-colors.md).

## Each color in its role

Use a color only for the role it names. Never use `.separator` as a text color or a label color as a background, even where the value looks right today. Where a role has no color, add one rather than borrowing another's. The same holds for the project's own colors.

## The accent is the tint

The app's accent lives in the `AccentColor` asset, and the system applies it to controls and selection. Change it for a part of the app with `.tint(_:)`; `.accentColor(_:)` is deprecated. The tint means interactive, so never set text that does nothing in the tint color. See [system-colors.md](system-colors.md#the-accent).

## One color, one meaning

A color means one thing across the app. Treat hues within about 15° of each other in OKLCH as one color, so a status color never sits next to the accent. Where a convention leaves no room to move, give the destructive action a distinct treatment as well. Check that each meaning holds in every locale shipped, since red marks gains in some markets. See [palettes.md](palettes.md#meaning).

## Every custom color is a color set with four variants

A custom color is a color set in the asset catalog. It holds a light and a dark value, and a high-contrast value for each. Provide both appearances even in an app that ships in one, since Liquid Glass adapts between them.

Reference it through its generated symbol, `Color(.brandAccent)`, rather than the string `Color("BrandAccent")`, which fails only at run time. Never choose a color with `colorScheme == .dark ?` in a view. See [palettes.md](palettes.md#color-sets).

## Views reference roles, never the palette

A ramp step is a palette value. A role names a job, such as a category badge's fill. Each role is its own color set, filled from the ramp, and views reference only roles. Never name a brand color `primary`, which collides with `.primary`, the label style; name it `accent` or `brand`. See [palettes.md](palettes.md#roles).

## Ramps are computed, never picked

A custom ramp holds one hue end to end, peaks in vividness mid-ramp and steps more finely at the light end. Compute it in OKLCH with a color library at design time, then store the components. A dark variant is never the light ramp reversed: lower its vividness, widen its dark end and remeasure. See [palettes.md](palettes.md#ramps).

## Follow the system appearance

The app follows the appearance people chose for the device by default. An in-app setting for Light, Dark and System is a fine preference when System is its default, applied once with `.preferredColorScheme` at the root. An app built around media may stay dark throughout. iOS's dark base background is pure black, so a dark palette never needs to avoid black.

## Measure the rendered pair

Measure a foreground against the background it actually renders on: the card, the sheet or the glass, not the screen behind. Measure in light and dark, each with Increase Contrast off and on. Report the pair, its measured ratio and the threshold it misses, then leave the colors alone unless asked to change them.

These are the thresholds `accessibility` requires, and the two tables must match:

| Text size | Weight | Minimum |
| --- | --- | --- |
| Up to 17pt | All | 4.5:1 |
| 18pt and up | All | 3:1 |
| All | Bold | 3:1 |
| Controls and state indicators against what they sit on | All | 3:1 |

A fix changes lightness, the channel contrast responds to, and holds the hue. The method and a ratio function are in [contrast.md](contrast.md).

## Color on glass and materials stays vibrant

Text and symbols on a material take the hierarchical styles, `.primary` through `.tertiary`, which keep their vibrancy. A custom `.foregroundStyle` color turns vibrancy off. Avoid `.quaternary` on `.thinMaterial` and `.ultraThinMaterial`, where its contrast is too low.

Liquid Glass is monochrome by default. Color a glass element only for emphasis, by tinting the background of the one primary action, never by coloring its label. Over colorful content, keep bar labels monochrome. See [contrast.md](contrast.md#translucent-surfaces).

## Widgets keep their meaning in every rendering mode

The system draws a widget in one of three modes, which `widgetRenderingMode` reports:

- `.fullColor` on the Home Screen in the light and dark appearances, and in StandBy and CarPlay. Use semantic colors and color sets with both appearances.
- `.accented` in the tinted and clear Home Screen appearances. The system replaces your colors with a tint or with Liquid Glass, so mark the accent group with `.widgetAccentable()`. Images desaturate, and `widgetAccentedRenderingMode(.fullColor)` keeps color only for media such as album art.
- `.vibrant` on the Lock Screen and in StandBy at night. Use opaque grays, never white at an opacity, with white or light gray for the main content.

A status carried only by hue disappears in two of the three modes. StandBy at night also tints the widget red, so check its contrast there. Recipes are in [widgets.md](widgets.md#rendering-modes).

## Live Activities carry the brand in their content

The Dynamic Island's background is always black, so a Live Activity shows its brand through bold colors in its text and symbols. Set `keylineTint(_:)` to that color. On the Lock Screen, `activityBackgroundTint(_:)` takes a color set with both appearances, measured on the Always-On display as well. Check the dismiss button the system generates, and set `activitySystemActionForegroundColor(_:)` where it clashes. See [widgets.md](widgets.md#live-activities).

## Store colors in the space they were designed in

A color set stores sRGB or Display P3 components. A value from a design tool is usually sRGB, so keep it there unless it was designed in P3. Use P3 where the extra saturation carries meaning, and check that neighboring P3 colors stay distinct on an sRGB display. Derived colors come from `Color.mix(with:by:in:)`, never hand-mixed literals. See [palettes.md](palettes.md#gamut-and-gradients).

## Before you finish

| Pattern | Fix |
| --- | --- |
| `Color(red:green:blue:)`, `UIColor(red:green:blue:alpha:)`, `#colorLiteral` or a hex initializer in a view | A role color from the asset catalog, or a system color |
| `Color.black` or `Color.white` for text, or `Color.gray` for secondary text | `.primary`, `.secondary` |
| `.separator` as a text color, or a label color as a background | A color made for that role |
| `colorScheme == .dark ?` choosing a color | A color set with a dark appearance |
| A color set with no dark or high-contrast value | Add the missing variants |
| `Color("…")` where a generated symbol exists | `Color(.name)` |
| A ramp step, such as `teal600`, referenced in a view | A role color filled from it |
| A brand color named `primary` | `accent` or `brand` |
| `.accentColor(_:)` | `.tint(_:)` |
| The tint color on text that does nothing | `.primary` or `.secondary` |
| `.foregroundStyle(someColor)` on text over a material | A hierarchical style |
| `.quaternary` on `.thinMaterial` or `.ultraThinMaterial` | `.tertiary`, or a thicker material |
| Several glass controls tinted on one screen | Tint only the primary action |
| Text on a background with `.opacity` | Measure the composited result, or use a solid color |
| `.preferredColorScheme` with a fixed appearance, or an appearance setting that does not default to System | Follow the system appearance by default |
| White text on a system color fill, unmeasured | Measure it in both appearances |
| A status hue within about 15° of the accent | Move it, or give the action a distinct treatment |
| `UIColor(dynamicProvider:)` rebuilding a system color | The system color |
| A widget with custom colors and no `.widgetAccentable()` | Mark the accent group |
| `.widgetAccentedRenderingMode(.fullColor)` on an image that is not media | Let it desaturate |
| `.white.opacity(` in a Lock Screen widget | An opaque gray |
| A widget status shown only by `.red` or `.green` | Add text or a symbol, since two modes remove the hue |
| `activityBackgroundTint` with a literal color | A color set with both appearances |

## Reporting

**Severity.** `HIGH` makes content unreadable or misleads. Three of `design-review`'s escalation triggers land here and are `HIGH` on sight. They are body or control text whose rendered pair fails its threshold, state or meaning carried by color alone and a semantic color used against its meaning. `MEDIUM` is a missing variant, a hard-coded color, a role borrowed for another job or an app that ignores the system appearance by default. `LOW` is isolated polish.

**Verification.** Without Xcode, read every color in scope against the rules above. Open each `.colorset/Contents.json` to check its variants and color space. Compute contrast from declared components where both colors are custom and opaque, and mark pairs that involve system colors or translucency `Not verified`. With Xcode, render each screen in light and dark, with Increase Contrast off and on. Measure each pair with Accessibility Inspector's Color Contrast Calculator, or with `Color.resolve(in:)` in a test. Report every check you could not run as `Not verified`.

**Format.** Group findings under the principle each violates, ordered by severity, one row per root cause listing every location it appears in:

| Severity | Location | Before | After | Why |
| --- | --- | --- | --- | --- |

`Location` is `path/to/file.swift:line`. `Why` names the principle and the user impact.

End with `Block` when any `HIGH` remains, `Approve` otherwise, leaving the rest in the table as work to do. Never `Approve` coverage you did not inspect. With nothing to report, state "No actionable color findings" and report verification.
