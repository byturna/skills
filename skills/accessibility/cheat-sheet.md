# Cheat sheet

Every accessibility API this skill names, with its UIKit equivalent. Match whichever the view under review is written in.

## Elements

| Need | SwiftUI | UIKit |
| --- | --- | --- |
| Name | `.accessibilityLabel(_:)` | `accessibilityLabel` |
| Current value | `.accessibilityValue(_:)` | `accessibilityValue` |
| Result of activating | `.accessibilityHint(_:)` | `accessibilityHint` |
| Type and state | `.accessibilityAddTraits(.isButton)` | `accessibilityTraits.insert(.button)` |
| Heading | `.accessibilityAddTraits(.isHeader)` | `accessibilityTraits.insert(.header)` |
| Selected | `.accessibilityAddTraits(.isSelected)` | `accessibilityTraits.insert(.selected)` |
| Disabled | `.disabled(true)` | `isEnabled = false`, or the `.notEnabled` trait |
| Live value | `.accessibilityAddTraits(.updatesFrequently)` | `accessibilityTraits.insert(.updatesFrequently)` |
| Hide decoration | `Image(decorative:)`, `.accessibilityHidden(true)` | `isAccessibilityElement = false`, `accessibilityElementsHidden = true` |
| Speak through a system control | `.accessibilityRepresentation { … }` | Implement the traits and actions on the view |
| Spoken alternatives for Voice Control | `.accessibilityInputLabels(_:)` | `accessibilityUserInputLabels` |

## Structure

| Need | SwiftUI | UIKit |
| --- | --- | --- |
| Read a group as one | `.accessibilityElement(children: .combine)` | `isAccessibilityElement = true` on the container, with a composed label |
| Group without merging | `.accessibilityElement(children: .contain)` | `shouldGroupAccessibilityChildren = true` |
| Change reading order | `.accessibilitySortPriority(_:)` | `accessibilityElements` |
| Custom rotor | `.accessibilityRotor(_:entries:)` | `accessibilityCustomRotors` |

## Actions

| Need | SwiftUI | UIKit |
| --- | --- | --- |
| Named action | `.accessibilityAction(named:_:)`, `.accessibilityActions { … }` | `accessibilityCustomActions` with `UIAccessibilityCustomAction` |
| Adjustable value | `.accessibilityAdjustableAction(_:)` | The `.adjustable` trait with `accessibilityIncrement()` and `accessibilityDecrement()` |
| Escape | `.accessibilityAction(.escape, _:)` | `accessibilityPerformEscape()` |
| Modal | `.accessibilityAddTraits(.isModal)` | `accessibilityViewIsModal = true` |

## Focus and announcements

| Need | SwiftUI | UIKit |
| --- | --- | --- |
| Move VoiceOver focus | `@AccessibilityFocusState` with `.accessibilityFocused(_:)` | `UIAccessibility.post(notification: .layoutChanged, argument: view)` |
| Move keyboard focus | `@FocusState` with `.focused(_:)` | `becomeFirstResponder()` |
| Announce | `AccessibilityNotification.Announcement(_:).post()` | `UIAccessibility.post(notification: .announcement, argument:)` |
| New screen | `AccessibilityNotification.ScreenChanged(_:).post()` | `UIAccessibility.post(notification: .screenChanged, argument:)` |
| Partial change | `AccessibilityNotification.LayoutChanged(_:).post()` | `UIAccessibility.post(notification: .layoutChanged, argument:)` |
| Keyboard shortcut | `.keyboardShortcut(_:)` | `UIKeyCommand` |

## Settings

| Setting | SwiftUI environment value | UIKit |
| --- | --- | --- |
| Reduce Motion | `accessibilityReduceMotion` | `UIAccessibility.isReduceMotionEnabled` |
| Reduce Transparency | `accessibilityReduceTransparency` | `UIAccessibility.isReduceTransparencyEnabled` |
| Increase Contrast | `colorSchemeContrast` | `traitCollection.accessibilityContrast` |
| Bold Text | `legibilityWeight` | `UIAccessibility.isBoldTextEnabled` |
| Differentiate Without Color | `accessibilityDifferentiateWithoutColor` | `UIAccessibility.shouldDifferentiateWithoutColor` |
| Button Shapes | `accessibilityShowButtonShapes` | `UIAccessibility.buttonShapesEnabled` |
| Smart Invert | `accessibilityInvertColors` | `UIAccessibility.isInvertColorsEnabled` |
| Animated images | `accessibilityPlayAnimatedImages` | `AccessibilitySettings.animatedImagesEnabled` |
| Dim Flashing Lights | `accessibilityDimFlashingLights` | `MADimFlashingLightsEnabled()` |
| Text size | `dynamicTypeSize` | `traitCollection.preferredContentSizeCategory` |
| VoiceOver running | `accessibilityVoiceOverEnabled` | `UIAccessibility.isVoiceOverRunning` |

## Display

| Need | SwiftUI | UIKit |
| --- | --- | --- |
| Keep media uninverted | `.accessibilityIgnoresInvertColors()` | `accessibilityIgnoresInvertColors = true` |
| Large Content Viewer | `.accessibilityShowsLargeContentViewer()` | `UILargeContentViewerInteraction` with `showsLargeContentViewer = true` |
| Cap the text size range | `.dynamicTypeSize(...DynamicTypeSize.accessibility1)` | `maximumContentSizeCategory` |

## Testing

| Check | How |
| --- | --- |
| Automated audit in a UI test | `try app.performAccessibilityAudit()` on an `XCUIApplication` |
| Audit a running screen | Accessibility Inspector's Audit tab |
| Contrast of a pair | Accessibility Inspector's Color Contrast Calculator |
| Settings while debugging | Xcode's Environment Overrides |
| Text sizes in previews | `.dynamicTypeSize(.accessibility5)`, or the canvas's Dynamic Type variants |
