# Copy patterns

Templates and recipes for each kind of copy, from title style to notifications.

## Title style

Title style capitalizes every word except these:

| Lowercase | Examples |
| --- | --- |
| Articles, unless first | a, an, the |
| Coordinating conjunctions | and, but, or, nor, for, yet, so |
| "to" in an infinitive, and "as" | Save as PDF |
| Prepositions of four letters or fewer | Add to Cart, Share with Friends |
| Words that always start lowercase | iPhone, iCloud |

The first and last words are always capitalized. So is a short preposition that belongs to a phrasal verb, as in Set Up, Turn On and Log In. Capitalize the second word of a hyphenated compound, except in Built-in and Plug-in.

## Destructive actions

| Situation | Copy |
| --- | --- |
| Common and recoverable | No dialog. The item moves to Recently Deleted, or the screen offers Undo |
| Cannot be undone, one item | Title: Delete "Q3 Report"? Message: "This deletes the report and its 4 comments. You can't undo this action." Buttons: Delete Report, Cancel |
| Cannot be undone, many items | Title: Delete 12 files? Message: "You can't undo this action." Buttons: Delete 12 Files, Cancel |
| Affects other people | The message names who: "The 8 members of Design lose access." |
| An account, a workspace or a shared space | A sheet asks people to type the name, such as acme-web, and the Delete button stays disabled until it matches |

```swift
.confirmationDialog(
    "Delete “\(project.name)”?",
    isPresented: $isConfirmingDelete,
    titleVisibility: .visible
) {
    Button("Delete Project", role: .destructive, action: deleteProject)
} message: {
    Text("This deletes the project and its \(project.taskCount) tasks. You can't undo this action.")
}
```

`titleVisibility: .visible` keeps the title, which names the object, on screen. The dialog adds Cancel on its own.

Deleting something larger asks for its name to be typed:

```swift
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
```

A registered undo names its action, and the system shows it as Undo Rename:

```swift
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
```

A view passes the undo manager from `@Environment(\.undoManager)`.

## Status copy

| State | Pattern | Example |
| --- | --- | --- |
| In progress | A verb ending in -ing, then the object | "Saving changes…", "Loading invoices…" |
| Done | The object, then a past-tense verb | "Changes saved", "Invite sent to sam@example.com" |
| Failed | What did not happen, then the next step | "Changes not saved. Check your connection and try again." |
| Unavailable | Why, and what unlocks it, beside the control | "Add a payment method to publish." |
| Partial | Counts for both outcomes | "9 of 12 files uploaded. 3 failed." |

Keep the in-progress and done strings parallel, so "Saving changes…" resolves to "Changes saved".

## Errors

| Bad | Good |
| --- | --- |
| That password is too short | Choose a password with at least 8 characters. |
| Invalid email | Enter an email address like name@example.com. |
| Oops! Something went wrong. | Your changes weren't saved. Check your connection and try again. |
| Error 503 | Couldn't reach the server. Your notes are saved on this iPhone and sync when you're back online. |

```swift
.alert("Couldn't Save Note", isPresented: $isShowingSaveError) {
    Button("Try Again", action: save)
    Button("Cancel", role: .cancel) {}
} message: {
    Text("iCloud storage is full. Free up space in Settings, then try again.")
}
```

## Empty states

```swift
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

// Bad: a shrug
Text("No data")
```

## Links to Settings

```swift
@Environment(\.openURL) private var openURL

var body: some View {
    Button("Open Settings") {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            openURL(url)
        }
    }
}
```

`UIApplication.openNotificationSettingsURLString` opens the app's notification settings instead.

## Permission requests

| Purpose string | Verdict |
| --- | --- |
| "Trails uses your location to show nearby routes and record your hikes." | Good: active, and names each use |
| "Location access is needed for a better experience." | Passive and vague |
| "Turn on location access." | An instruction with no reason |

Purpose strings live in the `Info.plist` or in `INFOPLIST_KEY_` build settings, keyed by names such as `NSCameraUsageDescription` and `NSLocationWhenInUseUsageDescription`. They translate through a String Catalog named `InfoPlist.xcstrings` in the same target.

After a denial, the feature that needed access explains itself and offers a way on:

```swift
ContentUnavailableView {
    Label("Camera Access Off", systemImage: "camera")
} description: {
    Text("Allow camera access in Settings to scan receipts, or add one from your photos.")
} actions: {
    Button("Open Settings", action: openAppSettings)
    Button("Choose Photo", action: choosePhoto)
}
```

## Notifications

```swift
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
```

The title is the event itself, so the body adds only what is new. The placeholder says what kind of notification arrived without revealing it.

## Widgets and Live Activities

```swift
struct OrderStatusWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "OrderStatus", provider: OrderStatusProvider()) { entry in
            OrderStatusView(entry: entry)
        }
        .configurationDisplayName("Order Status")
        .description("Follow your latest order from the kitchen to your door.")
    }
}
```

The system keeps a relative date current without a timeline reload:

```swift
Text("Updated \(entry.date, style: .relative) ago")
```

An alert on a Live Activity update reads like a notification:

```swift
if let activity = Activity<OrderAttributes>.activities.first {
    await activity.update(
        ActivityContent(state: state, staleDate: nil),
        alertConfiguration: AlertConfiguration(
            title: "Order Arriving",
            body: "The driver is 2 minutes away.",
            sound: .default
        )
    )
}
```

## App Shortcuts

```swift
enum MeditationSession: String, AppEnum {
    case morning, daily, sleep

    static let typeDisplayRepresentation: TypeDisplayRepresentation = "Session"
    static let caseDisplayRepresentations: [MeditationSession: DisplayRepresentation] = [
        .morning: "Morning",
        .daily: "Daily",
        .sleep: "Sleep",
    ]
}

struct StartMeditation: AppIntent {
    static let title: LocalizedStringResource = "Start Meditation"

    @Parameter(title: "Session")
    var session: MeditationSession

    func perform() async throws -> some IntentResult & ProvidesDialog {
        .result(dialog: "Starting your session.")
    }
}

struct MeditationShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: StartMeditation(),
            phrases: [
                "Start a \(\.$session) meditation in \(.applicationName)",
                "Meditate with \(.applicationName)",
            ],
            shortTitle: "Start Meditation",
            systemImageName: "figure.mind.and.body"
        )
    }
}
```

Show the tip after people finish the task by hand:

```swift
SiriTipView(intent: StartMeditation(), isVisible: $showsMeditationTip)
```
