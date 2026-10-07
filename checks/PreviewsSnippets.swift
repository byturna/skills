// PreviewsSnippets.swift
//
// Every Swift snippet from skills/previews, copied as written, plus one use of
// each API the prose and the cheat sheet name. The made-up types sit inside
// `PreviewsCheck`, and type aliases let the previews use them by their short
// names, as the skill does. `#Preview` stays at file scope. Add this file to
// the app target only; the test targets do not need it.
// Press Command-B; nothing here needs to run.

import SwiftUI
import SwiftData
import UIKit

enum PreviewsCheck {

    // MARK: - Stand-ins for the made-up types the snippets use

    struct Member: Identifiable {
        let id = UUID()
        let name: String
        let email: String
        let role: String?
    }

    struct MemberList: View {
        let members: [Member]

        var body: some View {
            List(members) { member in
                VStack(alignment: .leading) {
                    Text(member.name)
                    Text(member.email)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Members")
        }
    }

    final class MemberListViewController: UIViewController {
        let members: [Member]

        init(members: [Member]) {
            self.members = members
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    enum InboxError: Error {
        case offline
    }

    enum InboxState {
        case loading
        case loaded([String])
        case failed(InboxError)
    }

    @Observable
    final class InboxModel {
        var state: InboxState

        init(state: InboxState) {
            self.state = state
        }
    }

    struct InboxView: View {
        @Environment(InboxModel.self) private var model

        var body: some View {
            switch model.state {
            case .loading:
                ProgressView()
            case .loaded(let messages):
                List(messages, id: \.self) { Text($0) }
            case .failed:
                ContentUnavailableView("Couldn't Load Mail", systemImage: "wifi.slash")
            }
        }
    }

    @Model
    final class Trip {
        var name: String

        init(name: String) {
            self.name = name
        }

        static var worstCase: [Trip] {
            [Trip(name: "Konstantin Oberhauser-Wettstein's Alpine Traverse"), Trip(name: "Jo")]
        }
    }

    struct TripList: View {
        @Query private var trips: [Trip]

        var body: some View {
            List(trips) { trip in
                Text(trip.name)
            }
        }
    }

    struct NameField: View {
        @Binding var name: String

        var body: some View {
            TextField("Name", text: $name)
        }
    }

    struct Avatar: View {
        let url: URL?

        var body: some View {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                case .failure:
                    Image(systemName: "person.crop.circle")
                case .empty:
                    ProgressView()
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 44, height: 44)
        }
    }
}

typealias Member = PreviewsCheck.Member
typealias MemberList = PreviewsCheck.MemberList
typealias MemberListViewController = PreviewsCheck.MemberListViewController
typealias InboxModel = PreviewsCheck.InboxModel
typealias InboxView = PreviewsCheck.InboxView
typealias Trip = PreviewsCheck.Trip
typealias TripList = PreviewsCheck.TripList
typealias NameField = PreviewsCheck.NameField

// MARK: - fixtures.md: through the initializer

#if DEBUG
extension Member {
    static let typical: [Member] = [
        Member(name: "Maya Chen", email: "maya.chen@example.com", role: "Designer"),
        Member(name: "Luis Ortega", email: "luis@example.com", role: "Engineer"),
        Member(name: "Priya Raman", email: "priya.raman@example.com", role: "Product Manager"),
    ]

    // Each row breaks something different, as real data does
    static let worstCase: [Member] = [
        Member(name: "Aleksandra Wiśniewska-Kowalczyk", email: "aleksandra.wisniewska@northwind-industries-holdings.example.com", role: "Senior Product Design Engineer, Platform Infrastructure"),
        Member(name: "Jo", email: "jo@example.com", role: nil),
        Member(name: "Đặng Thị Ngọc Hân", email: "hann@example.com", role: "Engineer"),
        Member(name: "نور الهدى عبد الرحمن", email: "nour@example.com", role: "Support"),
    ]
}

#Preview("Typical") {
    NavigationStack {
        MemberList(members: Member.typical)
    }
}

#Preview("Empty") {
    NavigationStack {
        MemberList(members: [])
    }
}

#Preview("Worst case") {
    NavigationStack {
        MemberList(members: Member.worstCase)
    }
}

