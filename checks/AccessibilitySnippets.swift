// AccessibilitySnippets.swift
//
// Every Swift snippet from skills/accessibility, copied as written and
// wrapped so it compiles on its own. Add this file to an empty iOS App
// project and press Command-B. Nothing here needs to run.

import SwiftUI

// MARK: - Stand-ins for the made-up types the snippets use

struct Message: Identifiable {
    let id = UUID()
    var sender = "Anna"
    var preview = "Are we still on for lunch?"
    var date = Date.now
}

struct Card: Identifiable {
    let id = UUID()
}

struct Status {
    var title = "Online"
    var symbolName = "checkmark.circle.fill"
    var color = Color.green
}

struct CustomSwitch: View {
    @Binding var isOn: Bool

    var body: some View {
        Capsule()
            .fill(isOn ? Color.green : Color.gray)
            .frame(width: 50, height: 30)
    }
}

struct StarRating: View {
    @Binding var rating: Int

    var body: some View {
        HStack {
            ForEach(1...5, id: \.self) { star in
                Image(systemName: star <= rating ? "star.fill" : "star")
            }
        }
    }
}

struct MessageRow: View {
    let message: Message

    var body: some View {
        Text(message.preview)
    }
}

struct CardView: View {
    let card: Card

    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .frame(height: 120)
    }
}

struct CustomTabBar: View {
    @Binding var selection: Int

    var body: some View {
        HStack {
            Text("Home")
            Text("Search")
        }
    }
}

struct DetailPanel: View {
    var body: some View {
        Text("Details")
    }
}

// MARK: - voiceover.md

struct VoiceOverSnippets: View {
    @State private var isOn = false
    @State private var rating = 3
    let message = Message()

    var body: some View {
        List {
            // Good: the title stays the accessible name; only the icon shows
            Button("New Message", systemImage: "square.and.pencil", action: compose)
                .labelStyle(.iconOnly)

            // Bad: no name at all, so VoiceOver guesses one from the symbol
            Button(action: compose) {
                Image(systemName: "square.and.pencil")
            }

            CustomSwitch(isOn: $isOn)
                .accessibilityRepresentation {
                    Toggle("Wi-Fi", isOn: $isOn)
                }

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

            HStack {
                Image(decorative: "avatar")
                VStack(alignment: .leading) {
                    Text(message.sender)
                    Text(message.preview)
                }
                Text(message.date, format: .dateTime.hour().minute())
            }
            .accessibilityElement(children: .combine)

            MessageRow(message: message)
                .accessibilityActions {
                    Button("Archive") { archive(message) }
                    Button("Delete", role: .destructive) { delete(message) }
                }
        }
    }

    func compose() {}
    func archive(_ message: Message) {}
    func delete(_ message: Message) {}

    func announcePaymentFailure() {
        var announcement = AttributedString("Payment failed. Check your card details.")
        announcement.accessibilitySpeechAnnouncementPriority = .high
        AccessibilityNotification.Announcement(announcement).post()
    }
}

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

// MARK: - forms.md

struct FormsSnippets: View {
    enum Field { case name, email }
    @FocusState private var focusedField: Field?
    @State private var name = ""
    @State private var email = ""
    @State private var emailError: String?

    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                TextField("Email", text: $email)

                LabeledContent("Email") {
                    TextField("Email", text: $email, prompt: Text("name@example.com"))
                }

                Section {
                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .focused($focusedField, equals: .email)
                } footer: {
                    if let emailError {
                        Text(emailError)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add", action: save)
                        .disabled(name.isEmpty)
                }
            }
        }
    }

    func submit() {
        guard emailError == nil else {
            focusedField = .email
            AccessibilityNotification.Announcement("Check your email address").post()
            return
        }
        save()
    }

    func save() {}
}

// MARK: - touch-and-input.md

struct TouchSnippets: View {
    @State private var isFavorite = false
    let card = Card()

    var body: some View {
        VStack {
            // Good: a 17pt symbol with a 44pt target
            Button {
                toggleFavorite()
            } label: {
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .frame(minWidth: 44, minHeight: 44)
                    .contentShape(.rect)
            }
            .accessibilityLabel(isFavorite ? "Remove from Favorites" : "Add to Favorites")

            // Bad: the frame sits outside the button, so taps on the padding miss
            Button(action: toggleFavorite) {
                Image(systemName: "star")
            }
            .frame(width: 44, height: 44)

            CardView(card: card)
                .gesture(swipeToDismiss)
                .accessibilityAction(named: "Dismiss") { dismiss(card) }

            Button("Compose", systemImage: "square.and.pencil", action: compose)
                .labelStyle(.iconOnly)
                .accessibilityInputLabels(["Compose", "New Message", "Write"])
        }
    }

    var swipeToDismiss: some Gesture {
        DragGesture().onEnded { _ in dismiss(card) }
    }

    func toggleFavorite() { isFavorite.toggle() }
    func dismiss(_ card: Card) {}
    func compose() {}
}

// MARK: - display-settings.md

struct DisplaySnippets: View {
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @State private var tab = 0
    let caption = "Sunset over the bay"
    let status = Status()
    let isOnline = true

    var body: some View {
        VStack {
            Button("Settings", systemImage: "gear", action: openSettings)
                .labelStyle(.iconOnly)
                .accessibilityShowsLargeContentViewer()

            CustomTabBar(selection: $tab)
                .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                .accessibilityShowsLargeContentViewer()

            Text(caption)
                .padding()
                .background(.black.opacity(reduceTransparency ? 1 : 0.6))

            // Good: the symbol and the word carry the status, the color reinforces it
            Label(status.title, systemImage: status.symbolName)
                .foregroundStyle(status.color)

            // Bad: a dot whose color is the only difference between states
            Circle()
                .fill(isOnline ? Color.green : Color.red)
                .frame(width: 8, height: 8)
        }
    }

    func openSettings() {}
}

// MARK: - motion-and-media.md

struct MotionSnippets: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var showDetails = false

    var body: some View {
        VStack {
            if showDetails {
                DetailPanel()
                    .transition(reduceMotion
                        ? AnyTransition.opacity
                        : AnyTransition.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
}
