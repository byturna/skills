// LayoutSnippets.swift
//
// Every Swift snippet from skills/layout, copied as written and wrapped so it
// compiles on its own, plus one line for each API the prose names. Everything
// sits inside `LayoutCheck`, so this file can share a target with the other
// snippet files. Press Command-B; nothing here needs to run.

import SwiftUI

enum LayoutCheck {

    // MARK: - Stand-ins for the made-up types the snippets use

    struct Order {
        let address = "1 Infinite Loop"
        let paymentSummary = "Visa ending 4242"
    }
    struct Trial { let statusMessage = "Your trial ends in 3 days." }
    struct Item {
        let name = "Coffee"
        let price: Decimal = 3.5
        let currencyCode = "EUR"
    }
    struct Run {
        let distance = "5.2 km"
        let pace = "5:12 /km"
    }
    struct Account {
        let balance: Decimal = 4320
        let currencyCode = "EUR"
    }
    struct Profile {}
    struct Cart {}
    struct Album: Identifiable { let id = UUID() }
    struct Collection: Identifiable { let id = UUID() }

    struct ProfileContent: View {
        let profile: Profile
        var body: some View { Text("Profile") }
    }
    struct ProfileBackdrop: View {
        let profile: Profile
        var body: some View { Rectangle() }
    }
    struct ProfileHeader: View {
        let profile: Profile
        var body: some View { Text("Header") }
    }
    struct FollowButton: View {
        let profile: Profile
        var body: some View { Button("Follow") {} }
    }
    struct CartItems: View {
        let cart: Cart
        var body: some View { Text("Items") }
    }
    struct AlbumTile: View {
        let album: Album
        var body: some View { Rectangle().frame(height: 160) }
    }
    struct CollectionCard: View {
        let collection: Collection
        var body: some View { RoundedRectangle(cornerRadius: 16).frame(height: 200) }
    }
    struct UnreadBadge: View {
        let count: Int
        var body: some View { Text(count, format: .number) }
    }

    // MARK: - grouping.md

    struct Grouping: View {
        let order = Order()
        let trial = Trial()
        let item = Item()
        let run = Run()
        let account = Account()
        func upgrade() {}
        func placeOrder() {}
        func saveForLater() {}
        func duplicate() {}
        func move() {}
        func export() {}

        var body: some View {
            ScrollView {
                // Good: space alone carries the grouping
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Shipping")
                            .font(.headline)
                        Text(order.address)
                    }
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Payment")
                            .font(.headline)
                        Text(order.paymentSummary)
                    }
                }
                .padding()

                // Bad: even spacing, with dividers making up the difference
                VStack(alignment: .leading, spacing: 12) {
                    Text("Shipping")
                        .font(.headline)
                    Text(order.address)
                    Divider()
                    Text("Payment")
                        .font(.headline)
                    Text(order.paymentSummary)
                }

                Form {
                    Section("Shipping") {
                        LabeledContent("Address", value: order.address)
                    }
                    Section("Payment") {
                        LabeledContent("Card", value: order.paymentSummary)
                    }
                }

                // Good: the action reads as a control
                VStack(alignment: .leading, spacing: 8) {
                    Text(trial.statusMessage)
                    Button("Upgrade", action: upgrade)
                        .buttonStyle(.bordered)
                }

                // Bad: an action that looks like the sentence it sits in
                Text(trial.statusMessage + " Upgrade now")
                    .onTapGesture(perform: upgrade)

