---
name: navigation
description: Chooses how people move through SwiftUI and UIKit apps, from tabs, stacks and split views to sheets, popovers, alerts, toolbars and search.
---

# Navigation

This skill decides how people move through an iOS app and where each task appears, from tabs and stacks to sheets, popovers, alerts and dialogs. It places toolbar items and search, and checks that every screen says where it is and how to leave.

How a presentation animates belongs to `motion`. The glass that bars and toolbar items share belongs to `ui`, and grouping and spacing within a screen to `layout`. How a modal contains VoiceOver belongs to `accessibility`. Titles, button labels, alert text and whether a destructive action confirms at all belong to `writing`. The UIKit form of every API here is in [cheat-sheet.md](cheat-sheet.md).

## The system's structures first

`TabView`, `NavigationStack`, `NavigationSplitView`, sheets, popovers, alerts and confirmation dialogs bring the back swipe, swipe to dismiss, size-class adaptation, VoiceOver containment and Liquid Glass with them. A finding is a structure that leaves them behind. Examples are a hand-built tab bar, an overlay posing as a modal, a sheet on a sheet and a screen with no way back.

Which pattern fits a task is often a judgment. Report a choice only where it breaks a rule here or in the HIG, not where another pattern would also work.

## Tabs switch sections, toolbars act

A `TabView` holds the app's top-level sections, each a `Tab` with a one-word label and a symbol. A tab never performs an action; actions go in a toolbar. Each tab owns its own `NavigationStack`, so switching back returns people to where they were.

