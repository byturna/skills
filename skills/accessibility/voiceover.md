# VoiceOver

Labels, traits, grouping, actions, modality and announcements, with the SwiftUI recipe for each. UIKit equivalents are in [cheat-sheet.md](cheat-sheet.md).

## Labels, values and hints

VoiceOver speaks an element as label, value, trait, then hint after a pause. Each part has one job:

| Part | Carries | Example |
| --- | --- | --- |
| Label | What the element is, concisely | "New Message" |
| Value | Its current content or setting | "On", "3 of 5 stars", the text in a field |
| Trait | Its type and state | Button, header, selected |
| Hint | The result of activating it, only where the label leaves that unclear | "Plays a preview" |

```swift
// Good: the title stays the accessible name; only the icon shows
Button("New Message", systemImage: "square.and.pencil", action: compose)
    .labelStyle(.iconOnly)

// Bad: no name at all, so VoiceOver guesses one from the symbol
Button(action: compose) {
    Image(systemName: "square.and.pencil")
}
```

Where a label must differ from any visible text, set it with `.accessibilityLabel`. Keep it in sync when the element's state changes, as with a favourite button that toggles between "Add to Favorites" and "Remove from Favorites".

## Custom controls

A custom control is accessible when it says what a system control would. The shortest route is to let a system control speak for it:

```swift
CustomSwitch(isOn: $isOn)
    .accessibilityRepresentation {
        Toggle("Wi-Fi", isOn: $isOn)
    }
```

Where no system control fits, supply each part yourself. A control that adjusts a value takes the adjustable action, so VoiceOver users swipe up and down to change it:

```swift
StarRating(rating: $rating)
    .accessibilityElement()
    .accessibilityLabel("Rating")
    .accessibilityValue("\(rating) of 5")
    .accessibilityAdjustableAction { direction in
        switch direction {
        case .increment: rating = min(rating + 1, 5)
        case .decrement: rating = max(rating - 1, 1)
        @unknown default: break
        }
    }
```

## Images and charts

| Image | Treatment |
| --- | --- |
| Decorative, or repeated by adjacent text | `Image(decorative:)` or `.accessibilityHidden(true)` |
| Informative | A label describing what it conveys, not what it looks like |
| Functional, the image is the button | The button's label names the action |
| User-uploaded | A description field the uploader can fill in, read as the label |
| Chart | A summary label plus the data. Swift Charts provides an audio graph on its own; a custom chart uses `.accessibilityChartDescriptor` |

VoiceOver already reads a nearby caption, so describe only what the image adds to it.

## Grouping and order

A row that sighted users read as one unit is one VoiceOver element. Combine it, and keep any buttons inside it reachable as actions:

```swift
HStack {
    Image(decorative: "avatar")
    VStack(alignment: .leading) {
        Text(message.sender)
        Text(message.preview)
    }
    Text(message.date, format: .dateTime.hour().minute())
}
.accessibilityElement(children: .combine)
```

- `.combine` merges the children's labels into one element.
- `.contain` keeps the children separate but groups them, so VoiceOver moves through the group as a unit.
- `.ignore` replaces the children with whatever label you give the container.

Reading order follows the view hierarchy. A `ZStack`, `.overlay` or `.offset` that moves content visually does not move it for VoiceOver, so fix the hierarchy before reaching for `.accessibilitySortPriority`.

Headings take `.accessibilityAddTraits(.isHeader)` so the rotor's Headings setting can jump between them. Long or structured content, such as a document or a list of mixed item types, gets a custom rotor through `.accessibilityRotor`.

## Actions

Every action available by gesture is also available as an accessibility action. Voice Control shows these with a double chevron, and Switch Control offers them in its menu.

```swift
MessageRow(message: message)
    .accessibilityActions {
        Button("Archive") { archive(message) }
        Button("Delete", role: .destructive) { delete(message) }
    }
```

`.swipeActions` and `.contextMenu` are exposed as actions automatically. A `DragGesture`, `.onLongPressGesture` or a control revealed only on swipe is not. Drag and drop needs a menu or action that moves the item, such as "Move to Top".

## Modality and focus

System presentations make the content behind them unreachable and support the two-finger escape scrub. A custom overlay needs all three of these:

```swift
struct PromoOverlay: View {
    let onClose: () -> Void
    @AccessibilityFocusState private var isTitleFocused: Bool

    var body: some View {
        VStack {
            Text("Upgrade to Pro")
                .accessibilityAddTraits(.isHeader)
                .accessibilityFocused($isTitleFocused)
            Button("Not Now", action: onClose)
        }
        .accessibilityElement(children: .contain)
        .accessibilityAddTraits(.isModal)
        .accessibilityAction(.escape, onClose)
        .onAppear { isTitleFocused = true }
    }
}
```

On dismissal, return focus to the control that opened the overlay. When content changes without navigation, post a notification so VoiceOver re-reads the screen:

| Change | Post |
| --- | --- |
| A new screen's worth of content | `AccessibilityNotification.ScreenChanged(nil).post()` |
| Part of the screen changed | `AccessibilityNotification.LayoutChanged(element).post()`, passing the element to focus |
| Paged content moved | `AccessibilityNotification.PageScrolled` with a description of the new position |

## Announcements

Work down this list and stop at the first match:

1. **Focus moves there anyway**, as with a presented sheet or the first invalid field. The move is the announcement.
2. **The change belongs to one element**, such as a field's error or a counter. Update that element's value or the text directly after it.
3. **Non-urgent and tied to nothing on screen**, such as "Saved" or "Upload complete". Post an announcement at the default priority.
4. **Urgent**, such as a failed payment. Post it at `.high`, which interrupts.

```swift
var announcement = AttributedString("Payment failed. Check your card details.")
announcement.accessibilitySpeechAnnouncementPriority = .high
AccessibilityNotification.Announcement(announcement).post()
```

Keep announcements short and self-contained, since the user cannot re-read them. Never move focus to a banner; announce it and leave focus where the user is working.
