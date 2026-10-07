# Mirroring

What mirrors in right-to-left on its own, what does not and which arrangements keep their direction.

## What mirrors

| Mirrors on its own | Does not |
| --- | --- |
| `HStack`, `LazyHStack`, `Grid` and their spacing | `.offset(x:)` and `.position(x:y:)` |
| `.leading` and `.trailing` alignment and padding | Arithmetic on a `GeometryProxy` frame |
| `.overlay(alignment: .topTrailing)` and other aligned overlays | `Path`, `Canvas` and custom `Shape` drawing |
| `Slider`, `ProgressView`, `Gauge` and system bars | `.scaleEffect(x: -1)` and `.rotationEffect` |
| `leadingAnchor` and `NSDirectionalEdgeInsets` in UIKit | `leftAnchor`, `rightAnchor` and left and right `UIEdgeInsets` |

```swift
// Good: the badge follows the trailing edge in both directions
Image(systemName: "bell")
    .overlay(alignment: .topTrailing) {
        UnreadBadge(count: unreadCount)
    }

// Bad: a physical offset stays to the right in right-to-left
Image(systemName: "bell")
    .overlay {
        UnreadBadge(count: unreadCount)
            .offset(x: 12, y: -8)
    }
```

Never force `.environment(\.layoutDirection, .leftToRight)` on a screen to make it look right. It hides the bug from everyone who reads right to left.

## What keeps its direction

| Arrangement | In right-to-left |
| --- | --- |
| Progress, sliders, ratings and steps | Run from the leading edge, which is the right |
| Back and forward, previous and next | Swap, so back points right |
| A control that names a real direction, such as "move right" | Keeps its direction |
| Playback controls and scrubbers | Keep left to right |

A row of playback controls keeps its order. In UIKit, set `semanticContentAttribute` to `.playback` on the container. In SwiftUI, set `.environment(\.layoutDirection, .leftToRight)` on that row alone.

## Testing

Run the scheme with App Language set to the right-to-left pseudolanguage, or preview with `.environment(\.layoutDirection, .rightToLeft)`. Check every screen with real content, not only empty states.
