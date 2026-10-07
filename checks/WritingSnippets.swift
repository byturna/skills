// WritingSnippets.swift
//
// Every Swift snippet from skills/writing, copied as written and wrapped so it
// compiles on its own, plus one line for each API the prose and the cheat sheet
// name. Everything sits inside `WritingCheck`, so this file can share a project
// with the other snippet files. Press Command-B; nothing here needs to run.
//
// strings.md shows `Text(.recentOrders)`, a symbol Xcode generates from a
// String Catalog key. This project may have no such key, so the
// `LocalizedStringResource` extension at the bottom stands in for it.

import SwiftUI
import UIKit
import UserNotifications

enum WritingCheck {

    // MARK: - Stand-ins for the made-up types the snippets use

    struct Order {
        let date = Date.now
        let deliveryDate = Date.now
    }
    struct Project {
        let name = "Q3 Report"
        let taskCount = 4
    }
    struct Event {
        let name = "Design Review"
        let room = "Room 4"
    }
    struct SearchResult: Identifiable {
        let id = UUID()
        let title = "Result"
    }

    // MARK: - strings.md

    // Good: a property holding copy stays localizable
    struct EmptyStateContent {
        let title: LocalizedStringResource
        let message: LocalizedStringResource
    }

    struct Strings: View {
        let photoCount = 3
        let order = Order()

        var body: some View {
            VStack {
                // Good: a literal in a view is a LocalizedStringKey, so Xcode extracts it
                Button("Save Draft", action: saveDraft)

                badHeading

                Text(verbatim: "Order 1042")

                // "Archive" is a verb here, which the comment makes clear
                Text("Archive", comment: "Button that archives the selected project")

                Text(.recentOrders)

                // Good: one key, "%lld photos", with plural variants in the catalog
                Text("\(photoCount) photos")

                // Bad: English plural logic assembled from fragments, and never extracted
                Text("\(photoCount) " + (photoCount == 1 ? "photo" : "photos"))

                Text("^[\(photoCount) photo](inflect: true)")

                Text("Arrives \(order.deliveryDate, format: .dateTime.weekday(.wide))")

                values
            }
        }

        var badHeading: some View {
            // Bad: a String passed to Text is shown verbatim and never extracted
            let heading: String = "Recent Orders"
            return Text(heading)
        }

        func saveDraft() {}

        func builtOutsideAView() -> String {
            // Good: copy built outside a view
            let summary = String(localized: "Sync finished")
            let action = LocalizedStringResource("Archive", comment: "Button that archives the selected project")
            let content = EmptyStateContent(title: "No Orders", message: action)
            _ = content
            return summary
        }

        // The values table
        var values: some View {
            let date = Date.now
            let total = Decimal(4320)
            let currencyCode = "EUR"
            let progress = 0.42
            let distance = Measurement(value: 12, unit: UnitLength.kilometers)
            let byteCount: Int64 = 12_000_000
            let elapsed = Duration.seconds(5_400)
            let names = ["Ana", "Ben", "Cy"]
            var nameComponents = PersonNameComponents()
            nameComponents.givenName = "Ana"
            nameComponents.familyName = "Silva"

            return VStack {
                Text(order.date, format: .dateTime.month().day())
                Text(date.formatted(date: .abbreviated, time: .shortened))
                Text(date.formatted(.relative(presentation: .named)))
                Text(total, format: .currency(code: currencyCode))
                Text(progress, format: .percent)
                Text(distance.formatted(.measurement(width: .abbreviated)))
                Text(byteCount.formatted(.byteCount(style: .file)))
                Text(elapsed.formatted(.units(allowed: [.hours, .minutes], width: .abbreviated)))
                Text(names.formatted(.list(type: .and)))
                Text(nameComponents.formatted(.name(style: .short)))
            }
        }
    }

    // MARK: - patterns.md: destructive actions

    struct DeleteProject: View {
        let project = Project()
        @State private var isConfirmingDelete = false

        var body: some View {
            Button("Delete Project", role: .destructive) {
                isConfirmingDelete = true
            }
            .confirmationDialog(
                "Delete “\(project.name)”?",
                isPresented: $isConfirmingDelete,
                titleVisibility: .visible
            ) {
                Button("Delete Project", role: .destructive, action: deleteProject)
            } message: {
                Text("This deletes the project and its \(project.taskCount) tasks. You can't undo this action.")
            }
        }

        func deleteProject() {}
    }

    @MainActor
    @Observable
    final class Note {
        var title = ""

        func rename(to newTitle: String, undoManager: UndoManager?) {
            let oldTitle = title
            title = newTitle
            undoManager?.registerUndo(withTarget: self) { note in
                note.rename(to: oldTitle, undoManager: undoManager)
            }
            undoManager?.setActionName(String(localized: "Rename"))
        }
    }

    struct NoteTitleEditor: View {
        @Environment(\.undoManager) private var undoManager
        let note: Note
        @State private var draft = ""

        var body: some View {
            TextField("Title", text: $draft)
                .onSubmit {
                    note.rename(to: draft, undoManager: undoManager)
                }
        }
    }

    struct Workspace {
        let name = "acme-web"
        let memberCount = 8
    }

    struct DeleteWorkspaceSheet: View {
        let workspace: Workspace
        @State private var typedName = ""
        @Environment(\.dismiss) private var dismiss

