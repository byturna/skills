# Motion and media

What Reduce Motion requires, and how timed and playing content stays under the user's control. Animation recipes belong to `motion`.

## Reduce Motion

Read the setting from the environment. System navigation, sheets and alerts adapt on their own; anything the app animates itself does not.

```swift
@Environment(\.accessibilityReduceMotion) private var reduceMotion

DetailPanel()
    .transition(reduceMotion
        ? AnyTransition.opacity
        : AnyTransition.move(edge: .bottom).combined(with: .opacity))
```

Reduce Motion targets motion triggers, not feedback. Remove what only decorates, re-express what carries meaning as a dissolve and leave the rest:

| Disable | Replace with a fade, highlight or color shift | Keep |
| --- | --- | --- |
| Parallax and depth simulation | Slides along x, y or z | Progress indicators |
| Animated blur and depth of field | Scaling and zooming | Color and opacity changes |
| Spinning, vortex and multi-axis motion | Hierarchy transitions the app animates itself | Motion that tracks a finger 1:1 |
| Auto-advancing carousels and other ongoing motion | Springs with bounce, tightened so nothing overshoots | Brief feedback such as a highlight |

A status change animated for meaning, such as an item flying to the cart, keeps a replacement that says the same thing without travel. Never remove such an animation outright.

## Timers and media

- **Nothing the user needs disappears on a timer.** A banner carrying an action or an error stays until dismissed. Prefer dismissing with an explicit action everywhere.
- **Anything moving on its own can be stopped.** An auto-advancing carousel, a looping hero video or an animated illustration shows a visible pause control, and stops under Reduce Motion.
- **Animated images respect the setting.** Check `accessibilityPlayAnimatedImages` before autoplaying GIFs and image sequences.
- **No autoplay with sound.** Audio and video start on the user's action and show their controls.
- **Flashing video respects Dim Flashing Lights.** If the app plays video, check `accessibilityDimFlashingLights`.
- **Video ships with captions and audio descriptions.** The system players, `VideoPlayer` and `AVPlayerViewController`, expose the tracks the media carries.
- **Audio cues have a visual or haptic twin.** A success chime pairs with a visible state and, where it fits, a haptic. The haptic itself belongs to `motion`.
