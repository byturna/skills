# Cheat sheet

Every navigation API this skill names, with its UIKit equivalent. Match whichever the view under review is written in.

## Structure

| Need | SwiftUI | UIKit |
| --- | --- | --- |
| Tabs | `TabView` with `Tab` | `UITabBarController` with `tabs` of `UITab` |
| Search tab | `Tab(value:role:content:)` with `.search` | `UISearchTab` |
| Tab bar that becomes a sidebar | `.tabViewStyle(.sidebarAdaptable)` | `mode = .tabSidebar` |
| Tab bar that shrinks on scroll | `.tabBarMinimizeBehavior(_:)` | `tabBarMinimizeBehavior` |
| Accessory above the tab bar | `.tabViewBottomAccessory(content:)` | `bottomAccessory` |
| Badge | `.badge(_:)` | `UITab.badgeValue` |
| Split view | `NavigationSplitView` | `UISplitViewController` |
| Inspector | `.inspector(isPresented:content:)` | `UISplitViewController.Column.inspector` |
| Stack | `NavigationStack(path:root:)` | `UINavigationController` |
| Push | `NavigationLink(value:)` with `navigationDestination(for:destination:)` | `pushViewController(_:animated:)` |
| Title and subtitle | `.navigationTitle(_:)`, `.navigationSubtitle(_:)` | `navigationItem.title`, `navigationItem.subtitle` |
| Large title | `.navigationBarTitleDisplayMode(.large)` | `prefersLargeTitles` |

## Presentation

| Need | SwiftUI | UIKit |
| --- | --- | --- |
| Sheet | `.sheet(item:onDismiss:content:)` | `present(_:animated:completion:)` |
| Detents | `.presentationDetents(_:)` | `sheetPresentationController.detents` |
| Grabber | `.presentationDragIndicator(.visible)` | `prefersGrabberVisible` |
| Sheet that leaves the screen behind usable | `.presentationBackgroundInteraction(.enabled(upThrough:))` | `largestUndimmedDetentIdentifier` |
| Keep a sheet with unsaved changes | `.interactiveDismissDisabled(_:)` | `isModalInPresentation` with `presentationControllerDidAttemptToDismiss(_:)` |
| Full screen | `.fullScreenCover(isPresented:onDismiss:content:)` | `modalPresentationStyle = .fullScreen` |
| Popover | `.popover(isPresented:attachmentAnchor:arrowEdge:content:)` | `modalPresentationStyle = .popover` with `popoverPresentationController.sourceItem` |
| Compact adaptation | `.presentationCompactAdaptation(_:)` | `UIAdaptivePresentationControllerDelegate` |
| Alert | `.alert(_:isPresented:actions:message:)` | `UIAlertController` with `.alert` |
| Confirmation dialog | `.confirmationDialog(_:isPresented:titleVisibility:actions:)` | `UIAlertController` with `.actionSheet` and a `sourceItem` |
| Dismiss | `@Environment(\.dismiss)` | `dismiss(animated:completion:)` |

## Toolbars and search

| Need | SwiftUI | UIKit |
| --- | --- | --- |
| Cancel or Close | `Button(role: .cancel)`, `Button(role: .close)` in `.cancellationAction` | `UIBarButtonItem(systemItem: .cancel)`, `.close` |
| Done | `Button(role: .confirm)` in `.confirmationAction` | `UIBarButtonItem` with `style = .prominent` |
| Primary action | `ToolbarItem(placement: .primaryAction)` | `navigationItem.trailingItemGroups` |
| Bottom bar | `ToolbarItemGroup(placement: .bottomBar)` | `toolbarItems` |
| Search | `.searchable(text:placement:prompt:)` | `navigationItem.searchController` |
| Search in the bottom bar | `DefaultToolbarItem(kind: .search, placement: .bottomBar)` | `searchBarPlacementBarButtonItem` in `toolbarItems` |
| Search as a button | `.searchToolbarBehavior(.minimize)` | No direct equivalent |
| Scopes | `.searchScopes(_:scopes:)` | `searchBar.scopeButtonTitles` |
