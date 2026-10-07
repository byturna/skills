---
name: ui
description: Builds the surfaces and icons of SwiftUI and UIKit apps, from Liquid Glass, materials and concentric corners to SF Symbols and iPad pointer hover.
---

# UI

This skill decides what each surface on an iOS screen is made of and how its icons are drawn. It places Liquid Glass and materials, shapes corners and elevation, chooses and sizes SF Symbols and sets pointer effects on iPad.

Color, vibrancy and contrast on glass and materials belong to `color`. The contrast requirement, Reduce Transparency as a requirement and icon labels belong to `accessibility`. Spacing and safe areas belong to `layout`, and toolbar placement and which presentation a flow uses to `navigation`. Symbol animation belongs to `motion` and text styles to `typography`. The UIKit form of every API here is in [cheat-sheet.md](cheat-sheet.md).

## The system draws most surfaces

Bars, sheets, popovers, menus and system controls take their Liquid Glass, corners and pointer effects from the iOS 26 SDK. They follow Reduce Transparency, Increase Contrast and the Liquid Glass look a person picks in Settings. Most findings here are custom work that fights them. Typical ones are a background laid over a bar, glass in the content layer, a radius that ignores its container and a symbol forced to a size.

The system APIs, the HIG's standard symbols and its 35% dimming layer are exact. The image outline and the pointer hit-region padding are starting points, judged on screen. A consistent project convention, such as one card radius, is a preference. The same detail done two ways in one project is a finding.

An app whose Info.plist sets `UIDesignRequiresCompatibility` has opted out of Liquid Glass. Skip the glass rules and report the opt-out once as `LOW`. Apple calls the key temporary, and builds against the iOS 27 SDK ignore it.

## Glass belongs to controls and navigation

Liquid Glass is the functional layer that floats above content: bars, tab bars, sidebars, toolbars, sheets, menus and the controls that float with them. Content never takes it. A card, a row, a list or a screen background takes a background level or a standard material instead. The one exception is the system's own, a slider or toggle knob that turns to glass while dragged.

