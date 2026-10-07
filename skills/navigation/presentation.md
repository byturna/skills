# Presentation

Choosing a presentation, one at a time, the way out of a sheet, detents, popovers, alerts and dialogs.

## Choosing

| The task | Use |
| --- | --- |
| More detail about something on screen | A push |
| A short task, or input the screen needs | `.sheet` |
| Media, the camera or a long editing task | `.fullScreenCover` |
| A little information or a few options tied to a control, on iPad | `.popover` |
| Options people chose to reveal | `Menu` |
| Choices about an action people started | `.confirmationDialog` |
| A problem or a risk that needs a response | `.alert` |
| Information that needs no response | An inline status, never a modal |

## One at a time

```swift
struct OrderView: View {
    enum Sheet: Identifiable {
        case editAddress, addNote
        var id: Self { self }
    }

    @State private var presentedSheet: Sheet?

    var body: some View {
        OrderSummary()
            .toolbar {
                Button("Edit Address") { presentedSheet = .editAddress }
                Button("Add Note") { presentedSheet = .addNote }
            }
            .sheet(item: $presentedSheet) { sheet in
                switch sheet {
                case .editAddress: AddressEditor()
                case .addNote: NoteEditor()
                }
            }
    }
}
```

A task inside a sheet that needs another screen pushes within the sheet's own `NavigationStack`.

## Ways out

```swift
struct AddressEditor: View {
    @Environment(\.dismiss) private var dismiss
    @State private var draft = AddressDraft()
    @State private var isConfirmingDiscard = false

    var body: some View {
        NavigationStack {
            AddressForm(draft: $draft)
                .navigationTitle("Edit address")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(role: .cancel) {
                            if draft.hasChanges {
                                isConfirmingDiscard = true
                            } else {
                                dismiss()
                            }
                        }
                        .confirmationDialog("Discard your changes?", isPresented: $isConfirmingDiscard) {
                            Button("Discard Changes", role: .destructive) { dismiss() }
                            Button("Keep Editing", role: .cancel) {}
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button(role: .confirm) {
                            draft.save()
                            dismiss()
                        }
                    }
                }
        }
        .interactiveDismissDisabled(draft.hasChanges)
    }
}
```

A sheet that only shows information takes `Button(role: .close)` alone. Close never discards work, and Cancel can.

## Detents

```swift
// Filters show their main options at half height and expand for the rest
.sheet(isPresented: $isShowingFilters) {
    FilterOptions()
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
}

// A palette that acts on the note behind it, which stays usable
.sheet(isPresented: $isShowingFormatting) {
    FormattingPalette()
        .presentationDetents([.medium])
        .presentationBackgroundInteraction(.enabled(upThrough: .medium))
}
```

## Popovers

```swift
Button("Sort", systemImage: "arrow.up.arrow.down") {
    isShowingSortOptions = true
}
.popover(isPresented: $isShowingSortOptions) {
    SortOptions()
        .presentationDetents([.medium])
}
```

On iPad the popover points at its button. On iPhone it becomes a sheet, and the detents apply to that sheet. A popover closes when people tap outside it, so save its changes as they happen. Show one popover at a time, and nothing on top of it but an alert.

## Alerts and dialogs

```swift
// Good: a problem with a way to respond
.alert("Couldn't Send Message", isPresented: $isShowingSendError) {
    Button("Try Again", action: retry)
    Button("Cancel", role: .cancel) {}
} message: {
    Text("Check your connection, then try again.")
}

// Bad: an interruption that asks nothing of anyone
.alert("Saved", isPresented: $isShowingSaved) {
    Button("OK") {}
}
```

A confirmation dialog adds Cancel on its own. The words in alerts and dialogs belong to `writing`.

```swift
.fullScreenCover(isPresented: $isEditingPhoto) {
    PhotoEditor(photo: photo)
}
```

A full-screen cover hides everything behind it, so it carries its own Close or Done.