                alignment
                actions
            }
        }

        var alignment: some View {
            VStack {
                // Mixed sizes share a baseline
                HStack(alignment: .firstTextBaseline) {
                    Text(item.name)
                        .font(.headline)
                    Spacer()
                    Text(item.price, format: .currency(code: item.currencyCode))
                        .font(.subheadline)
                }

                // Label and value columns line up across rows
                Grid(alignment: .leading, verticalSpacing: 8) {
                    GridRow {
                        Text("Distance")
                        Text(run.distance)
                            .gridColumnAlignment(.trailing)
                    }
                    GridRow {
                        Text("Pace")
                        Text(run.pace)
                    }
                }

                // Good: the balance first, its label after
                VStack(alignment: .leading, spacing: 4) {
                    Text(account.balance, format: .currency(code: account.currencyCode))
                        .font(.largeTitle.bold())
                    Text("Available Balance")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }

        var actions: some View {
            VStack {
                VStack(spacing: 12) {
                    Button(action: placeOrder) {
                        Text("Place Order")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)

                    Button("Save for Later", action: saveForLater)
                }

                Menu("More", systemImage: "ellipsis") {
                    Button("Duplicate", systemImage: "plus.square.on.square", action: duplicate)
                    Button("Move to", systemImage: "folder", action: move)
                    Button("Export", systemImage: "square.and.arrow.up", action: export)
                }
            }
        }
    }

    // MARK: - edges.md

    struct Edges: View {
        let profile = Profile()
        let cart = Cart()
        @State private var title = ""
        @State private var note = ""
        func checkOut() {}
        func insertChecklist() {}

        var body: some View {
            VStack {
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

                ScrollView {
                    CartItems(cart: cart)
                }
                .safeAreaPadding(.horizontal, 16)
                .contentMargins(.vertical, 8, for: .scrollContent)
                .background {
                    Color(.systemGroupedBackground)
                        .ignoresSafeArea(.keyboard)
                }
                .background {
                    Color.clear
                        .ignoresSafeArea(.container)
                }
            }
        }
    }

    // MARK: - adaptivity.md

    struct Adaptivity: View {
        let albums: [Album]
        @State private var isWide = false
        func share() {}
        func duplicate() {}
        func save() {}

        // Bad: the device type says nothing about the window's width
        var badColumns: Int {
            let columnCount = UIDevice.current.userInterfaceIdiom == .pad ? 4 : 2
            return columnCount
        }

        var body: some View {
            VStack {
                // Good: the columns come from the space the grid gets
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))]) {
                    ForEach(albums) { album in
                        AlbumTile(album: album)
                    }
                }

                // A row of actions that stacks only when it runs out of width
                ViewThatFits(in: .horizontal) {
                    HStack(spacing: 12) {
                        Button("Share", systemImage: "square.and.arrow.up", action: share)
                        Button("Duplicate", systemImage: "plus.square.on.square", action: duplicate)
                    }
                    VStack(alignment: .leading, spacing: 12) {
                        Button("Share", systemImage: "square.and.arrow.up", action: share)
                        Button("Duplicate", systemImage: "plus.square.on.square", action: duplicate)
                    }
                }

                // Good: the label sets the button's width
                Button("Save", action: save)
                    .buttonStyle(.bordered)

                // Bad: a fixed width that a longer language overflows
                Button("Save", action: save)
                    .frame(width: 80)

                Rectangle()
                    .containerRelativeFrame(.horizontal)
                    .onGeometryChange(for: Bool.self) { proxy in
                        proxy.size.width > 500
                    } action: { newValue in
                        isWide = newValue
                    }
            }
        }
    }

    struct StatRow: View {
        @Environment(\.dynamicTypeSize) private var dynamicTypeSize
        let title: String
        let value: String

        var body: some View {
            let isStacked = dynamicTypeSize.isAccessibilitySize
            let layout = isStacked
                ? AnyLayout(VStackLayout(alignment: .leading, spacing: 4))
                : AnyLayout(HStackLayout(alignment: .firstTextBaseline))

            layout {
                Text(title)
                if !isStacked {
                    Spacer()
                }
                Text(value)
                    .foregroundStyle(.secondary)
            }
        }
    }

    struct SizeClass: View {
        @Environment(\.horizontalSizeClass) private var horizontalSizeClass
        var body: some View {
            Text(horizontalSizeClass == .regular ? "Regular" : "Compact")
        }
    }

    // MARK: - disclosure.md

    struct Disclosure: View {
        let collections: [Collection]
        @State private var keepsOriginals = true
        @State private var includesHidden = false

        var body: some View {
            VStack {
                // The content margins leave the next card visible past the edge
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 12) {
                        ForEach(collections) { collection in
                            CollectionCard(collection: collection)
                                .containerRelativeFrame(.horizontal)
                        }
                    }
                    .scrollTargetLayout()
                }
                .contentMargins(.horizontal, 24, for: .scrollContent)
                .scrollTargetBehavior(.viewAligned)

                ScrollView {
                    Text("Long content")
                }
                .scrollIndicatorsFlash(onAppear: true)

                DisclosureGroup("Advanced Options") {
                    Toggle("Keep original files", isOn: $keepsOriginals)
                    Toggle("Include hidden items", isOn: $includesHidden)
                }

                List {
                    Text("Row")
                        .listRowSeparator(.hidden)
                }
            }
        }
    }

    struct ReviewText: View {
        let text: String
        @State private var isExpanded = false

        var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                Text(text)
                    .lineLimit(isExpanded ? nil : 4)
                Button(isExpanded ? "Show Less" : "Show More") {
                    isExpanded.toggle()
                }
            }
        }
    }

    // MARK: - mirroring.md

    struct Mirroring: View {
        let unreadCount = 3

        var body: some View {
            VStack {
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

                HStack {
                    Image(systemName: "backward.fill")
                    Image(systemName: "play.fill")
                    Image(systemName: "forward.fill")
                }
                .environment(\.layoutDirection, .leftToRight)
            }
            .environment(\.layoutDirection, .rightToLeft)
        }
    }
}
