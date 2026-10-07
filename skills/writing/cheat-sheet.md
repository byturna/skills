# Cheat sheet

Every API this skill names, with its UIKit equivalent. Match whichever the view under review is written in.

## Strings

| Need | SwiftUI | UIKit |
| --- | --- | --- |
| Localized text | A literal in `Text`, `Button` or `Label` | `String(localized:)` assigned to `text` or `title` |
| A property holding copy | `LocalizedStringResource` | `LocalizedStringResource`, resolved with `String(localized:)` |
| Comment for translators | `Text(_:tableName:bundle:comment:)` | `String(localized:table:bundle:locale:comment:)` |
| Text that is never translated | `Text(verbatim:)` | Assign the `String` directly |
| Formatted value | `Text(_:format:)` | `formatted(_:)` on the value |
| Older projects | `NSLocalizedString(_:tableName:bundle:value:comment:)` | The same |

## Finding strings

In UIKit, search for `String(localized:` and `NSLocalizedString`, and for strings assigned to `title`, `text`, `placeholder` and `UIAction` titles. Storyboards and XIBs keep their copy in their own catalogs or `.strings` files.

## Components

| Need | SwiftUI | UIKit |
| --- | --- | --- |
| Alert | `.alert(_:isPresented:actions:message:)` | `UIAlertController` with `.alert` |
| Confirmation dialog | `.confirmationDialog(_:isPresented:titleVisibility:actions:message:)` | `UIAlertController` with `.actionSheet` |
| Destructive button | `Button(role: .destructive)` | `UIAlertAction` with `.destructive`, or a `UIAction` with the `.destructive` attribute |
| Menu item | `Button` inside a `Menu` | `UIAction` with a `title` |
| Empty state | `ContentUnavailableView` | `UIContentUnavailableConfiguration.empty()` on `contentUnavailableConfiguration` |
| Empty search | `ContentUnavailableView.search(text:)` | `UIContentUnavailableConfiguration.search()` |
| Text field example | `TextField(_:text:prompt:)` | `placeholder` |
| Search prompt | `.searchable(text:placement:prompt:)` | `searchBar.placeholder` |
| Undo name | `setActionName(_:)` on `@Environment(\.undoManager)` | `setActionName(_:)` on the responder's `undoManager` |
| App's page in Settings | `openURL` with `UIApplication.openSettingsURLString` | `UIApplication.shared.open(_:options:completionHandler:)` with the same string |
| App's notification settings | `openURL` with `UIApplication.openNotificationSettingsURLString` | `UIApplication.shared.open(_:options:completionHandler:)` with the same string |

## Notifications

Notification content is the same in both frameworks:

| Need | API |
| --- | --- |
| Title and body | `title` and `body` on `UNMutableNotificationContent` |
| Text for hidden previews | `hiddenPreviewsBodyPlaceholder` on `UNNotificationCategory` |
| Action | `UNNotificationAction(identifier:title:options:)` |
| Destructive action | `UNNotificationActionOptions.destructive` |
