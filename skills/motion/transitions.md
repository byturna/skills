# Transitions

The system transitions to use before building any, how views enter and leave, how one element morphs and how symbols animate.

## System transitions

Each of these brings its own motion, its interactive gestures and its Reduce Motion behavior. Never rebuild one. Which presentation a flow needs is `navigation`'s, and the animation comes with it.

| Change | Use |
| --- | --- |
| Going deeper into a hierarchy | A `NavigationStack` push |
| A screen that grows out of the item tapped | `.navigationTransition(.zoom(sourceID:in:))` with `.matchedTransitionSource(id:in:)` |
| A short task or a picker | `.sheet` with `.presentationDetents` |
| A self-contained task | `.sheet`, or `.fullScreenCover` where nothing behind it matters |
| Options anchored to a control | `Menu`, or `.popover` on iPad |
| Long-press options with a preview | `.contextMenu(menuItems:preview:)` |
| Actions on a row | `.swipeActions` |
| Refreshing | `.refreshable` |
| Switching tabs | `TabView`, with no transition of your own |

The zoom transition needs the source and the destination to share an identifier and a namespace:

```swift
struct PhotoGrid: View {
    @Namespace private var namespace
    let photos: [Photo]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                    ForEach(photos) { photo in
                        NavigationLink(value: photo) {
                            PhotoThumbnail(photo: photo)
                                .matchedTransitionSource(id: photo.id, in: namespace)
                        }
                    }
                }
            }
            .navigationDestination(for: Photo.self) { photo in
                PhotoDetail(photo: photo)
                    .navigationTransition(.zoom(sourceID: photo.id, in: namespace))
            }
        }
    }
}
```

## Insertion and removal

A view that appears or disappears with state takes a transition, and the state change takes the animation:

```swift
if isShowingBanner {
    Banner()
        .transition(.move(edge: .top).combined(with: .opacity))
}

// Elsewhere
withAnimation(.smooth) {
    isShowingBanner = true
}
```

| Transition | Use for |
| --- | --- |
| `.opacity` | The default, and the replacement for movement under Reduce Motion |
| `.move(edge:)` | Something arriving from an edge and leaving by the same edge |
| `.push(from:)` | Content replaced in place with a direction, such as the next step of a flow |
| `.scale(0.9, anchor:)` combined with `.opacity` | Something appearing out of its source |
| `.blurReplace` | Content swapped in place, such as a non-symbol image |

Anchor a scale at the element's source, so it grows out of what opened it:

```swift
OptionsPanel()
    .transition(.scale(0.9, anchor: .topTrailing).combined(with: .opacity))
```

Removal is shorter and quieter than insertion. Make the difference explicit:

```swift
Toast()
    .transition(.asymmetric(
        insertion: AnyTransition.move(edge: .bottom).combined(with: .opacity),
        removal: AnyTransition.opacity.animation(.easeOut(duration: 0.15))
    ))
```

SwiftUI animates changes, not the first frame. Content that is simply there when a screen opens needs no animation. Wrapping its initial state in `onAppear { withAnimation { … } }` makes every visit slower.

Switching between light and dark appearance is not animated, so there is nothing to suppress.

## Continuity

When one element moves or changes form, animate it as one element. Before building a sliding selection indicator, check whether `Picker` with `.pickerStyle(.segmented)` already does the job. Where a custom one is needed:

```swift
struct FilterBar: View {
    @Namespace private var namespace
    @State private var selection: Filter = .all

    var body: some View {
        HStack {
            ForEach(Filter.allCases) { filter in
                Button(filter.title) {
                    withAnimation(.snappy) { selection = filter }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background {
                    if selection == filter {
                        Capsule()
                            .fill(Color.secondary.opacity(0.2))
                            .matchedGeometryEffect(id: "selection", in: namespace)
                    }
                }
            }
        }
    }
}
```

A number that changes rolls its digits rather than fading:

```swift
Text(score, format: .number)
    .monospacedDigit()
    .contentTransition(.numericText(value: Double(score)))
    .animation(.snappy, value: score)
```

Glass shapes that merge and split are `ui`'s, through `glassEffectID`.

## Symbol effects

| Effect | Kind | Use for |
| --- | --- | --- |
| `.bounce` | Plays once | Confirming an event, such as an item added |
| `.wiggle` | Plays once | Drawing attention to something easy to miss |
| `.scale` | Holds | Emphasizing a selected symbol until it is deselected |
| `.pulse` | Repeats | Ongoing activity, such as connecting |
| `.variableColor` | Repeats | Activity with a direction, such as playback or broadcasting |
| `.breathe` | Repeats | A living state, such as an ongoing recording |
| `.rotate` | Repeats | Work in progress, or an object that spins |
| `.appear`, `.disappear` | Transition | Showing or hiding a symbol |
| `.drawOn`, `.drawOff` | Transition | Drawing a symbol in or out, such as a checkmark or a download arrow |
| `.replace` | Content transition | Swapping one symbol for another; related shapes get Magic Replace |

A one-time effect plays when a value changes. A repeating effect runs while a condition holds and stops with the activity:

```swift
Image(systemName: "bell")
    .symbolEffect(.bounce, value: notificationCount)

Image(systemName: "wifi")
    .symbolEffect(.variableColor.iterative, isActive: isConnecting)

Button {
    withAnimation { isPlaying.toggle() }
} label: {
    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
        .contentTransition(.symbolEffect(.replace))
}
.accessibilityLabel(isPlaying ? "Pause" : "Play")
```

## Press feedback

System button styles respond to a press on their own. Only a custom `ButtonStyle` adds feedback, and it uses one value across the project:

```swift
struct PressableStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed && isEnabled ? 0.97 : 1)
            .animation(.snappy(duration: 0.15), value: configuration.isPressed)
    }
}
```

## Staged entrances

Only for rare moments, such as an onboarding page or a first success. Each item enters `0.05` seconds after the one before, and the content stays usable while it plays:

```swift
struct OnboardingPage: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isVisible = false
    let lines: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(Array(lines.enumerated()), id: \.offset) { index, line in
                Text(line)
                    .opacity(isVisible ? 1 : 0)
                    .offset(y: isVisible || reduceMotion ? 0 : 12)
                    .animation(.smooth.delay(Double(index) * 0.05), value: isVisible)
            }
        }
        .onAppear { isVisible = true }
    }
}
```

## Widgets and Live Activities

A score that changes between timeline entries rolls its digits:

```swift
Text(entry.score, format: .number)
    .monospacedDigit()
    .contentTransition(.numericText(value: Double(entry.score)))
```
