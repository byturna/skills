# Cheat sheet

Every motion API this skill names, with its UIKit equivalent. Match whichever the view under review is written in.

## Animating

| Need | SwiftUI | UIKit |
| --- | --- | --- |
| Spring | `withAnimation(.smooth)`, `.spring(duration:bounce:)` | `UIView.animate(springDuration:bounce:initialSpringVelocity:delay:options:animations:completion:)` |
| Spring from response and damping | `.spring(response:dampingFraction:)` | `UIView.animate(withDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:)` |
| Spring carrying a gesture's velocity | `.interpolatingSpring(duration:bounce:initialVelocity:)` | The `initialSpringVelocity` parameter |
| Pause, scrub or reverse mid-flight | No direct equivalent | `UIViewPropertyAnimator` |
| Timing curve | `.easeOut(duration:)`, `.linear(duration:)` | `UIView.animate(withDuration:delay:options:animations:completion:)` with `.curveEaseOut` or `.curveLinear` |
| Animate one change only | `withAnimation`, `.animation(_:value:)` | The `animations` closure |
| Make a change instant | `Transaction.disablesAnimations` with `withTransaction` | `UIView.performWithoutAnimation(_:)` |
| Run code when it finishes | `withAnimation(_:completionCriteria:_:completion:)` | The `completion` closure |
| Keyframes | `keyframeAnimator` | `UIView.animateKeyframes(withDuration:delay:options:animations:completion:)` |

## Transitions

| Need | SwiftUI | UIKit |
| --- | --- | --- |
| Insertion and removal | `.transition(_:)` | `UIView.transition(with:duration:options:animations:completion:)` |
| Zoom from the tapped item | `.navigationTransition(.zoom(sourceID:in:))` with `.matchedTransitionSource(id:in:)` | `preferredTransition = .zoom(options:sourceViewProvider:)` |
| Sheet with detents | `.sheet` with `.presentationDetents` | `sheetPresentationController` with `detents` |
| Element moving between layouts | `matchedGeometryEffect` | Animate the frame between the two positions |
| Number roll | `.contentTransition(.numericText(value:))` | No direct equivalent |

## Symbols

| Need | SwiftUI | UIKit |
| --- | --- | --- |
| One-time effect | `.symbolEffect(.bounce, value:)` | `imageView.addSymbolEffect(.bounce)` |
| Repeating effect | `.symbolEffect(.pulse, isActive:)` | `imageView.addSymbolEffect(.pulse)`, then `removeSymbolEffect(ofType:)` |
| Replace a symbol | `.contentTransition(.symbolEffect(.replace))` | `imageView.setSymbolImage(_:contentTransition:)` |

## Gestures and scrolling

| Need | SwiftUI | UIKit |
| --- | --- | --- |
| Drag | `DragGesture` | `UIPanGestureRecognizer` |
| Release velocity | `DragGesture.Value.velocity` | `velocity(in:)` |
| Projected end | `DragGesture.Value.predictedEndTranslation` | Compute it from the velocity |
| Long press with progress | `onLongPressGesture(minimumDuration:perform:onPressingChanged:)` | `UILongPressGestureRecognizer` |
| Effect from scroll position | `.scrollTransition`, `.visualEffect` | `scrollViewDidScroll(_:)` |
| Act at a scroll threshold | `onScrollGeometryChange(for:of:action:)` | `scrollViewDidScroll(_:)` with a stored flag |
| Frame clock | `TimelineView(.animation)` | `CADisplayLink` |

## Haptics and settings

| Need | SwiftUI | UIKit |
| --- | --- | --- |
| Selection | `.sensoryFeedback(.selection, trigger:)` | `UISelectionFeedbackGenerator` |
| Impact | `.sensoryFeedback(.impact(weight:), trigger:)` | `UIImpactFeedbackGenerator` |
| Outcome | `.sensoryFeedback(.success, trigger:)` | `UINotificationFeedbackGenerator` |
| Custom pattern | Core Haptics | Core Haptics |
| Reduce Motion | `@Environment(\.accessibilityReduceMotion)` | `UIAccessibility.isReduceMotionEnabled` |
