# Toolbars and search

Where toolbar items go and where search sits.

## Toolbars

| Item | Placement |
| --- | --- |
| Back and the sidebar toggle | The system's, at the leading edge |
| Cancel or Close in a modal | `.cancellationAction` |
| Done, Save or Send in a modal | `.confirmationAction` |
| The screen's primary action | `.primaryAction` |
| Actions people use often, on iPhone | `.bottomBar` |
| Everything else | A `Menu` with `ellipsis`, at the trailing edge |
| Controls for the text being typed | `.keyboard`, which `layout` covers |

```swift
.toolbar {
    ToolbarItem(placement: .primaryAction) {
        Button("Compose", systemImage: "square.and.pencil", action: compose)
    }
    ToolbarItem(placement: .topBarTrailing) {
        Menu("More", systemImage: "ellipsis") {
            Button("Select Messages", systemImage: "checkmark.circle", action: select)
            Button("Archive All", systemImage: "archivebox", action: archiveAll)
        }
    }
    ToolbarItemGroup(placement: .bottomBar) {
        Button("Filter", systemImage: "line.3.horizontal.decrease", action: filter)
    }
}
```

The system adds an overflow menu on iPad when items no longer fit, so never build one by hand. How the items group on their shared glass belongs to `ui`.

The HIG suggests keeping a title under 15 characters, so the bar keeps room for its controls.

## Search

```swift
// Search in the bottom toolbar, beside the screen's main action
NavigationStack {
    NoteList(searchText: searchText)
        .navigationTitle("Notes")
        .toolbar {
            DefaultToolbarItem(kind: .search, placement: .bottomBar)
            ToolbarSpacer(.flexible, placement: .bottomBar)
            ToolbarItem(placement: .bottomBar) {
                Button("New Note", systemImage: "square.and.pencil", action: newNote)
            }
        }
}
.searchable(text: $searchText)
```

```swift
// Scopes for clearly defined categories, starting from the broadest
MessageList(searchText: searchText, scope: scope)
    .searchable(text: $searchText)
    .searchScopes($scope) {
        Text("All Mailboxes").tag(SearchScope.all)
        Text("Current Mailbox").tag(SearchScope.current)
    }
```

`.searchToolbarBehavior(.minimize)` shows search as a button that expands into the field when tapped, where the bar has little room. The search prompt names what people can find, and its words belong to `writing`.