#Preview("Worst case, AX5") {
    NavigationStack {
        MemberList(members: Member.worstCase)
    }
    .dynamicTypeSize(.accessibility5)
}

#Preview("Worst case, right to left") {
    NavigationStack {
        MemberList(members: Member.worstCase)
    }
    .environment(\.layoutDirection, .rightToLeft)
    .environment(\.locale, Locale(identifier: "ar"))
}

// MARK: - fixtures.md: through an observable model

#Preview("Loading") {
    InboxView()
        .environment(InboxModel(state: .loading))
}

#Preview("Error") {
    InboxView()
        .environment(InboxModel(state: .failed(.offline)))
}

// MARK: - fixtures.md: through a shared context

struct SampleTrips: PreviewModifier {
    static func makeSharedContext() throws -> ModelContainer {
        let container = try ModelContainer(
            for: Trip.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        for trip in Trip.worstCase {
            container.mainContext.insert(trip)
        }
        return container
    }

    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
}

#Preview("Worst case", traits: .modifier(SampleTrips())) {
    TripList()
}

// MARK: - fixtures.md: through a binding

#Preview("Long name, editing") {
    @Previewable @State var name = "Aleksandra Wiśniewska-Kowalczyk"
    NameField(name: $name)
}

// MARK: - scenarios.md: environment, container and images

#Preview("Smallest text, dark, Bold Text") {
    NavigationStack {
        MemberList(members: Member.worstCase)
    }
    .dynamicTypeSize(.xSmall)
    .preferredColorScheme(.dark)
    .environment(\.legibilityWeight, .bold)
    .environment(\.locale, Locale(identifier: "de_DE"))
}

#Preview("Landscape", traits: .landscapeLeft) {
    NavigationStack {
        MemberList(members: Member.typical)
    }
}

#Preview("Narrow, compact", traits: .sizeThatFitsLayout) {
    HStack {
        MemberList(members: Member.worstCase)
        Text("A sibling that takes the space")
            .layoutPriority(1)
    }
    .frame(width: 320)
    .environment(\.horizontalSizeClass, .compact)
}

#Preview("Fixed size, regular", traits: .fixedLayout(width: 1024, height: 768)) {
    MemberList(members: Member.worstCase)
        .environment(\.horizontalSizeClass, .regular)
}

#Preview("Failed image") {
    PreviewsCheck.Avatar(url: URL(string: "https://example.com/missing.png"))
}

// MARK: - picker.md: all states

enum MemberListState: String, CaseIterable {
    case typical, empty, crowded

    var members: [Member] {
        switch self {
        case .typical: Member.typical
        case .empty: []
        case .crowded: Member.worstCase
        }
    }
}

#Preview("All states") {
    @Previewable @State var state = MemberListState.typical
    NavigationStack {
        MemberList(members: state.members)
    }
    .overlay(alignment: .bottom) {
        DebugPicker("States", selection: $state)
    }
}

// MARK: - cheat-sheet.md: UIKit

#Preview("UIKit, empty") {
    MemberListViewController(members: [])
}

#Preview("AX5") {
    let controller = MemberListViewController(members: Member.worstCase)
    controller.traitOverrides.preferredContentSizeCategory = .accessibilityExtraExtraExtraLarge
    return controller
}

#Preview("UIKit, dark, right to left, bold, compact") {
    let controller = MemberListViewController(members: Member.worstCase)
    controller.traitOverrides.userInterfaceStyle = .dark
    controller.traitOverrides.layoutDirection = .rightToLeft
    controller.traitOverrides.legibilityWeight = .bold
    controller.traitOverrides.horizontalSizeClass = .compact
    return controller
}
#endif
