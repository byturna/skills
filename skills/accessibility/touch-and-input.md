# Touch and input

Target sizes, gesture alternatives, Voice Control, Switch Control and keyboards on iPad.

## Targets

| Size | Status |
| --- | --- |
| 44×44pt or larger | The HIG default |
| 28×28pt to 44×44pt | Allowed; a recommendation where density allows more |
| Under 28×28pt | A finding |

The visible glyph can stay small. What must be large is the area that responds, and in SwiftUI that is the button's label, so size the label:

```swift
// Good: a 17pt symbol with a 44pt target
Button {
    toggleFavorite()
} label: {
    Image(systemName: isFavorite ? "star.fill" : "star")
        .frame(minWidth: 44, minHeight: 44)
        .contentShape(.rect)
}
.accessibilityLabel(isFavorite ? "Remove from Favorites" : "Add to Favorites")

// Bad: the frame sits outside the button, so taps on the padding miss
Button(action: toggleFavorite) {
    Image(systemName: "star")
}
.frame(width: 44, height: 44)
```

Two expanded targets never overlap. Where they would, shrink both to the largest size that does not collide, and keep at least 28pt. Spacing between controls belongs to `layout`.

A decorative layer drawn over a control, such as a gradient scrim or a glow, takes `.allowsHitTesting(false)` so taps reach the control beneath. If it is a separate view, it also takes `.accessibilityHidden(true)`.

## Gesture alternatives

Every interaction has a path that needs no gesture beyond a tap:

| Gesture | Accessible path |
| --- | --- |
| Swipe to reveal row actions | `.swipeActions`, which VoiceOver exposes on its own |
| Long press for options | `.contextMenu`, exposed on its own |
| Custom swipe or drag to dismiss | `.accessibilityAction(named: "Dismiss")` and a visible close button |
| Drag to reorder | `EditButton` with `.onMove`, or a "Move Up" and "Move Down" action |
| Drag and drop between containers | A "Move to…" menu or action |
| Pinch or rotate | Buttons or a slider for the same change |
| Double tap | The single-tap path or an action |

```swift
CardView(card: card)
    .gesture(swipeToDismiss)
    .accessibilityAction(named: "Dismiss") { dismiss(card) }
```

Frequent interactions use the simplest gesture that works. Custom multifinger gestures are never the only route to anything.

## Voice Control

Voice Control users say "Tap" plus a control's name, so the name must match what they see:

- The accessible name starts with the visible text. A button showing "End" is not named "Leave call".
- `.accessibilityInputLabels` adds spoken alternatives, with the visible text first.
- An icon-only control's name is what people would call it, since there is no text to read.

```swift
Button("Compose", systemImage: "square.and.pencil", action: compose)
    .labelStyle(.iconOnly)
    .accessibilityInputLabels(["Compose", "New Message", "Write"])
```

Check a screen with "Show names" and "Show numbers": every tappable element shows one. Controls revealed by swipe or hover need an action that "Show actions for" can reach. Dictate and edit text in every custom field with "Select" and "Delete that".

## Switch Control

Switch Control moves through the same elements and actions as VoiceOver, so a screen that passes the VoiceOver walk mostly passes here. Check two things beyond it. Every timed element can be paused or extended, since scanning takes time. Every gesture-only action appears in the actions menu.

## Keyboards

On iPad with a hardware keyboard, and on either device with Full Keyboard Access, every control must be reachable and operable from the keyboard.

- System controls are focusable on their own. Build a custom control as a `Button` with a custom `ButtonStyle`, which keeps focus and activation. Otherwise make it focusable with `.focusable(_:interactions:)` and handle activation yourself.
- Never ship `.focusEffectDisabled()` without drawing a visible focus state from `@FocusState`.
- Primary and cancel actions take `.keyboardShortcut(.defaultAction)` and `.keyboardShortcut(.cancelAction)`, so Return and Escape work in sheets.
- Frequent commands take shortcuts with the system's conventions, such as Command-N for new. Never override a system shortcut.
