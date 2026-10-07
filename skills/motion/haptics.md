# Haptics

Which haptic means what, when to play it and when to stay silent.

## Patterns and their meanings

iOS haptics come in three families: selection, impact and notification. Use each only for its documented meaning, so people learn what each one means.

| Moment | SwiftUI | UIKit |
| --- | --- | --- |
| A value steps through choices, as in a custom picker or slider detent | `.sensoryFeedback(.selection, trigger: value)` | `UISelectionFeedbackGenerator` |
| Something snaps into place or lands | `.sensoryFeedback(.impact(weight: .light), trigger: value)` | `UIImpactFeedbackGenerator(style: .light)` |
| A heavier object lands or collides | `.impact(weight: .medium)` or `.heavy` | `UIImpactFeedbackGenerator(style: .medium)` or `.heavy` |
| A task succeeded | `.success` | `UINotificationFeedbackGenerator` with `.success` |
| A task needs attention | `.warning` | `UINotificationFeedbackGenerator` with `.warning` |
| A task failed | `.error` | `UINotificationFeedbackGenerator` with `.error` |
| A value rises or falls past a meaningful level | `.increase` or `.decrease` | |
| An activity the user controls starts or stops | `.start` or `.stop` | |
| Something dragged lines up with a guide | `.alignment` | |

```swift
CustomDial(value: $temperature)
    .sensoryFeedback(.selection, trigger: temperature)

SaveButton(state: saveState)
    .sensoryFeedback(.success, trigger: saveState) { _, newState in
        newState == .saved
    }
```

The condition closure plays the haptic only for the change that matters, here the save completing, not every state change on the way.

## When to play one

- **On the frame of the cause.** A haptic that lags its visual reads as a glitch. Play it when the detent catches or the save completes, not when the animation finishes.
- **With a visual, never alone.** Haptics are off for many people, and `accessibility` requires another cue.
- **One per action.** Never on scroll, never per frame and never on an entrance the user did not cause.
- **Short, for discrete events.** In an app, a long-running haptic dilutes its meaning.
- **Matched in strength.** A light impact goes with a small, quick animation and a heavy one with a large landing.

System controls play their own haptics, from toggles, sliders and pickers to swipe actions and context menus. Apple documents the first three, and the rest do so in practice. Adding a second haptic to any of them doubles the feedback.

## Custom haptics

Core Haptics builds patterns from short taps and sustained vibrations, each with an intensity and a sharpness. Apps rarely need it; games and signature interactions do.

An app that plays many custom haptics offers a setting to turn them off, and stays fully usable without them. Avoid haptics while the camera, microphone or gyroscope is in use, since the vibration can disturb them.
