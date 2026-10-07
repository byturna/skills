// UISnippets.swift
//
// Every Swift snippet from skills/ui, copied as written and wrapped so it
// compiles on its own, plus one line for each API the prose names. Everything
// sits inside `UICheck`, so this file can share a target with the other
// snippet files. Press Command-B; nothing here needs to run.
//
// Image("reply.arrow") names an asset that does not exist. That is fine: it
// compiles and only matters at run time.

import SwiftUI

enum UICheck {

    // MARK: - Stand-ins for the made-up types the snippets use

    struct Product {}
    struct Route {}
    struct Photo { let caption = "Harbor at dusk" }
    struct Album {
        let title = "Blue"
        let coverURL = URL(string: "https://example.com/cover.jpg")
    }
    struct Order: Identifiable { let id = UUID() }
    struct Message {}

    struct InboxList: View { var body: some View { List { Text("Inbox") } } }
    struct ArticleBody: View { var body: some View { Text("Article") } }
    struct ReplyBar: View { var body: some View { TextField("Reply", text: .constant("")) } }
    struct ProductHero: View {
        let product: Product
        var body: some View { Rectangle() }
    }
    struct RouteSummary: View {
        let route: Route
        var body: some View { Text("12 min") }
    }
    struct PlaybackControls: View { var body: some View { Image(systemName: "play.fill") } }
    struct PhotoView: View {
        let photo: Photo
        var body: some View { Rectangle() }
    }
    struct AlbumArtwork: View {
        let album: Album
        var body: some View { Rectangle().aspectRatio(1, contentMode: .fit) }
    }
    struct OrderSummary: View {
        let order: Order
        var body: some View { Text("Order") }
    }
    struct LibraryView: View { var body: some View { Text("Library") } }
    struct BrowseView: View { var body: some View { Text("Browse") } }
    struct AlbumTile: View {
        let album: Album
        var body: some View { Rectangle().frame(width: 120, height: 120) }
    }
    struct MessageRow: View {
        let message: Message
        var body: some View { Text("Message") }
    }
    struct RowActions: View {
        let message: Message
        var body: some View {
            Button("Archive", systemImage: "archivebox") {}
            Button("Delete", systemImage: "trash") {}
        }
    }

    // MARK: - glass.md

    struct BarsAndEdges: View {
        let product = Product()

        var body: some View {
            VStack {
                // Bad: a color laid over the navigation bar's glass
                NavigationStack {
                    InboxList()
                        .toolbarBackground(Color.indigo, for: .navigationBar)
                        .toolbarBackground(.visible, for: .navigationBar)
                }

                // Good: the bar gets the scroll edge effect
                ScrollView {
                    ArticleBody()
                }
                .safeAreaBar(edge: .bottom) {
                    ReplyBar()
                }

                // Bad: a hand-built bar with its own background and divider
                ScrollView {
                    ArticleBody()
                }
                .safeAreaInset(edge: .bottom) {
                    VStack(spacing: 0) {
                        Divider()
                        ReplyBar()
                            .background(.bar)
                    }
                }

                ScrollView {
                    ArticleBody()
                }
                .scrollEdgeEffectStyle(.hard, for: .top)

                ProductHero(product: product)
                    .backgroundExtensionEffect()
            }
        }
    }

    struct Toolbars: View {
        let canShare = true
        let documentURL = URL(string: "https://example.com/doc")!
        func undo() {}
        func redo() {}

