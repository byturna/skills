# Performance

Keeping motion smooth: scroll-driven effects, per-frame work and when to measure.

## Scroll-driven effects

`.scrollTransition` and `.visualEffect` apply an effect from the view's position each frame without re-running `body`:

```swift
ScrollView(.horizontal) {
    LazyHStack {
        ForEach(cards) { card in
            CardView(card: card)
                .scrollTransition { content, phase in
                    content
                        .opacity(phase.isIdentity ? 1 : 0.6)
                        .scaleEffect(phase.isIdentity ? 1 : 0.92)
                }
        }
    }
}
```

Under Reduce Motion, keep the opacity and drop the scale.

To act when scrolling crosses a point, such as showing a compact header, transform the geometry into a `Bool`. The action then runs only when the value flips, not on every frame:

```swift
@State private var isPastHeader = false

ScrollView {
    ArticleBody()
}
.onScrollGeometryChange(for: Bool.self) { geometry in
    geometry.contentOffset.y > 120
} action: { _, isPast in
    isPastHeader = isPast
}
```

Never store the raw scroll offset in `@State` to drive an effect. Every frame then re-runs `body` for everything that reads it. Before building a collapsing header at all, check whether a large navigation title already does the job.

## Per-frame work

- A drag updates state on each change, which is expected. Keep the work in that update small, and keep views that do not depend on the offset out of the view that reads it.
- Continuous custom drawing, such as a clock or a waveform, uses `TimelineView(.animation)` with `Canvas`.
- `.drawingGroup()` and `.compositingGroup()` change how a view renders. Add them only after Instruments shows a hitch they fix.
- Animating a large blur or material every frame is expensive. Cross-fade between a static blurred layer and a sharp one instead.

## Frame rate

On iPhone, an app can request frame rates above the system default only with `CADisableMinimumFrameDurationOnPhone` set to `YES` in `Info.plist`. Set it when the app drives frames itself, as with `CADisplayLink.preferredFrameRateRange`, and confirm the result in Instruments on a ProMotion device.

## Measuring

| Question | Tool |
| --- | --- |
| Does the motion feel right? | Simulator, Debug > Slow Animations, then interrupt it mid-flight |
| Does it hold its frame rate? | Instruments, with the SwiftUI and Animation Hitches templates, on a device |
| Does it feel right in the hand? | A device; gestures, haptics and ProMotion cannot be judged in the Simulator |
