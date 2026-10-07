# Springs and timing

Which spring or curve to use, how long it runs and how to keep an animation scoped to the change it belongs to.

## Spring presets

| Preset | Character | Use for |
| --- | --- | --- |
| `.smooth` | No bounce | The default for movement, resizing and layout changes |
| `.snappy` | A small bounce, feels quicker | Small responsive changes, such as a selection indicator |
| `.bouncy` | A larger bounce | Only after a flick, or a rare playful moment |
| `.interactiveSpring` | Short | Values catching up with a finger during a gesture |

Each preset takes a `duration`, `0.5` seconds by default, and an `extraBounce`, `0` by default. A spring's duration is perceptual: the motion looks finished by then, though it settles a little after.

```swift
withAnimation(.smooth) {
    isExpanded.toggle()
}
```

## Custom springs

`.spring(duration:bounce:)` takes the same two parameters as the presets. A bounce of `0` settles without overshoot, positive values overshoot more and negative values settle more slowly than critical damping.

Apple's design talks describe springs by response and damping ratio instead. `.spring(response:dampingFraction:)` takes those directly:

| Interaction | SwiftUI |
| --- | --- |
| Moving or repositioning | `.spring(response: 0.4, dampingFraction: 1)` |
| Rotation | `.spring(response: 0.4, dampingFraction: 0.8)` |
| A drawer or panel thrown by a gesture | `.spring(response: 0.3, dampingFraction: 0.8)` |

These values come from Apple's Designing Fluid Interfaces talk. A damping fraction below `1` overshoots, so it belongs only where a gesture carried momentum into the motion. A panel that opens on a tap settles without overshoot.

## Timing curves

Springs move things. Curves suit changes that do not travel:

| Change | Curve |
| --- | --- |
| Opacity or color appearing or disappearing | `.easeOut` |
| Progress, spinners, marquees and other constant motion | `.linear` |
| An entrance | Never `.easeIn`, which starts slowly at the moment people are watching |

`.timingCurve(_:_:_:_:duration:)` exists for a curve a design specifies. Use it only then, never to recreate a spring.

## Durations

These are starting points, not rules. Adjust by eye on a device.

| Change | Start at |
| --- | --- |
| A small fade | `.easeOut(duration: 0.2)` |
| A toggle-sized state change | `.snappy(duration: 0.3)` |
| A panel, card or overlay | `.smooth`, at its default 0.5 seconds |
| A system presentation | Leave it alone |

The more often something animates, the shorter and quieter it should be. Removal runs shorter than insertion.

## Scoping

Animate the change, not the view:

```swift
// Good: only this change animates
withAnimation(.snappy) {
    selection = filter
}

// Good: this view animates when this value changes
Chevron()
    .rotationEffect(.degrees(isExpanded ? 90 : 0))
    .animation(.snappy, value: isExpanded)

// Bad: every change to this view animates, including ones nobody meant to
Chevron()
    .rotationEffect(.degrees(isExpanded ? 90 : 0))
    .animation(.snappy)
```

To make one change instant inside an animated context, disable animations for its transaction:

```swift
var transaction = Transaction()
transaction.disablesAnimations = true
withTransaction(transaction) {
    selection = newValue
}
```

To run code when an animation finishes, pass a completion:

```swift
withAnimation(.smooth) {
    isOpen = true
} completion: {
    hasFinishedOpening = true
}
```
