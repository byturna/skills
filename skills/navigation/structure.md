# Structure

Recipes for tabs, sidebars and split views, and stacks.

## Tabs

```swift
enum AppTab: Hashable {
    case library, browse, search
}

// Good: each tab's root owns its stack, so switching back keeps its place
struct RootView: View {
    @State private var selection: AppTab = .library
    let albums: [Album]

    var body: some View {
        TabView(selection: $selection) {
            Tab("Library", systemImage: "books.vertical", value: AppTab.library) {
                LibraryTab(albums: albums)
            }
            Tab("Browse", systemImage: "square.grid.2x2", value: AppTab.browse) {
                BrowseTab()
            }
            Tab(value: AppTab.search, role: .search) {
                SearchTab()
            }
        }
        .tabViewStyle(.sidebarAdaptable)
    }
}

// Bad: one stack around the tabs, so every push hides the tab bar
NavigationStack {
    TabView {
        Tab("Library", systemImage: "books.vertical") {
            LibraryList()
        }
    }
}
```

The search tab sits apart at the trailing end, and the system draws its label. `TabSection` groups tabs under a heading in the sidebar.

Where the app has an accessory people return to, such as a now-playing bar, the tab bar can shrink while people scroll:

```swift
TabView {
    Tab("Listen now", systemImage: "play.circle") {
        ListenNowTab()
    }
}
.tabBarMinimizeBehavior(.onScrollDown)
.tabViewBottomAccessory {
    NowPlayingBar()
}
```

A badge marks only what needs attention, such as unread messages:

```swift
Tab("Inbox", systemImage: "tray") {
    InboxTab()
}
.badge(unreadCount)
```

## Split views

```swift
struct MailView: View {
    @State private var selectedMailbox: Mailbox.ID?
    @State private var selectedMessage: Message.ID?
    let mailboxes: [Mailbox]

    var body: some View {
        NavigationSplitView {
            List(mailboxes, selection: $selectedMailbox) { mailbox in
                Label(mailbox.name, systemImage: "tray")
            }
            .navigationTitle("Mailboxes")
        } content: {
            MessageList(mailboxID: selectedMailbox, selection: $selectedMessage)
        } detail: {
            MessageDetail(messageID: selectedMessage)
        }
    }
}
```

Each column's list keeps its selection highlighted, which shows the path to the detail. In compact width the columns collapse into one stack, and the selections drive the pushes. An inspector for the selected item takes `.inspector(isPresented:content:)`.

## Stacks

```swift
struct LibraryTab: View {
    @State private var path: [Album] = []
    let albums: [Album]

    var body: some View {
        NavigationStack(path: $path) {
            List(albums) { album in
                NavigationLink(album.title, value: album)
            }
            .navigationTitle("Library")
            .navigationDestination(for: Album.self) { album in
                AlbumDetail(album: album)
            }
        }
    }
}
```

A deep link sets `path` to every screen between the root and its target, so back retraces a real route.

```swift
// Bad: a back button of its own loses the back swipe and the history menu
AlbumDetail(album: album)
    .navigationBarBackButtonHidden(true)
    .toolbar {
        ToolbarItem(placement: .topBarLeading) {
            Button("Back") { dismiss() }
        }
    }
```

A top-level screen takes a large title by default, which shrinks into the bar as people scroll. The design may choose an inline title instead, and either is fine. `.navigationSubtitle` adds context under the title, such as a count or a date.
