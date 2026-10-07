// NavigationSnippets.swift
//
// Every Swift snippet from skills/navigation, copied as written and wrapped
// so it compiles on its own, plus one line for each API the prose names.
// Everything sits inside `NavigationCheck`, so this file can share a target
// with the other snippet files. Press Command-B; nothing here needs to run.

import SwiftUI
import WidgetKit
import ActivityKit

enum NavigationCheck {

    // MARK: - Stand-ins for the made-up types the snippets use

    struct Album: Identifiable, Hashable {
        let id = UUID()
        let title = "Blue"
    }
    struct Mailbox: Identifiable {
        let id = UUID()
        let name = "Inbox"
    }
    struct Message: Identifiable {
        let id = UUID()
    }
    struct Photo {}
    struct AddressDraft {
        var street = ""
        var hasChanges: Bool { !street.isEmpty }
        func save() {}
    }
    enum SearchScope: Hashable { case all, current }

    struct LibraryList: View { var body: some View { Text("Library") } }
    struct BrowseTab: View { var body: some View { Text("Browse") } }
    struct SearchTab: View { var body: some View { Text("Search") } }
    struct ListenNowTab: View { var body: some View { Text("Listen Now") } }
    struct InboxTab: View { var body: some View { Text("Inbox") } }
    struct NowPlayingBar: View { var body: some View { Text("Now Playing") } }
    struct AlbumDetail: View {
        let album: Album
        var body: some View { Text(album.title) }
    }
    struct MessageList: View {
        var mailboxID: Mailbox.ID?
        var selection: Binding<Message.ID?>?
        var searchText = ""
        var scope: SearchScope = .all

        init(mailboxID: Mailbox.ID?, selection: Binding<Message.ID?>) {
            self.mailboxID = mailboxID
            self.selection = selection
        }

        init(searchText: String, scope: SearchScope) {
            self.searchText = searchText
            self.scope = scope
        }

        var body: some View { Text("Messages") }
    }
    struct MessageDetail: View {
        let messageID: Message.ID?
        var body: some View { Text("Message") }
    }
    struct OrderSummary: View { var body: some View { Text("Order") } }
    struct NoteEditor: View { var body: some View { Text("Note") } }
    struct AddressForm: View {
        @Binding var draft: AddressDraft
        var body: some View { Form { TextField("Street", text: $draft.street) } }
    }
    struct FilterOptions: View { var body: some View { Text("Filters") } }
    struct FormattingPalette: View { var body: some View { Text("Formatting") } }
    struct SortOptions: View { var body: some View { Text("Sort") } }
    struct PhotoEditor: View {
        let photo: Photo
        var body: some View { Text("Editor") }
    }
    struct NoteList: View {
        let searchText: String
        var body: some View { Text("Notes") }
    }

    // MARK: - structure.md

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

    struct TabVariants: View {
        @State private var selection: AppTab = .library
        let unreadCount = 3

        var body: some View {
            VStack {
                // Bad: one stack around the tabs, so every push hides the tab bar
                NavigationStack {
                    TabView {
                        Tab("Library", systemImage: "books.vertical") {
                            LibraryList()
                        }
                    }
                }

                TabView {
                    Tab("Listen now", systemImage: "play.circle") {
                        ListenNowTab()
                    }
                }
                .tabBarMinimizeBehavior(.onScrollDown)
                .tabViewBottomAccessory {
                    NowPlayingBar()
                }

                TabView {
                    Tab("Inbox", systemImage: "tray") {
                        InboxTab()
                    }
                    .badge(unreadCount)
                }

                TabView(selection: $selection) {
                    TabSection("Collections") {
                        Tab("Browse", systemImage: "square.grid.2x2", value: AppTab.browse) {
                            BrowseTab()
                        }
                        .hidden(false)
                    }
                }
            }
        }
    }

