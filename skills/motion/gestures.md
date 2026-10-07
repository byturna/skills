# Gestures

Dragging, flicking and holding, built so the motion continues the finger's. Every gesture also needs a path without it, which `accessibility` owns.

## The system gesture first

| Want | Use |
| --- | --- |
| A panel the user drags down to dismiss | `.sheet` with detents |
| Actions revealed by swiping a row | `.swipeActions` |
| Reordering a list | `List` with `.onMove` |
| Paging or snapping through content | `ScrollView` with `.scrollTargetBehavior` |
| Pull to refresh | `.refreshable` |

Build a gesture yourself only for an interaction that is part of the screen itself, such as a card dragged between two resting positions.

## Track, project and settle

While the finger is down, the view follows it with no animation, measured from where it was grabbed. On release, project where the flick was heading, pick the nearest resting point and spring there with the finger's velocity:

```swift
struct DraggableCard: View {
    let restingPoints: [CGFloat] = [0, 400]
    @State private var offset: CGFloat = 0
    @State private var offsetAtGrab: CGFloat?

    var body: some View {
        CardContent()
            .offset(y: offset)
            .gesture(
                DragGesture(minimumDistance: 10)
                    .onChanged { value in
                        let start = offsetAtGrab ?? offset
                        offsetAtGrab = start
                        offset = start + value.translation.height
                    }
                    .onEnded { value in
                        let start = offsetAtGrab ?? offset
                        offsetAtGrab = nil
                        let projected = start + value.predictedEndTranslation.height
                        let target = restingPoints.min {
                            abs($0 - projected) < abs($1 - projected)
                        } ?? 0
                        let remaining = target - offset
                        let relativeVelocity = remaining == 0 ? 0 : value.velocity.height / remaining
                        withAnimation(.interpolatingSpring(
                            duration: 0.4, bounce: 0.2, initialVelocity: relativeVelocity
                        )) {
                            offset = target
                        }
                    }
            )
    }
}
```

What each part does:

- **`minimumDistance: 10`** waits for intent, so a tap or a vertical scroll is not taken for a drag.
- **`offsetAtGrab`** keeps the grab point. Snapping the view's center to the finger breaks the illusion of holding it.
- **`predictedEndTranslation`** is where the gesture would come to rest. A fast short flick travels; a slow long drag settles near where it stopped.
- **The relative velocity** is points per second divided by the distance left, the unit `initialVelocity` expects. It removes the seam between letting go and the spring taking over.
- **The bounce of `0.2`** is allowed because the finger threw the card.

SwiftUI has no way to read where an animating view currently is. Grabbing the card mid-spring therefore starts from its target, not from where it appears. Where that jump shows, a UIKit `UIViewPropertyAnimator` can be paused, scrubbed and reversed mid-flight.

## Resist at the edges

Past a boundary, the view keeps following with growing resistance instead of stopping dead:

```swift
func rubberBand(_ overshoot: CGFloat, dimension: CGFloat, constant: CGFloat = 0.55) -> CGFloat {
    (overshoot * dimension * constant) / (dimension + constant * abs(overshoot))
}
```

Apply it to the distance past the boundary and add the result back to the boundary. On release, spring back inside.

## Gestures that compete

A custom horizontal drag inside a vertical `ScrollView` decides its direction before it claims the touch. Check the first movement in `onChanged` and ignore mostly vertical drags. `.simultaneousGesture` lets two gestures run together, and `.highPriorityGesture` lets a gesture win over a child's. Recognize every plausible gesture from the first movement, rather than waiting for one to finish.

## Hold to confirm

For a destructive action where a tap is too easy to fire by accident, the fill is slow and linear while the finger decides, and the release is quick:

```swift
struct HoldToDelete: View {
    let onDelete: () -> Void
    @State private var isHolding = false

    var body: some View {
        Label("Hold to Delete", systemImage: "trash")
            .padding()
            .background {
                GeometryReader { proxy in
                    Rectangle()
                        .fill(Color.red.opacity(0.25))
                        .frame(width: isHolding ? proxy.size.width : 0)
                        .animation(isHolding ? .linear(duration: 1.5) : .easeOut(duration: 0.2), value: isHolding)
                }
            }
            .onLongPressGesture(minimumDuration: 1.5) {
                onDelete()
            } onPressingChanged: { pressing in
                isHolding = pressing
            }
            .accessibilityAddTraits(.isButton)
            .accessibilityAction(named: "Delete", onDelete)
    }
}
```

The accessibility action gives VoiceOver and Voice Control users a way to delete without holding.
