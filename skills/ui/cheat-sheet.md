# Cheat sheet

Every surface, symbol and pointer API this skill names, with its UIKit equivalent. Match whichever the view under review is written in.

## Glass

| Need | SwiftUI | UIKit |
| --- | --- | --- |
| Glass on a custom view | `.glassEffect(_:in:)` | `UIVisualEffectView(effect: UIGlassEffect())` |
| Clear variant | `.glassEffect(.clear)` | `UIGlassEffect(style: .clear)` |
| Responds to touch | `Glass.interactive(_:)` | `UIGlassEffect.isInteractive` |
| Tint | `Glass.tint(_:)` | `UIGlassEffect.tintColor` |
| Group and morph shapes | `GlassEffectContainer`, `glassEffectID(_:in:)` | `UIVisualEffectView(effect: UIGlassContainerEffect())` |
| Glass button | `.buttonStyle(.glass)`, `.buttonStyle(.glassProminent)` | `UIButton.Configuration.glass()`, `.prominentGlass()` |
| Clear glass button | `.buttonStyle(.glass(.clear))` | `UIButton.Configuration.clearGlass()`, `.prominentClearGlass()` |

## Bars and edges

| Need | SwiftUI | UIKit |
| --- | --- | --- |
| Custom bar with the scroll edge effect | `.safeAreaBar(edge:alignment:spacing:content:)` | `UIScrollEdgeElementContainerInteraction` |
| Scroll edge style | `.scrollEdgeEffectStyle(_:for:)` | `style` on `topEdgeEffect`, `bottomEdgeEffect`, `leftEdgeEffect` or `rightEdgeEffect` |
| Content extended under a sidebar | `.backgroundExtensionEffect()` | `UIBackgroundExtensionView` |
| Fixed space between toolbar groups | `ToolbarSpacer(.fixed)` | `UIBarButtonItem.fixedSpace(_:)` |
| Item without the shared glass | `.sharedBackgroundVisibility(.hidden)` | `UIBarButtonItem.hidesSharedBackground` |
| Hide a toolbar item | Leave it out with `if` | `UIBarButtonItem.isHidden` |

## Materials and shapes

| Need | SwiftUI | UIKit |
| --- | --- | --- |
| Material | `.background(.regularMaterial, in:)` | `UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))` |
| Concentric corners | `ConcentricRectangle`, `.containerShape(_:)` | `cornerConfiguration` with `UICornerRadius.containerConcentric(minimum:)` |
| Continuous corners | `RoundedRectangle(cornerRadius:)`, `.rect(cornerRadius:)` | `layer.cornerRadius` with `layer.cornerCurve = .continuous` |
| Control size | `.controlSize(_:)` | `UIButton.Configuration.buttonSize` |
| Background levels | `Color(.secondarySystemGroupedBackground)` | `UIColor.secondarySystemGroupedBackground` |

## Symbols

| Need | SwiftUI | UIKit |
| --- | --- | --- |
| System symbol | `Image(systemName:)` | `UIImage(systemName:)` |
| Size with a text style | `.font(_:)`, `.imageScale(_:)` | `UIImage.SymbolConfiguration(textStyle:scale:)` |
| Weight | `.fontWeight(_:)` | `UIImage.SymbolConfiguration(weight:)` |
| Variant | `.symbolVariant(_:)` | The variant's name, such as `"bookmark.fill"` |
| Hierarchical | `.symbolRenderingMode(.hierarchical)` | `UIImage.SymbolConfiguration(hierarchicalColor:)` |
| Palette | `.symbolRenderingMode(.palette)` | `UIImage.SymbolConfiguration(paletteColors:)` |
| Multicolor | `.symbolRenderingMode(.multicolor)` | `UIImage.SymbolConfiguration.preferringMulticolor()` |
| Variable value | `Image(systemName:variableValue:)` | `UIImage(systemName:variableValue:configuration:)` |
| Draw mode | `.symbolVariableValueMode(.draw)` | `UIImage.SymbolConfiguration(variableValueMode:)` |
| Gradient | `.symbolColorRenderingMode(.gradient)` | `UIImage.SymbolConfiguration(colorRenderingMode:)` |
| Template image | `.renderingMode(.template)` | `withRenderingMode(.alwaysTemplate)` |
| Flip in right-to-left | `.flipsForRightToLeftLayoutDirection(true)` | `imageFlippedForRightToLeftLayoutDirection()` |

## Pointer

| Need | SwiftUI | UIKit |
| --- | --- | --- |
| Highlight | `.hoverEffect(.highlight)` | `hoverStyle = UIHoverStyle(effect: UIHoverHighlightEffect())` |
| Lift | `.hoverEffect(.lift)` | `hoverStyle = UIHoverStyle(effect: UIHoverLiftEffect())` |
| Shape of the effect | `.contentShape(.hoverEffect, _:)` | `UIHoverStyle(effect:shape:)` with a `UIShape` |
| Pointer enters or leaves | `.onHover(perform:)` | `UIHoverGestureRecognizer` |
| Pointer position | `.onContinuousHover(coordinateSpace:perform:)` | `UIHoverGestureRecognizer` with `location(in:)` |
