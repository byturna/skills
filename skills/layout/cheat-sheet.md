# Cheat sheet

Every layout API this skill names, with its UIKit equivalent. Match whichever the view under review is written in.

## Margins and alignment

| Need | SwiftUI | UIKit |
| --- | --- | --- |
| System margin | `.padding()` with no argument | `directionalLayoutMargins`, `layoutMarginsGuide` |
| Content inset counted as safe area | `.safeAreaPadding(_:_:)` | `additionalSafeAreaInsets` |
| Scroll content inset | `.contentMargins(_:_:for:)` | `contentInset` |
| Shared baseline | `HStack(alignment: .firstTextBaseline)` | `firstBaselineAnchor` |
| Label and value columns | `Grid`, `LabeledContent` | `UIStackView`, `UIListContentConfiguration.valueCell()` |
| Readable width for long text | A project `maxWidth` | `readableContentGuide` |

## Safe areas and the keyboard

| Need | SwiftUI | UIKit |
| --- | --- | --- |
| Background under the safe areas | `.ignoresSafeArea()` on the background | Constrain the background to the view's edges |
| Content inside the safe areas | The default | `safeAreaLayoutGuide` |
| Bar pinned to an edge | `.safeAreaBar(edge:alignment:spacing:content:)` | `additionalSafeAreaInsets` with `UIScrollEdgeElementContainerInteraction` |
| Content above the keyboard | The default | `keyboardLayoutGuide` |
| Dismiss the keyboard by scrolling | `.scrollDismissesKeyboard(.interactively)` | `keyboardDismissMode = .interactive` |
| Controls above the keyboard | `ToolbarItemGroup(placement: .keyboard)` | `inputAccessoryView` |

## Adapting

| Need | SwiftUI | UIKit |
| --- | --- | --- |
| Size class | `@Environment(\.horizontalSizeClass)` | `traitCollection.horizontalSizeClass` |
| First layout that fits | `ViewThatFits` | Compare `systemLayoutSizeFitting(_:)` results |
| Switch stack direction | `AnyLayout` with `HStackLayout` and `VStackLayout` | `UIStackView.axis` |
| Accessibility text size | `dynamicTypeSize.isAccessibilitySize` | `preferredContentSizeCategory.isAccessibilityCategory` |
| Columns from the available width | `GridItem(.adaptive(minimum:))` | `UICollectionViewCompositionalLayout` |
| Size relative to the container | `containerRelativeFrame(_:alignment:)` | Constraints to the container's guides |
| React to a size change | `onGeometryChange(for:of:action:)` | `viewWillTransition(to:with:)`, trait change registration |

## Scrolling and disclosure

| Need | SwiftUI | UIKit |
| --- | --- | --- |
| Settle on items | `.scrollTargetBehavior(.viewAligned)` with `.scrollTargetLayout()` | `NSCollectionLayoutSection.orthogonalScrollingBehavior` |
| Flash the indicators | `.scrollIndicatorsFlash(onAppear:)` | `flashScrollIndicators()` |
| Collapsed section | `DisclosureGroup` | `UICellAccessory.outlineDisclosure` in a collection view list |

## Mirroring

| Need | SwiftUI | UIKit |
| --- | --- | --- |
| Leading and trailing | `.leading`, `.trailing`, `Edge.Set.leading` | `leadingAnchor`, `NSDirectionalEdgeInsets` |
| Keep playback order | `.environment(\.layoutDirection, .leftToRight)` on the row | `semanticContentAttribute = .playback` |
| Preview right-to-left | `.environment(\.layoutDirection, .rightToLeft)` | The scheme's right-to-left pseudolanguage |