        var body: some View {
            NavigationStack {
                Form {
                    Section {
                        TextField(workspace.name, text: $typedName)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                    } header: {
                        Text("Type “\(workspace.name)” to confirm")
                    } footer: {
                        Text("This deletes the workspace for its \(workspace.memberCount) members. You can't undo this action.")
                    }
                    Section {
                        Button("Delete Workspace", role: .destructive, action: deleteWorkspace)
                            .disabled(typedName != workspace.name)
                    }
                }
                .navigationTitle("Delete workspace")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(role: .cancel) { dismiss() }
                    }
                }
            }
        }

        func deleteWorkspace() {}
    }

    // MARK: - patterns.md: errors

    struct SaveError: View {
        @State private var isShowingSaveError = false

        var body: some View {
            Text("Note")
                .alert("Couldn't Save Note", isPresented: $isShowingSaveError) {
                    Button("Try Again", action: save)
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("iCloud storage is full. Free up space in Settings, then try again.")
                }
        }

        func save() {}
    }

    // MARK: - patterns.md: empty states

    struct EmptyStates: View {
        let results: [SearchResult] = []
        @State private var query = ""

        var body: some View {
            VStack {
                // Good: says what goes here and offers the first step
                ContentUnavailableView {
                    Label("No Projects", systemImage: "folder")
                } description: {
                    Text("Projects keep your tasks and files together.")
                } actions: {
                    Button("New Project", action: createProject)
                }

                // Good: an empty search names the query
                List(results) { result in
                    Text(result.title)
                }
                .overlay {
                    if results.isEmpty {
                        ContentUnavailableView.search(text: query)
                    }
                }
                .searchable(text: $query, placement: .automatic, prompt: Text("Search recipes"))

                // Bad: a shrug
                Text("No data")
            }
        }

        func createProject() {}
    }

    // MARK: - patterns.md: links to Settings and permission requests

    struct SettingsLink: View {
        @Environment(\.openURL) private var openURL

        var body: some View {
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    openURL(url)
                }
            }
        }
    }

    struct CameraDenied: View {
        @Environment(\.openURL) private var openURL

        var body: some View {
            ContentUnavailableView {
                Label("Camera Access Off", systemImage: "camera")
            } description: {
                Text("Allow camera access in Settings to scan receipts, or add one from your photos.")
            } actions: {
                Button("Open Settings", action: openAppSettings)
                Button("Choose Photo", action: choosePhoto)
            }
        }

        func openAppSettings() {
            if let url = URL(string: UIApplication.openSettingsURLString) {
                openURL(url)
            }
        }

        func openNotificationSettings() {
            if let url = URL(string: UIApplication.openNotificationSettingsURLString) {
                openURL(url)
            }
        }

        func choosePhoto() {}
    }

    // MARK: - SKILL.md: placeholders and toggles

    struct SignUp: View {
        @State private var email = ""
        @State private var sendsReadReceipts = true

        var body: some View {
            VStack {
                Text("Email")
                TextField("Email", text: $email, prompt: Text(verbatim: "name@example.com"))
                Toggle("Send read receipts", isOn: $sendsReadReceipts)
                    .accessibilityHint("Lets senders see when you read their messages")
            }
        }
    }

    // MARK: - patterns.md: notifications

    static func scheduleReminder(for event: Event) -> UNNotificationCategory {
        let content = UNMutableNotificationContent()
        content.title = event.name
        content.body = String(localized: "Starts in 15 minutes in \(event.room).")
        content.categoryIdentifier = "event"

        let category = UNNotificationCategory(
            identifier: "event",
            actions: [
                UNNotificationAction(identifier: "snooze", title: String(localized: "Snooze"), options: []),
                UNNotificationAction(identifier: "decline", title: String(localized: "Decline Event"), options: [.destructive])
            ],
            intentIdentifiers: [],
            hiddenPreviewsBodyPlaceholder: String(localized: "Upcoming event")
        )
        return category
    }

    // MARK: - cheat-sheet.md: UIKit

    @MainActor
    static func uikit(in viewController: UIViewController, undoManager: UndoManager) {
        let label = UILabel()
        label.text = String(localized: "Sync finished")
        label.text = String(localized: "Archive", table: nil, bundle: nil, locale: .current, comment: "Button that archives the selected project")
        label.text = NSLocalizedString("Archive", tableName: nil, bundle: .main, value: "", comment: "Button that archives the selected project")
        label.text = String(localized: LocalizedStringResource("Sync finished"))
        label.text = Date.now.formatted(date: .abbreviated, time: .omitted)

        let alert = UIAlertController(
            title: String(localized: "Couldn't Save Note"),
            message: String(localized: "iCloud storage is full. Free up space in Settings, then try again."),
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: String(localized: "Cancel"), style: .cancel))

        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: String(localized: "Delete Project"), style: .destructive))

        let menuItem = UIAction(title: String(localized: "Delete Project"), attributes: .destructive) { _ in }
        _ = UIMenu(children: [menuItem])

        var empty = UIContentUnavailableConfiguration.empty()
        empty.text = String(localized: "No Projects")
        empty.secondaryText = String(localized: "Projects keep your tasks and files together.")
        viewController.contentUnavailableConfiguration = empty
        viewController.contentUnavailableConfiguration = UIContentUnavailableConfiguration.search()

        let field = UITextField()
        field.placeholder = "name@example.com"
        let search = UISearchController()
        search.searchBar.placeholder = String(localized: "Search recipes")

        undoManager.setActionName(String(localized: "Rename"))

        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }

        _ = UNNotificationActionOptions.destructive
    }
}

// Stand-in for the symbol Xcode generates from a String Catalog key.
extension LocalizedStringResource {
    static var recentOrders: LocalizedStringResource { "Recent Orders" }
}
