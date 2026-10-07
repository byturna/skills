# Cheat sheet

Every preview API this skill names, with its UIKit form. A UIKit preview returns a `UIView` or a `UIViewController`, and its settings go through `traitOverrides` rather than the environment.

| Need | SwiftUI | UIKit |
| --- | --- | --- |
| A named preview | `#Preview("Empty") { MemberList(members: []) }` | `#Preview("Empty") { MemberListViewController(members: []) }` |
| Largest text size | `.dynamicTypeSize(.accessibility5)` | `traitOverrides.preferredContentSizeCategory = .accessibilityExtraExtraExtraLarge` |
| Dark appearance | `.preferredColorScheme(.dark)` | `traitOverrides.userInterfaceStyle = .dark` |
| Right to left | `.environment(\.layoutDirection, .rightToLeft)` | `traitOverrides.layoutDirection = .rightToLeft` |
| Bold Text | `.environment(\.legibilityWeight, .bold)` | `traitOverrides.legibilityWeight = .bold` |
| Size class | `.environment(\.horizontalSizeClass, .compact)` | `traitOverrides.horizontalSizeClass = .compact` |
| Fixed size | `traits: .fixedLayout(width:height:)` | The same trait |
| Fit to content | `traits: .sizeThatFitsLayout` | The same trait |
| Orientation | `traits: .landscapeLeft` | The same trait |
| Shared setup | `PreviewModifier` with `traits: .modifier(_:)` | Build it in the preview's closure |
| An editable binding | `@Previewable @State` | Not available |

```swift
#Preview("AX5") {
    let controller = MemberListViewController(members: Member.worstCase)
    controller.traitOverrides.preferredContentSizeCategory = .accessibilityExtraExtraExtraLarge
    return controller
}
```