Use custom glass sparingly, on the few functional elements that matter most, since each one draws the eye from the content beneath. The layer map is in [glass.md](glass.md#which-layer).

## Bars, sheets and popovers keep the system background

Remove custom backgrounds from `NavigationStack`, `NavigationSplitView`, toolbars, tab bars, sheets and popovers. A `.toolbarBackground` style, a `.presentationBackground` or an appearance object's background lays a surface over the glass and the scroll edge effect.

A custom bar over scrolling content goes in `.safeAreaBar`, which extends the scroll edge effect beneath it. Never draw a divider or a gradient under a bar to separate it from content. See [glass.md](glass.md#bars-and-scroll-edges).

## Toolbar items share glass by group

Toolbar items that sit together share one glass background. Group the items that act on the same thing, and separate groups with `ToolbarSpacer(.fixed)`. Never mix a text item and an icon item inside one shared background.

Hide an item by leaving it out of the toolbar with `if`, never by hiding the view inside it, which can leave an empty item behind. `ToolbarContent.hidden(_:)` arrived in iOS 26.4, after this repository's SDK. Recipes are in [glass.md](glass.md#toolbars).

## Custom glass goes through the glass APIs

A custom button in the glass layer takes `.buttonStyle(.glass)` or `.glassProminent` before any effect of its own. Any other custom element there takes `.glassEffect(_:in:)`. Add `.interactive()` when it responds to touch, and `.tint(_:)` only to suggest prominence. Apply `.glassEffect` after the modifiers that shape the view's appearance.

Glass elements near one another go in one `GlassEffectContainer`, which renders them together and lets them morph through `glassEffectID(_:in:)`. Never put glass on glass, and never imitate it with a material, a stroke and a shadow. See [glass.md](glass.md#custom-glass).

## Clear glass only over media

The regular variant is the default and suits anything with text. `.clear` belongs only to controls that float over photos or video. Where the media beneath is bright, put a black dimming layer at 35% opacity behind the clear glass. AVKit's standard playback controls bring their own. See [glass.md](glass.md#clear-glass).

## Materials structure the content layer

Inside content, set a region apart with a standard material in a shape, through `.background(_:in:)`. The four are `.ultraThinMaterial`, `.thinMaterial`, `.regularMaterial` and `.thickMaterial`. Thicker materials hold text and fine detail better, and thinner ones keep more of the content behind them in view. Choose by that need, never by the tint a material happens to show.

System materials and glass become more opaque under Reduce Transparency on their own, and any custom translucency must too. Foreground color on a material belongs to `color`. See [glass.md](glass.md#materials).

## Nested corners are concentric

A rounded shape inset inside another shares its corner's center, so its radius is the outer radius minus the inset. Draw it with `ConcentricRectangle` and let SwiftUI compute the radius. Sheets, popovers and the screen are containers already, and a custom card becomes one with `.containerShape(.rect(cornerRadius:))`.

A corner far from its container's corner resolves to square. Give it `.concentric(minimum:)` with the project's radius. Never repeat the outer radius on the inner shape. Recipes are in [shapes.md](shapes.md#concentric-corners).

## System controls keep their own shape

Buttons, toggles, sliders, pickers and text fields take their iOS 26 shapes and sizes on their own, so never hard-code their height, padding or corner radius. Size a control with `.controlSize`, shape a bordered button with `.buttonBorderShape` and style it with a system button style. `RoundedRectangle` and `.rect(cornerRadius:)` are already continuous, so `style: .circular` needs a reason. See [shapes.md](shapes.md#control-shapes).

## Background levels show elevation

iOS sets a surface apart from the one beneath it with background levels, not shadows. A card on `systemGroupedBackground` takes `secondarySystemGroupedBackground`, which an inset grouped `List` or `Form` already draws. In the dark appearance, a sheet or popover lifts to the brighter elevated colors on its own, and a custom background color hides that.

A shadow or a border that only lifts a content card is a finding. Keep `Divider`, list separators and selection outlines, which mark structure rather than depth. Recipes are in [shapes.md](shapes.md#elevation).

## Outline images that could merge with the background

A thumbnail, cover or avatar on a background it might match takes a 1pt line inside its edge, in `Color.primary.opacity(0.1)`. `Color.primary` is black in light and white in dark, so the line never tints the image the way a gray or an accent color does. Skip transparent artwork such as logos and illustrations, and full-bleed media. The recipe is in [shapes.md](shapes.md#image-outlines).

## SF Symbols before custom icons

Use an SF Symbol before drawing an icon, and the HIG's standard symbol for a common action, such as `square.and.arrow.up` for Share. A custom icon is a custom symbol built from the SF Symbols template, so it takes weights, scales and rendering modes like the rest. Never mix SF Symbols with another icon set on one surface, and never put a symbol in an app icon or logo, which its license forbids.

Every name must exist in SF Symbols 7, the set iOS 26 ships. A name that does not exist compiles and renders nothing. The standard symbols and the custom symbol steps are in [symbols.md](symbols.md).

## Symbols size and weigh like the text beside them

A symbol takes its size and weight from the font, so `Label`, `.font` and `.fontWeight` reach the symbol and the text together. Change a symbol's emphasis with `.imageScale`, which keeps the weight match. Never `.resizable()` and `.frame` a symbol beside text, because it stops matching the text's weight, baseline and Dynamic Type size. A standalone symbol takes a text style too, such as `.font(.largeTitle)`. See [symbols.md](symbols.md#size-and-weight).

## The container picks outline or fill

Name the outline symbol, `"house"` and not `"house.fill"`, in tab items and toolbars. A tab bar draws the fill variant and a toolbar the outline on its own. System components also draw their own selected state, so never ship a second asset for it.

A custom control that shows selection uses `.symbolVariant(.fill)` for the selected state and `.slash` for an unavailable one. See [symbols.md](symbols.md#variants).

## Rendering mode follows meaning

Monochrome is the default. Hierarchical gives depth in one color, and palette applies the two or three colors a design names. Multicolor is for symbols whose own colors carry meaning, such as a green `leaf`. A changing quantity, such as volume or signal strength, takes a variable value, never depth. Check each mode at the size it renders. See [symbols.md](symbols.md#rendering-modes).

## Optical corrections live in the asset

Symbols align with text through their cap height and baseline on their own. A custom icon that looks off-center carries its correction as padding in the asset, or as margins in a custom symbol, so centering it in code centers it optically. Prefer an enclosed variant such as `play.circle.fill` to a glyph centered in a shape of your own, since the variant is drawn as one symbol. See [symbols.md](symbols.md#optical-alignment).

## Flip only icons that point along the reading direction

SF Symbols switch to their right-to-left variants on their own. A custom icon that depicts text, or forward and backward motion, flips with `.flipsForRightToLeftLayoutDirection(true)`. Logos, the checkmark and other universal marks, real-world objects, photos and artwork never flip. Check a composite icon part by part, since a badge or a slash may keep its place. Mirroring the layout around icons belongs to `layout`. See [symbols.md](symbols.md#right-to-left).

## Pointer effects on iPad come from the system

Bar buttons, tab bars, segmented controls and edit menus highlight under the pointer on their own. A custom tappable view takes `.hoverEffect`: `.highlight` for a small element on a transparent background, `.lift` for a small opaque one. A large element, such as a card or a row, changes its background on `.onHover` rather than scaling into its neighbors.

Shape the effect with `.contentShape(.hoverEffect, _:)` where the view's corners differ from the default. See [pointer.md](pointer.md).

## Nothing waits for hover

Touch has no hover. Every action or detail revealed under the pointer is also reachable by touch, through the view itself, `.swipeActions` or `.contextMenu`. Hover adds precision, never a requirement. See [pointer.md](pointer.md#hover-never-gates).

## Before you finish

| Pattern | Fix |
| --- | --- |
| `.glassEffect` on a card, row, list or screen background | A background level or a standard material |
| `.glassEffect` on a view inside another glass surface | One layer of glass |
| A material, a stroke and a shadow imitating glass | `.buttonStyle(.glass)` or `.glassEffect` |
| Several `.glassEffect` views side by side with no `GlassEffectContainer` | Wrap them in one container |
| `.glassEffect(.clear)` over anything but photos or video | `.regular` |
| `.toolbarBackground` with a color or material, `.presentationBackground`, or a background on a bar appearance | Remove it |
| `.safeAreaInset` holding a bar over a `ScrollView`, or a `Divider` or gradient under a pinned bar | `.safeAreaBar` |
| `.opacity(0)` or `.hidden()` on the view inside a `ToolbarItem` | Leave the item out with `if` |
| A nested shape with the same corner radius as its padded parent | `ConcentricRectangle`, with `.containerShape` on the parent |
| `.frame(height:)`, a background or `.clipShape` restyling a `Button` | A system button style with `.controlSize` |
| `style: .circular`, or `.cornerRadius(_:)` | The default continuous style, through `.clipShape(.rect(cornerRadius:))` |
| `.shadow` or a stroke overlay on a content card | `secondarySystemGroupedBackground` on `systemGroupedBackground` |
| A gray or accent stroke around an image | `.strokeBorder(Color.primary.opacity(0.1), lineWidth: 1)` |
| `Image(systemName:)` with `.resizable()` and a fixed `.frame` beside text | `.font` and `.imageScale` |
| A `.fill` symbol name in a `Tab` or a toolbar item | The outline name |
| A symbol name missing from SF Symbols 7, or an icon from a second icon set | An SF Symbol or a custom symbol |
| `.scaleEffect(x: -1)` on an icon, or any flip on a logo or checkmark | `.flipsForRightToLeftLayoutDirection(true)` on directional icons only |
| Content shown only while `.onHover` or `.onContinuousHover` reports the pointer inside | A touch path as well |

## Reporting

**Severity.** `HIGH` hides content or blocks an action. Examples are an action reachable only by hover and a symbol name that renders nothing on an icon-only control. Glass, a material or a bar background that leaves text unreadable is `HIGH` too. That text reaches `design-review`'s contrast trigger, and `color` measures the pair. `MEDIUM` is a visible break from the system. It covers glass in the content layer or on glass, a custom bar or sheet background and corners that are not concentric. It also covers a resized symbol, mixed icon sets, a wrong flip and one detail done two ways. `LOW` is isolated polish such as a missing image outline or a hover effect choice.

**Verification.** Without Xcode, read every `.glassEffect`, glass button style, material, toolbar and presentation background, shape, `Image(systemName:)` and hover modifier in scope against the rules above. Confirming a symbol name needs the SF Symbols app, so list any name you could not confirm. With Xcode, render each surface in light and dark appearance, over light and dark content. Use Environment Overrides to turn on Reduce Transparency and Increase Contrast. Run once in the right-to-left pseudolanguage. Hover needs an iPad with a pointer, or the iPad Simulator with the pointer captured. Report every check you could not run as `Not verified`.

**Format.** Group findings under the principle each violates, ordered by severity, one row per root cause listing every location it appears in:

| Severity | Location | Before | After | Why |
| --- | --- | --- | --- | --- |

`Location` is `path/to/file.swift:line`. `Why` names the principle and the user impact.

End with `Block` when any `HIGH` remains, `Approve` otherwise, leaving the rest in the table as work to do. Never `Approve` coverage you did not inspect. With nothing to report, state "No actionable surface or icon findings" and report verification.
