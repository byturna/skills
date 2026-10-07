---
name: motion
description: Decides whether something in a SwiftUI or UIKit app should animate, then builds it with system transitions, springs, symbol effects, gestures and haptics that feel native.
---

# Motion

This skill decides whether something on an iOS screen should move and, if it should, how. It picks the system transition, the spring, the gesture hand-off and the haptic, and writes them in SwiftUI.

Whether motion is required under Reduce Motion belongs to `accessibility`. Which presentation a flow uses belongs to `layout`. Materials, Liquid Glass and which symbol to use belong to `ui`. The UIKit form of every API here is in [cheat-sheet.md](cheat-sheet.md), and the names for effects are in [vocabulary.md](vocabulary.md).

## Restraint first, then exact values

Most motion on iOS is the system's: navigation pushes, sheets, menus, alerts, swipe actions, list insertions and the keyboard. The best custom animation is often none.

A finding is motion that:
- runs on a frequent interaction;
- rebuilds or retimes a system transition;
- blocks input or cannot be interrupted;
- has no purpose, or carries meaning on its own;
- ignores Reduce Motion;
- plays a haptic against its meaning or on every frame.

The spring presets, the symbol effects and the haptic meanings are exact. Durations, stagger and press scale are starting points. How bouncy something feels beyond them is a preference, not a finding.

## Decide whether it moves at all

Match the motion to how often people see it:

| Frequency | Example | Motion |
| --- | --- | --- |
| Constantly, many times a minute | Typing, keyboard shortcuts on iPad, switching tabs, scrolling | None beyond the system's |
| Many times a day | Toggling, selecting a row, pressing a button | The system's feedback, or a short subtle change |
| Occasionally | Opening a sheet, adding an item, a toast | A standard transition |
| Rarely or once | Onboarding, a first success, an empty state | Room for delight |

Then name the purpose: feedback, spatial continuity, a state change made legible, or bridging content that would otherwise jump. Explanation and delight are allowed only at the rare end. A change without a purpose is instant.

## System transitions first

Push with `NavigationStack`, present with `.sheet` and `.presentationDetents`, cover with `.fullScreenCover` and use `Menu`, `.contextMenu`, `.popover`, `.swipeActions` and `.refreshable` as they come. Tabs switch without a custom transition. These carry the interactive back swipe, Reduce Motion, VoiceOver and the timing people know from every other app.