        var body: some View {
            NavigationStack {
                VStack {
                    Text("Document")
                        .toolbar {
                            ToolbarItemGroup(placement: .topBarTrailing) {
                                Button("Undo", systemImage: "arrow.uturn.backward", action: undo)
                                Button("Redo", systemImage: "arrow.uturn.forward", action: redo)
                            }
                            ToolbarSpacer(.fixed, placement: .topBarTrailing)
                            if canShare {
                                ToolbarItem(placement: .topBarTrailing) {
                                    ShareLink(item: documentURL)
                                }
                            }
                        }

                    Text("Bad")
                        .toolbar {
                            // Bad: the share link disappears but its item stays
                            ToolbarItem(placement: .topBarTrailing) {
                                ShareLink(item: documentURL)
                                    .opacity(canShare ? 1 : 0)
                            }
                        }

                    Text("Avatar")
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Image(systemName: "person.crop.circle")
                            }
                            .sharedBackgroundVisibility(.hidden)
                        }
                }
            }
        }
    }

    struct CustomGlass: View {
        let route = Route()
        @Namespace private var namespace
        func addStop() {}

        var body: some View {
            VStack {
                Button("Add Stop", systemImage: "plus", action: addStop)
                    .buttonStyle(.glass)

                Button("Clear", action: addStop)
                    .buttonStyle(.glass(.clear))

                Button("Prominent", action: addStop)
                    .buttonStyle(.glassProminent)

                RouteSummary(route: route)
                    .padding()
                    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 20))

                RouteSummary(route: route)
                    .glassEffect(.regular.tint(.orange))
                    .glassEffectTransition(.materialize)
                    .glassEffectUnion(id: "summary", namespace: namespace)
            }
        }
    }

    struct MapControls: View {
        @Namespace private var namespace
        @State private var isExpanded = false
        let centerOnUser: () -> Void

        var body: some View {
            GlassEffectContainer(spacing: 12) {
                VStack(spacing: 12) {
                    Button {
                        withAnimation(.smooth) { isExpanded.toggle() }
                    } label: {
                        Label("Map Options", systemImage: "square.3.layers.3d")
                            .labelStyle(.iconOnly)
                            .frame(width: 44, height: 44)
                    }
                    .glassEffect(.regular.interactive(), in: .circle)
                    .glassEffectID("options", in: namespace)

                    if isExpanded {
                        Button(action: centerOnUser) {
                            Label("Current Location", systemImage: "location")
                                .labelStyle(.iconOnly)
                                .frame(width: 44, height: 44)
                        }
                        .glassEffect(.regular.interactive(), in: .circle)
                        .glassEffectID("location", in: namespace)
                    }
                }
            }
        }
    }

    struct ClearGlassAndMaterials: View {
        let photo = Photo()

        var body: some View {
            VStack {
                PlaybackControls()
                    .padding()
                    .glassEffect(.clear, in: .capsule)
                    .background(.black.opacity(0.35), in: .capsule)

                // Good: a caption over a photo, on a material in the content layer
                PhotoView(photo: photo)
                    .overlay(alignment: .bottomLeading) {
                        Text(photo.caption)
                            .padding(8)
                            .background(.thinMaterial, in: .rect(cornerRadius: 8))
                            .padding(8)
                    }

                // Bad: glass in the content layer
                PhotoView(photo: photo)
                    .overlay(alignment: .bottomLeading) {
                        Text(photo.caption)
                            .padding(8)
                            .glassEffect(in: .rect(cornerRadius: 8))
                            .padding(8)
                    }

                Text("Materials")
                    .background(.ultraThinMaterial)
                    .background(.regularMaterial)
                    .background(.thickMaterial)
            }
        }
    }

    // MARK: - shapes.md

    struct AlbumCard: View {
        let album: Album

        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                AlbumArtwork(album: album)
                    .clipShape(ConcentricRectangle(corners: .concentric(minimum: 8)))
                Text(album.title)
                    .font(.headline)
                    .padding(.horizontal, 8)
            }
            .padding(8)
            .background(Color(.secondarySystemGroupedBackground), in: .rect(cornerRadius: 24))
            .containerShape(.rect(cornerRadius: 24))
        }
    }

    struct Corners: View {
        let album = Album()

        var body: some View {
            VStack {
                // Bad: the inner corners repeat the card's radius and bulge against it
                AlbumArtwork(album: album)
                    .clipShape(.rect(cornerRadius: 24))

                ConcentricRectangle(uniformTopCorners: .fixed(24), uniformBottomCorners: .concentric)
                    .fill(Color.green)

                ConcentricRectangle(corners: .concentric, isUniform: true)
                    .fill(Color.green)
            }
        }
    }

    struct ControlShapes: View {
        func advance() {}

        var body: some View {
            VStack {
                // Good: the system sizes and shapes the control
                Button("Continue", action: advance)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)

                // Bad: hard-coded metrics that miss the system's shape, press and hover
                Button("Continue", action: advance)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.accentColor)
                    .foregroundStyle(.white)
                    .clipShape(.rect(cornerRadius: 12))

                Button("Small", action: advance)
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                    .controlSize(.extraLarge)

                Button("Round", systemImage: "plus", action: advance)
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.circle)
                    .controlSize(.mini)
            }
        }
    }

    struct Elevation: View {
        let orders: [Order]
        let order = Order()

        var body: some View {
            VStack {
                // Good: the background levels separate the card
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(orders) { order in
                            OrderSummary(order: order)
                                .padding()
                                .background(Color(.secondarySystemGroupedBackground), in: .rect(cornerRadius: 16))
                        }
                    }
                    .padding()
                }
                .background(Color(.systemGroupedBackground))

                // Bad: a shadow and a border standing in for the levels
                OrderSummary(order: order)
                    .padding()
                    .background(Color(.systemBackground), in: .rect(cornerRadius: 16))
                    .shadow(radius: 8)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray.opacity(0.2))
                    }

                Color(.tertiarySystemGroupedBackground)
                Color(.secondarySystemBackground)
                Color(.tertiarySystemBackground)
            }
        }
    }

    struct ImageOutline: View {
        let album = Album()

        var body: some View {
            AsyncImage(url: album.coverURL) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color(.secondarySystemFill)
            }
            .frame(width: 64, height: 64)
            .clipShape(.rect(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(Color.primary.opacity(0.1), lineWidth: 1)
            }
        }
    }

    // MARK: - symbols.md

    struct SizeAndWeight: View {
        var body: some View {
            VStack {
                // Good: the symbol takes the label's size and weight
                Label("Downloads", systemImage: "arrow.down.circle")
                    .font(.headline)

                // Good: a smaller symbol that still matches the text's weight
                Label("Verified", systemImage: "checkmark.seal.fill")
                    .imageScale(.small)

                // Bad: a fixed frame breaks the weight, baseline and Dynamic Type match
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                        .resizable()
                        .frame(width: 14, height: 14)
                    Text("Verified")
                }

                Label("Semibold", systemImage: "star")
                    .fontWeight(.semibold)

                Image(systemName: "star")
                    .font(.largeTitle)
            }
        }
    }

    struct Variants: View {
        @State private var isBookmarked = false

        var body: some View {
            VStack {
                // Good: outline names; the tab bar draws the fill
                TabView {
                    Tab("Library", systemImage: "books.vertical") {
                        LibraryView()
                    }
                    Tab("Browse", systemImage: "square.grid.2x2") {
                        BrowseView()
                    }
                }

                // Good: a custom selected state through the variant
                Toggle(isOn: $isBookmarked) {
                    Label("Bookmark", systemImage: "bookmark")
                        .symbolVariant(isBookmarked ? .fill : .none)
                }
                .toggleStyle(.button)

                Image(systemName: "wifi")
                    .symbolVariant(.slash)

                Image(systemName: "heart")
                    .environment(\.symbolVariants, .none)
            }
        }
    }

    struct RenderingModes: View {
        let volume = 0.6

        var body: some View {
            VStack {
                Image(systemName: "cloud.sun.rain.fill")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.tint)

                Image(systemName: "speaker.wave.3", variableValue: volume)

                Image(systemName: "person.crop.circle.badge.plus")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.white, .blue)

                Image(systemName: "leaf")
                    .symbolRenderingMode(.multicolor)

                Image(systemName: "wifi", variableValue: volume)
                    .symbolVariableValueMode(.draw)

                Image(systemName: "sun.max.fill")
                    .symbolColorRenderingMode(.gradient)

                Image(systemName: "star")
                    .symbolRenderingMode(.monochrome)

                Image("custom.icon")
                    .renderingMode(.template)
            }
        }
    }

    struct OpticalAndDirection: View {
        var body: some View {
            VStack {
                // Good: the enclosed variant is drawn as one symbol
                Image(systemName: "play.circle.fill")
                    .font(.largeTitle)

                // Bad: a glyph centered by geometry in a circle of your own
                Image(systemName: "play.fill")
                    .padding()
                    .background(.tint, in: .circle)

                Image("reply.arrow")
                    .flipsForRightToLeftLayoutDirection(true)
            }
        }
    }

    // MARK: - pointer.md

    struct PointerEffects: View {
        let album = Album()
        func showMore() {}

        var body: some View {
            VStack {
                Button(action: showMore) {
                    Label("More", systemImage: "ellipsis")
                        .labelStyle(.iconOnly)
                        .frame(width: 44, height: 44)
                }
                .hoverEffect(.highlight)

                AlbumTile(album: album)
                    .contentShape(.hoverEffect, .rect(cornerRadius: 12))
                    .hoverEffect(.lift)

                Text("Chart")
                    .onContinuousHover { phase in
                        switch phase {
                        case .active(let location): _ = location
                        case .ended: break
                        }
                    }
            }
        }
    }

    struct OrderRow: View {
        let order: Order
        @State private var isHovered = false

        var body: some View {
            OrderSummary(order: order)
                .padding()
                .background(isHovered ? Color(.quaternarySystemFill) : Color.clear, in: .rect(cornerRadius: 12))
                .onHover { isHovered = $0 }
        }
    }

    struct HoverNeverGates: View {
        let message = Message()
        @State private var isHovered = false

        var body: some View {
            List {
                // Bad: the actions appear only under the pointer
                MessageRow(message: message)
                    .overlay(alignment: .trailing) {
                        if isHovered {
                            RowActions(message: message)
                        }
                    }
                    .onHover { isHovered = $0 }

                // Good: the same actions reach touch through swipe actions and the context menu
                MessageRow(message: message)
                    .swipeActions {
                        RowActions(message: message)
                    }
                    .contextMenu {
                        RowActions(message: message)
                    }
            }
        }
    }
}
