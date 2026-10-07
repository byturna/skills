# Edges

Safe areas, actions pinned to the bottom of a screen and the keyboard.

## Safe areas

```swift
// Good: the background fills the screen, the content stays in the safe area
ScrollView {
    ProfileContent(profile: profile)
}
.background {
    ProfileBackdrop(profile: profile)
        .ignoresSafeArea()
}

// Bad: the whole screen leaves the safe area, controls and text with it
VStack {
    ProfileHeader(profile: profile)
    FollowButton(profile: profile)
}
.ignoresSafeArea()
```

`.background` with a color or a material already extends under the safe areas, so it needs no modifier. A view background, as above, takes `.ignoresSafeArea()` itself.

| Need | Use |
| --- | --- |
| Inset content and count it as safe area | `.safeAreaPadding(_:_:)` |
| Inset the content of a scroll view, not its indicators | `.contentMargins(_:_:for:)` with `.scrollContent` |
| Extend only past the keyboard or the container | `.ignoresSafeArea(.keyboard)` or `.container`, on a background |

## Pinned actions

```swift
// Good: the bar sits in the safe area, above the home indicator and the keyboard
ScrollView {
    CartItems(cart: cart)
}
.safeAreaBar(edge: .bottom) {
    Button(action: checkOut) {
        Text("Check Out")
            .frame(maxWidth: .infinity)
    }
    .buttonStyle(.glassProminent)
    .controlSize(.large)
    .padding()
}

// Bad: the button floats over the last items and guesses the home indicator's height
ZStack(alignment: .bottom) {
    ScrollView {
        CartItems(cart: cart)
    }
    Button("Check Out", action: checkOut)
        .padding(.bottom, 34)
}
```

The scroll view's content stops above the bar, so its last item stays reachable.

## The keyboard

```swift
Form {
    TextField("Title", text: $title)
    TextField("Note", text: $note, axis: .vertical)
}
.scrollDismissesKeyboard(.interactively)
.toolbar {
    ToolbarItemGroup(placement: .keyboard) {
        Button("Checklist", systemImage: "checklist", action: insertChecklist)
    }
}
```

Controls in the keyboard toolbar act on the text being typed. Anything else stays in the screen's own toolbar. Field order, submit labels and keyboard types belong to `accessibility`.