A screen that should grow out of the item that opened it takes `.navigationTransition(.zoom(sourceID:in:))` with `.matchedTransitionSource`. Never rebuild a push, sheet or tab transition by hand. The full table is in [transitions.md](transitions.md#system-transitions).

## Springs for movement, curves for fades

Anything that moves, scales or resizes uses a spring: `.smooth` by default and `.snappy` where the change should feel quicker. Bounce is `0` unless a gesture handed the motion its momentum, as when a card is flicked away.

Opacity and color changes may use `.easeOut`. Progress and other constant motion use `.linear`. An entrance never uses `.easeIn`, because it starts slowly at the moment people are watching. Values and the mapping from response and damping are in [springs-and-timing.md](springs-and-timing.md).

## Never make people wait for motion

SwiftUI animations retarget from their current state, so a second tap mid-animation reverses it smoothly. Keep it that way: never disable a control or ignore input while an animation plays.

`keyframeAnimator` and `phaseAnimator` run a fixed timeline, so reserve them for sequences that play once or loop decoratively. They never drive a state the user can toggle back.

## Scope every animation to its change

Animate a state change with `withAnimation` around the mutation, or with `.animation(_:value:)` on the view that should move. `.animation(_:)` without a value animates every change in the view, which is SwiftUI's `transition: all`. Never put an animation on a parent to move one child.

To make one change instant inside an animated context, set `disablesAnimations` on the transaction. See [springs-and-timing.md](springs-and-timing.md#scoping).

## Enter and leave along one path

A view leaves the way it arrived. A panel sliding up from the bottom dismisses downwards, never sideways. Never scale from `0`: start at `0.9` or above, combined with opacity. Anchor the scale at the element's source, such as `.topTrailing` for a panel opened from a button in that corner.

Removal is faster and smaller than insertion. Make it so on purpose with `.asymmetric(insertion:removal:)`, not by accident. Recipes are in [transitions.md](transitions.md#insertion-and-removal).

## Morph what stays the same thing

When one element changes place or form, animate it as one element, never as a fade between two:

- `matchedGeometryEffect` within one screen;
- the zoom navigation transition across a push;
- `.contentTransition(.numericText(value:))` for a changing number;
- `.contentTransition(.symbolEffect(.replace))` for a symbol swap.

See [transitions.md](transitions.md#continuity).

## Symbols move with symbol effects

SF Symbols animate through `.symbolEffect`, never through hand-built scale and blur. A discrete effect such as `.bounce` confirms one event. An indefinite effect such as `.pulse`, `.variableColor`, `.breathe` or `.rotate` shows ongoing activity and stops when the activity does. `.wiggle` draws attention once, and `.drawOn` reveals a symbol.

Use them sparingly and for a reason; a screen of moving symbols is noise. The table of effects and meanings is in [transitions.md](transitions.md#symbol-effects).

## Press feedback belongs to the button style

System button styles, list rows, `.glass` and `.glassProminent` already respond to a press. A scale added on top doubles the feedback.

Only a custom `ButtonStyle` adds its own: scale to `0.97` while `configuration.isPressed`, use one value for the whole project and never scale while disabled. The recipe is in [transitions.md](transitions.md#press-feedback).

## Gestures track the finger and keep its velocity

While a finger is down, the view follows it one to one with no animation, from the point it was grabbed. On release, project where the gesture was heading with `predictedEndTranslation`. Pick the nearest resting point, then spring there with the gesture's velocity, so release has no seam.

Past a boundary, resist progressively rather than stopping dead. Before building any of this, check whether a sheet, a scroll view or swipe actions already do it. Recipes are in [gestures.md](gestures.md).

## Scroll-driven effects stay off the state path

An effect that follows scrolling uses `.scrollTransition` or `.visualEffect`, which update each frame without re-running `body`. Never write `@State` every frame from a scroll or geometry callback. To act when scrolling crosses a point, use `onScrollGeometryChange` with a `Bool` transform, so the action runs only at the crossing. See [performance.md](performance.md).

## Haptics confirm a cause

Play a haptic on the frame of the event that causes it, and pair it with a visual change:

- `.selection` while a value steps;
- `.impact` when something snaps or lands;
- `.success`, `.warning` or `.error` for an outcome.

Use each pattern only for its documented meaning. One action plays one haptic: never on scroll, never per frame and never on an entrance the user did not cause. Toggles, sliders and pickers already play their own. See [haptics.md](haptics.md).

## Reduce Motion swaps movement for fades

Read `@Environment(\.accessibilityReduceMotion)`. Under it, a moving or scaling transition becomes `.opacity`, springs lose their bounce and decorative loops and indefinite symbol effects stop. Motion that tracks a finger stays. The table of what to disable, replace and keep is `accessibility`'s.

## Stagger and delight only where they are rare

A staged entrance, a celebratory bounce or a playful spring belongs to onboarding, a first success or an empty state. Stagger items `0.05`s apart, one value for the project, and never block interaction while it plays. Never stage the content of a screen that arrives through a push, since it fights the system transition. See [transitions.md](transitions.md#staged-entrances).

## Before you finish

| Pattern | Fix |
| --- | --- |
| `.animation(.default)` or any `.animation(_:)` with no `value:` | `.animation(_:value:)` or `withAnimation` |
| A `DragGesture` or `.offset` rebuilding a sheet, push or tab transition | The system presentation |
| `.easeIn` on an insertion | `.smooth`, or `.easeOut` for a fade |
| `.scale` transition with no scale argument, or `.scaleEffect(0)` in an entrance | `.scale(0.9)` combined with `.opacity` |
| `.bouncy` or `bounce:` above `0` on UI that no gesture flung | `.smooth` |
| `.scaleEffect` tied to a press on a `Button` with a system style | Remove it |
| `.disabled(isAnimating)` or a flag that ignores taps until an animation ends | Remove it; let the animation retarget |
| `keyframeAnimator` or `phaseAnimator` driving a toggled state | A spring on the state change |
| Hand-built scale and blur on an `Image(systemName:)` swap | `.contentTransition(.symbolEffect(.replace))` |
| `@State` written inside `onScrollGeometryChange` or `onGeometryChange` every frame | `.scrollTransition`, `.visualEffect` or a `Bool` transform |
| `.repeatForever` or an indefinite `.symbolEffect` with no condition that stops it | Tie it to the activity, and stop it under Reduce Motion |
| A move, offset or scale transition with no `accessibilityReduceMotion` branch | `.opacity` under Reduce Motion |
| `.sensoryFeedback` on a value that changes continuously, such as a scroll offset | Trigger on a discrete step or the commit |
| `.sensoryFeedback(.success, …)` for something that is not an outcome | The pattern that matches the meaning |
| `onAppear { withAnimation { … } }` on ordinary content | Show it; animate only real changes |

## Reporting

**Severity.** `HIGH` blocks or misleads: motion that cannot be interrupted, a rebuilt system transition that breaks the back swipe, or meaning carried by motion or haptics alone. Two of `design-review`'s escalation triggers land here and are `HIGH` on sight. One is motion that ignores Reduce Motion, and the other is a state change carried by motion or haptics alone. `MEDIUM` is motion on a frequent interaction, a wrong curve on a visible transition or a misused haptic. `LOW` is isolated tuning.

**Verification.** Without Xcode, read every `withAnimation`, `.animation`, `.transition`, `.symbolEffect`, gesture and `.sensoryFeedback` in scope against the rules above. With Xcode, replay each animation with Debug > Slow Animations in the Simulator and interrupt it mid-flight. Toggle Reduce Motion through Environment Overrides. Haptics, ProMotion frame rates and gesture feel need a device. Report every check you could not run as `Not verified`.

**Format.** Group findings under the principle each violates, ordered by severity, one row per root cause listing every location it appears in:

| Severity | Location | Before | After | Why |
| --- | --- | --- | --- | --- |

`Location` is `path/to/file.swift:line`. `Why` names the principle and the user impact.

End with `Block` when any `HIGH` remains, `Approve` otherwise, leaving the rest in the table as work to do. Never `Approve` coverage you did not inspect. With nothing to report, state "No actionable motion findings" and report verification.
