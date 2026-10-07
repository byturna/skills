# Vocabulary

The name for a motion effect someone describes loosely, with the SwiftUI API that produces it. Use these words when asking for or reviewing motion.

## Entering and leaving

| Term | Means | SwiftUI |
| --- | --- | --- |
| Fade | Appears or disappears through opacity | `.transition(.opacity)` |
| Slide | Enters from an edge and leaves by it | `.transition(.move(edge:))` |
| Push | Content replaced in place with a direction | `.transition(.push(from:))` |
| Scale in | Grows from slightly smaller while fading in | `.transition(.scale(0.9).combined(with: .opacity))` |
| Blur replace | Old content blurs out as new content sharpens in | `.transition(.blurReplace)` |
| Asymmetric transition | Enters one way, leaves another | `.asymmetric(insertion:removal:)` |
| Stagger | Several items enter one after another | `.animation(_:value:)` with `.delay` per item |

## Between states

| Term | Means | SwiftUI |
| --- | --- | --- |
| Crossfade | One state fades out as the next fades in, in place | `.contentTransition(.opacity)` |
| Morph | One shape turns into another | `matchedGeometryEffect`, Magic Replace on symbols |
| Shared element transition | An element travels from one layout into another | `matchedGeometryEffect` on one screen; the zoom navigation transition across a push |
| Zoom transition | A screen grows out of the item tapped | `.navigationTransition(.zoom(sourceID:in:))` |
| Number roll | Digits roll to a new value | `.contentTransition(.numericText(value:))` |
| Layout animation | A view animates to its new size and place | `withAnimation` around the change |
| Disclosure | A section expands and collapses | `DisclosureGroup` |

## Feedback

| Term | Means | SwiftUI |
| --- | --- | --- |
| Press feedback | A control dims or scales while touched | System button styles; a custom `ButtonStyle` |
| Hold to confirm | A fill grows while the user holds | `onLongPressGesture(minimumDuration:perform:onPressingChanged:)` |
| Symbol bounce | A symbol jumps once to confirm an event | `.symbolEffect(.bounce, value:)` |
| Wiggle | A symbol shakes to draw attention | `.symbolEffect(.wiggle, value:)` |
| Draw on | A symbol draws itself in | `.symbolEffect(.drawOn, isActive:)` |
| Haptic | A tap felt through the device | `.sensoryFeedback(_:trigger:)` |

## Physics

| Term | Means | SwiftUI |
| --- | --- | --- |
| Spring | Motion driven by physics rather than a fixed curve | `.smooth`, `.snappy`, `.spring(duration:bounce:)` |
| Bounce | How far a spring overshoots before settling | The `bounce` parameter |
| Critically damped | Settles as fast as possible without overshoot | `bounce: 0` |
| Interruptible | Can be redirected mid-flight | Every SwiftUI state animation |
| Velocity hand-off | A released gesture's speed carries into the spring | `.interpolatingSpring(duration:bounce:initialVelocity:)` |
| Momentum projection | Where a flick would come to rest | `DragGesture.Value.predictedEndTranslation` |
| Rubber-banding | Growing resistance past a boundary | Built into `ScrollView`; a function for custom drags |
| Keyframes | Values at fixed points of a timeline | `keyframeAnimator` |
| Phases | A view stepping through a fixed sequence of states | `phaseAnimator` |

## Easing

| Term | Means | SwiftUI |
| --- | --- | --- |
| Ease out | Starts fast, ends slowly; responsive | `.easeOut` |
| Ease in | Starts slowly; feels sluggish on entrances | `.easeIn`, which entrances never use |
| Ease in and out | Slow, fast, slow | `.easeInOut` |
| Linear | Constant speed, for progress and loops | `.linear` |
| Custom curve | A cubic Bézier a design specifies | `.timingCurve(_:_:_:_:duration:)` |

## Ongoing motion

| Term | Means | SwiftUI |
| --- | --- | --- |
| Pulse | A symbol's opacity rises and falls | `.symbolEffect(.pulse, isActive:)` |
| Breathe | A symbol grows and fades gently | `.symbolEffect(.breathe, isActive:)` |
| Variable color | A symbol's layers light up in sequence | `.symbolEffect(.variableColor, isActive:)` |
| Loop | An animation that repeats | `.repeatForever(autoreverses:)` |
| Scroll-driven effect | A change tied to scroll position | `.scrollTransition`, `.visualEffect` |
| Skeleton | A placeholder shown while content loads | `.redacted(reason: .placeholder)` |
