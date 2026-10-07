# Removed signals

What to look for on the `-` side of a hunk and the added lines that weaken something, with the skill that owns each judgment.

## Removed lines

| Removed from the `-` side | Owner | What to check |
| --- | --- | --- |
| `.accessibilityLabel`, `.accessibilityValue`, `.accessibilityHint`, `.accessibilityInputLabels` | `accessibility` | The element lost its name, value, hint or Voice Control name |
| `.accessibilityAddTraits`, `.accessibilityElement(children:)`, `.accessibilityAction`, `.accessibilityRepresentation` | `accessibility` | The element lost its type, its grouping or an action VoiceOver could reach |
| `@FocusState`, `.focusable`, `.keyboardShortcut` | `accessibility` | Keyboard focus or a shortcut was dropped |
| An `accessibilityReduceMotion` check | `motion` | Motion now ignores Reduce Motion |
| `.sensoryFeedback` | `motion` | A confirmation lost its haptic, and may now ride on motion alone |
| `relativeTo:` dropped from `Font.custom`, or `@ScaledMetric` removed | `typography` | Text or a size beside it stopped scaling |
| `.monospacedDigit()`, `.truncationMode`, `.typesettingLanguage`, `.textSelection(.enabled)` | `typography` | Digits, truncation, tall scripts or copying silently changed |
| `ViewThatFits`, or a branch on `dynamicTypeSize.isAccessibilitySize` | `layout` | The layout no longer adapts at accessibility sizes |
| `.leading` or `.trailing` swapped for `.left` or `.right` | `layout` | The layout stopped mirroring in right to left |
| `.safeAreaInset`, `.safeAreaPadding`, `.scrollDismissesKeyboard` | `layout` | Content can now sit under a bar or the keyboard |
| `chevron.forward` or `chevron.backward` swapped for a fixed direction | `ui` | The symbol stopped mirroring |
| A semantic or asset color replaced by a literal, or an appearance removed from a `.colorset` | `color` | The color lost its dark or high-contrast value, so measure the pair |
| A `colorSchemeContrast` check | `color` | A color stopped answering Increase Contrast |
| `role: .destructive`, or a `.confirmationDialog` before a destructive action | `writing` | A destructive action lost its treatment or its confirmation |
| A String Catalog entry deleted or its value shortened, or `String(localized:)` replaced by a literal | `writing` | A label, error or empty state lost information, or stopped being translatable |
| `TabView`, `NavigationStack`, `.sheet` or `.alert` replaced by a custom view | `navigation` | The system structure and what it brings were traded for a rebuild |
| `.interactiveDismissDisabled`, or a sheet's Cancel or Close | `navigation` | A sheet can now lose work, or has no way out |

## Added lines

Some regressions arrive on the `+` side:

| Added on the `+` side | Owner | What to check |
| --- | --- | --- |
| `.onTapGesture` on a view that acts as a button | `accessibility` | Touch still works, but VoiceOver, Voice Control and the keyboard lost the control |
| `.font(.system(size:))` in place of a text style | `typography` | Text stopped scaling with Dynamic Type |
| `.dynamicTypeSize(...)` with an upper bound | `accessibility` | Text stopped scaling past the cap |
| `.lineLimit(1)` or `.minimumScaleFactor` | `typography` | Text that wrapped now truncates or shrinks |
| `.focusEffectDisabled()` | `accessibility` | The keyboard focus indicator was turned off |
| `.accessibilityHidden(true)` on something meaningful | `accessibility` | Content left VoiceOver |
| `.preferredColorScheme` | `color` | The screen stopped following the system appearance |
| `UIDesignRequiresCompatibility` in `Info.plist` | `ui` | The app opted out of Liquid Glass |

## Equivalent replacements

These clear the signal. Drop any removal one of them explains before routing anything:

- `.accessibilityLabel` on an icon-only button giving way to a titled `Button` with `.labelStyle(.iconOnly)`.
- `.onTapGesture` giving way to `Button`, which is the fix.
- `.accessibilityHidden(true)` giving way to `Image(decorative:)`.
- `.accessibilityElement(children: .combine)` over visible text in place of a hand-written label.
- A color literal replaced by an asset color or system color with the same value.
- `Color("Name")` replaced by its generated symbol, `Color(.name)`.
- `.left` or `.right` replaced by `.leading` or `.trailing`, which is the fix.
- A string moved into a String Catalog rather than deleted.

## Searching the diff

Restrict each search to one side, so additions do not mask a removal. Pass the exclusion pathspecs from [scope-resolution.md](scope-resolution.md#excluded-paths) after `--`:

```bash
git diff -U0 "$BASE" <head-ref> -- . <exclusions> \
  | grep -E '^-' | grep -vE '^--- (a/|/dev/null)' \
  | grep -E 'accessibility|FocusState|focusable|keyboardShortcut|ReduceMotion|sensoryFeedback|ScaledMetric|relativeTo|monospacedDigit|truncationMode|typesettingLanguage|textSelection|ViewThatFits|isAccessibilitySize|leading|trailing|safeArea|scrollDismissesKeyboard|forward|backward|Contrast|destructive|confirmationDialog|interactiveDismiss|localized'

git diff -U0 "$BASE" <head-ref> -- . <exclusions> \
  | grep -E '^\+' | grep -vE '^\+\+\+ ' \
  | grep -E 'onTapGesture|dynamicTypeSize|lineLimit\(1\)|minimumScaleFactor|focusEffectDisabled|accessibilityHidden\(true\)|preferredColorScheme|UIDesignRequiresCompatibility|\.left\b|\.right\b|system\(size:'
```

Leave `<head-ref>` off for a target that includes uncommitted work, so the diff runs against the working tree. Removed strings, catalog values and color set appearances have no pattern, so read those hunks.

Read the surrounding hunk before deciding. A removed modifier means nothing without the view it came from, and `-U0` hides that context on purpose.

## UIKit signals

| Removed from the `-` side | Owner |
| --- | --- |
| `accessibilityLabel`, `accessibilityValue`, `accessibilityHint`, `accessibilityUserInputLabels` assignments | `accessibility` |
| `isAccessibilityElement = true`, or `accessibilityTraits` | `accessibility` |
| `UIFont.preferredFont(forTextStyle:)` replaced by `UIFont.systemFont(ofSize:)`, or `adjustsFontForContentSizeCategory = true` removed | `typography` |
| `UIAccessibility.isReduceMotionEnabled` checks | `motion` |
| `leadingAnchor` or `trailingAnchor` swapped for `leftAnchor` or `rightAnchor` | `layout` |
| A system or asset color replaced by `UIColor(red:green:blue:alpha:)` | `color` |

| Added on the `+` side | Owner |
| --- | --- |
| `maximumContentSizeCategory` | `accessibility` |
| `adjustsFontSizeToFitWidth`, or `numberOfLines = 1` | `typography` |
| `semanticContentAttribute = .forceLeftToRight` | `layout` |
