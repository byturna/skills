# Strings

Where strings live, the localizable APIs and the recipes for plurals and formatted values.

## Where strings live

| Source | Search for |
| --- | --- |
| Views | String literals in `Text`, `Button`, `Label`, `Toggle`, `.navigationTitle`, `.alert`, `.confirmationDialog`, `ContentUnavailableView` and `.searchable` |
| Swift code | `String(localized:`, `AttributedString(localized:`, `LocalizedStringResource` and `NSLocalizedString` |
| Catalogs | `*.xcstrings`, and in older projects `*.strings` and `*.stringsdict` |
| Generated symbols | Strings referenced as `.name` or `.Table.name`, which Xcode generates from catalog keys |
| Purpose strings | `Info.plist` keys ending in `UsageDescription`, `INFOPLIST_KEY_` entries in `project.pbxproj` and `InfoPlist.xcstrings` |
| Notifications | `UNMutableNotificationContent`, `UNNotificationAction`, `UNNotificationCategory` and the payloads a server sends |

Searching UIKit code is in [cheat-sheet.md](cheat-sheet.md#finding-strings).

## Localizable APIs

```swift
// Good: a literal in a view is a LocalizedStringKey, so Xcode extracts it
Button("Save Draft", action: saveDraft)

// Good: a property holding copy stays localizable
struct EmptyStateContent {
    let title: LocalizedStringResource
    let message: LocalizedStringResource
}

// Good: copy built outside a view
let summary = String(localized: "Sync finished")

// Bad: a String passed to Text is shown verbatim and never extracted
let heading: String = "Recent Orders"
Text(heading)
```

`Text(verbatim:)` is for text that is never translated, such as an order number or a person's own words.

A comment tells the translator what a key is for. Xcode can also generate one from the code around the string.

```swift
// "Archive" is a verb here, which the comment makes clear
Text("Archive", comment: "Button that archives the selected project")

let action = LocalizedStringResource("Archive", comment: "Button that archives the selected project")
```

Where the project uses generated symbols, a new string goes into the catalog as a key, and code references its symbol, such as `Text(.recentOrders)`.

## Plurals

```swift
// Good: one key, "%lld photos", with plural variants in the catalog
Text("\(photoCount) photos")

// Bad: English plural logic assembled from fragments, and never extracted
Text("\(photoCount) " + (photoCount == 1 ? "photo" : "photos"))
```

Build once so the key reaches the catalog. Then Control-click it and choose Vary by Plural. Xcode adds the categories each language needs, such as One and Other for English and One, Few, Many and Other for Russian. A project that uses automatic grammar agreement, `^[\(photoCount) photo](inflect: true)`, keeps it.

## Values

Each of these takes the person's locale:

| Value | SwiftUI |
| --- | --- |
| Date | `Text(order.date, format: .dateTime.month().day())` |
| Date and time | `date.formatted(date: .abbreviated, time: .shortened)` |
| Relative date | `date.formatted(.relative(presentation: .named))` |
| Currency | `Text(total, format: .currency(code: currencyCode))` |
| Percent | `Text(progress, format: .percent)` |
| Measurement | `distance.formatted(.measurement(width: .abbreviated))` |
| File size | `byteCount.formatted(.byteCount(style: .file))` |
| Duration | `elapsed.formatted(.units(allowed: [.hours, .minutes], width: .abbreviated))` |
| List | `names.formatted(.list(type: .and))` |
| Person's name | `nameComponents.formatted(.name(style: .short))` |

A value inside a sentence formats inside the key, so the translator can move it:

```swift
Text("Arrives \(order.deliveryDate, format: .dateTime.weekday(.wide))")
```

How digits line up in a column belongs to `typography`.