Keep the tab bar visible in every section, hidden only under a modal. Never disable or remove a tab because its content is unavailable; the section explains why it is empty. Keep the default tabs to five or fewer, so none overflow into a More tab. Recipes are in [structure.md](structure.md#tabs).

## Sidebars where the hierarchy outgrows tabs

On iPad, `.tabViewStyle(.sidebarAdaptable)` lets the tab bar turn into a sidebar when people want more of the app at hand. Use `NavigationSplitView` for a sidebar that never becomes a tab bar. Show at most two levels in a sidebar. A deeper hierarchy takes a three-column split view, with a content list between the sidebar and the detail.

Highlight the selection in each column that leads to the detail. Never hide the sidebar by default. A split view collapses into a stack in compact width on its own. See [structure.md](structure.md#split-views).

## Push to go deeper

Moving to more detail about something on screen is a push in a `NavigationStack`. Drive it with `NavigationLink(value:)` and `navigationDestination(for:)`, and hold the path in state when the app must navigate in code or restore a deep link.

Keep the system back button, which carries the back swipe and the history menu on a long press. Never hide it to draw your own. See [structure.md](structure.md#stacks).

## Present modally only for a focused task

A modal takes people out of their context and asks them to dismiss it, so use one only where focus or a decision helps. Keep a modal task short, with a single path through any steps inside it. A full-screen cover suits media, the camera and long editing. A sheet suits a short task. The choice table is in [presentation.md](presentation.md#choosing).

## One modal at a time

Never present a sheet from a sheet, a popover from a popover or two alerts at once. Close one before opening the next. Drive a view's presentations from one optional value with `.sheet(item:)`, never from several Booleans that can be true together. See [presentation.md](presentation.md#one-at-a-time).

## Every modal names its task and its way out

A sheet has a title that names its task. Cancel or Close sits at the leading edge of its toolbar, and Done at the trailing edge. Use `Button(role: .cancel)` or `.close` in `.cancellationAction`, and `Button(role: .confirm)` in `.confirmationAction`. The system then draws its own labels for them. Done always comes with Cancel or Back, and never with both.

Swipe to dismiss stays on. Where it would lose unsaved changes, disable it with `.interactiveDismissDisabled` while there are changes. Cancel then asks whether to discard them. See [presentation.md](presentation.md#ways-out).

## Sheets rest at detents

On iPhone, a sheet that can show its first useful part at half height takes `.presentationDetents([.medium, .large])`. A sheet people write in stays at `.large`. A resizable sheet shows its grabber with `.presentationDragIndicator(.visible)`. A tool that acts on the screen behind it, such as a formatting palette, stays open with `.presentationBackgroundInteraction(.enabled(upThrough: .medium))`. See [presentation.md](presentation.md#detents).

## Popovers in regular width only

A popover holds a little information or a few options, anchored to the control that opened it. In compact width SwiftUI presents it as a sheet, and that adaptation stays. Never force a popover on iPhone with `.presentationCompactAdaptation(.popover)` for more than a few controls. Never warn people through a popover, which they can dismiss without seeing. See [presentation.md](presentation.md#popovers).

## Alerts for problems, dialogs for choices

An alert tells people about a problem or a risk that needs a response, with up to three buttons. Never use one only to inform, at launch or after a common action people can undo. Choices about an action people started, such as discarding a draft, go in a `.confirmationDialog`. Attach it to the control that opened it, so it appears from its source. The destructive choice takes `role: .destructive`. See [presentation.md](presentation.md#alerts-and-dialogs).

## Toolbar items go where people look

The leading edge holds back, the sidebar toggle and Cancel. The trailing edge holds the one primary action, then a More menu. On iPhone, frequent actions can sit in the bottom bar. Use the standard symbols for common actions, and text only for actions symbols cannot carry, such as Edit. Aim for no more than three groups. The table is in [toolbars-and-search.md](toolbars-and-search.md#toolbars).

## Search where the content is

Search goes through `.searchable`. On iPhone, put it in the bottom toolbar where there is room, or at the top where content at the bottom matters. Make it a tab with `Tab(role: .search)` where search is a destination across sections. On iPad, search sits at the trailing edge of the toolbar or at the top of the sidebar it filters. Show results as people type, and add scopes only for clearly defined categories. See [toolbars-and-search.md](toolbars-and-search.md#search).

## Every screen says where it is and how to leave

Each screen answers four questions: where am I, where can I go, what is here and how do I get out. A title names the screen, never the app. The selected tab or sidebar item shows the section. A back button or a Close button is always present. A deep link opens with its stack built, so back leads somewhere sensible.

## Before you finish

| Pattern | Fix |
| --- | --- |
| A tab bar built from an `HStack` of buttons | `TabView` with `Tab` |
| `.toolbarVisibility(.hidden, for: .tabBar)` on a section's screen | Keep the tab bar |
| A `Tab` removed, or hidden with `.hidden(_:)`, while its content is unavailable | Keep it, and explain the empty state |
| A `Tab` whose content performs an action | A toolbar button |
| One `NavigationStack` around a whole `TabView` | One stack inside each tab |
| `NavigationLink(destination:)` in a list built from data | `NavigationLink(value:)` with `navigationDestination(for:)` |
| `.navigationBarBackButtonHidden(true)` with a back button of its own | The system back button |
| Several Booleans each driving a `.sheet` on one view | One optional value with `.sheet(item:)` |
| A `.sheet` presented from inside another sheet | Close it first, or push inside the sheet |
| A sheet with Done and no Cancel or Back | Add Cancel |
| Text buttons titled Back, Close or Done in place of the system's | The back button, `Button(role: .close)` or `Button(role: .confirm)` |
| `.interactiveDismissDisabled()` with no unsaved-changes condition | Allow swipe to dismiss |
| `.presentationCompactAdaptation(.popover)` on more than a few controls | Let it adapt to a sheet |
| An `.alert` with only OK, for information | An inline status |
| An `.alert` offering choices about an action people started | `.confirmationDialog` |
| An alert on launch | Inline status or placeholder content |
| A `ZStack` overlay acting as a modal | `.sheet`, `.fullScreenCover` or `.popover` |
| `.fullScreenCover` for a short form | `.sheet` |
| More than one prominent toolbar item | One primary action at the trailing edge |
| A search field built from a `TextField` in a header | `.searchable` |

## Reporting

**Severity.** `HIGH` traps people or loses their work. Examples are a modal with no way out, a screen with no way back and swipe to dismiss that discards unsaved changes. A hand-built modal is `HIGH` as well, since it reaches `design-review`'s VoiceOver containment trigger, which `accessibility` checks. `MEDIUM` is the wrong structure for the task. Examples are a sheet on a sheet, a hidden tab bar, a popover forced onto iPhone, an alert that only informs and a misplaced primary action. `LOW` is an isolated title or placement detail.

**Verification.** Without Xcode, map the app's structure from the code: tabs, stacks, split views, every presentation and its trigger, and every toolbar placement. Check each against the rules above. With Xcode, walk every flow on the smallest iPhone, a full-screen iPad and a narrow iPad window. Swipe back on every pushed screen and swipe down on every sheet with unsaved changes. Report every check you could not run as `Not verified`.

**Format.** Group findings under the principle each violates, ordered by severity, one row per root cause listing every location it appears in:

| Severity | Location | Before | After | Why |
| --- | --- | --- | --- | --- |

`Location` is `path/to/file.swift:line`. `Why` names the principle and the user impact.

End with `Block` when any `HIGH` remains, `Approve` otherwise, leaving the rest in the table as work to do. Never `Approve` coverage you did not inspect. With nothing to report, state "No actionable navigation findings" and report verification.