    struct MailView: View {
        @State private var selectedMailbox: Mailbox.ID?
        @State private var selectedMessage: Message.ID?
        @State private var isShowingInspector = false
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
                    .inspector(isPresented: $isShowingInspector) {
                        Text("Inspector")
                    }
            }
        }
    }

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

    struct BackButton: View {
        @Environment(\.dismiss) private var dismiss
        let album: Album

        var body: some View {
            // Bad: a back button of its own loses the back swipe and the history menu
            AlbumDetail(album: album)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Back") { dismiss() }
                    }
                }
                .navigationSubtitle("12 Songs")
                .navigationBarTitleDisplayMode(.large)
                .toolbarVisibility(.hidden, for: .tabBar)
        }
    }

    // MARK: - presentation.md

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

    struct InfoSheet: View {
        @Environment(\.dismiss) private var dismiss

        var body: some View {
            NavigationStack {
                Text("Details")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button(role: .close) { dismiss() }
                        }
                    }
            }
        }
    }

    struct Presentations: View {
        let photo = Photo()
        @State private var isShowingFilters = false
        @State private var isShowingFormatting = false
        @State private var isShowingSortOptions = false
        @State private var isShowingSendError = false
        @State private var isShowingSaved = false
        @State private var isEditingPhoto = false
        func retry() {}

        var body: some View {
            VStack {
                Text("Detents")
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

                Button("Sort", systemImage: "arrow.up.arrow.down") {
                    isShowingSortOptions = true
                }
                .popover(isPresented: $isShowingSortOptions) {
                    SortOptions()
                        .presentationDetents([.medium])
                        .presentationCompactAdaptation(.sheet)
                }

                Text("Alerts")
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

                Text("Cover")
                    .fullScreenCover(isPresented: $isEditingPhoto) {
                        PhotoEditor(photo: photo)
                    }
            }
        }
    }

    // MARK: - toolbars-and-search.md

    struct Toolbars: View {
        @State private var searchText = ""
        @State private var scope: SearchScope = .all
        func compose() {}
        func select() {}
        func archiveAll() {}
        func filter() {}
        func newNote() {}

        var body: some View {
            VStack {
                Text("Inbox")
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
                .searchToolbarBehavior(.minimize)

                // Scopes for clearly defined categories, starting from the broadest
                MessageList(searchText: searchText, scope: scope)
                    .searchable(text: $searchText)
                    .searchScopes($scope) {
                        Text("All Mailboxes").tag(SearchScope.all)
                        Text("Current Mailbox").tag(SearchScope.current)
                    }
            }
        }
    }
    // MARK: Widgets and Live Activities open the screen they show

    struct WidgetGame: Identifiable {
        let id: Int
        let url: URL
    }

    struct WidgetEntry {
        let orderURL: URL
        let games: [WidgetGame]
    }

    struct OrderStatusView: View {
        let entry: WidgetEntry
        var body: some View { Text(verbatim: entry.orderURL.absoluteString) }
    }

    struct GameRow: View {
        let game: WidgetGame
        var body: some View { Text(game.id, format: .number) }
    }

    struct OrderWidgetView: View {
        let entry: WidgetEntry

        var body: some View {
            OrderStatusView(entry: entry)
                .widgetURL(entry.orderURL)
        }
    }

    struct GameAttributes: ActivityAttributes {
        struct ContentState: Codable, Hashable {
            var score: Int
        }

        var url: URL
    }

    struct GameLiveActivity: Widget {
        var body: some WidgetConfiguration {
            ActivityConfiguration(for: GameAttributes.self) { context in
                Text(context.state.score, format: .number)
                    .widgetURL(context.attributes.url)
            } dynamicIsland: { context in
                DynamicIsland {
                    DynamicIslandExpandedRegion(.center) {
                        Text(context.state.score, format: .number)
                    }
                } compactLeading: {
                    Image(systemName: "sportscourt")
                } compactTrailing: {
                    Text(context.state.score, format: .number)
                } minimal: {
                    Text(context.state.score, format: .number)
                }
                .widgetURL(context.attributes.url)
            }
        }
    }

    struct GamesWidgetView: View {
        let entry: WidgetEntry

        var body: some View {
            VStack(alignment: .leading) {
                ForEach(entry.games) { game in
                    Link(destination: game.url) {
                        GameRow(game: game)
                    }
                }
            }
        }
    }
}
