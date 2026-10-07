---
name: layout
description: Sets grouping, alignment, spacing, safe areas and adaptive structure in SwiftUI and UIKit apps, so a screen holds up across size classes, text sizes, languages and right-to-left.
---

# Layout

This skill sets the structure of an iOS screen: how it groups, aligns and spaces its content, and where the safe areas and the keyboard leave room. It then tests that structure at every size class, at accessibility text sizes, in long languages and mirrored for right-to-left.

Which screens exist, how people move between them and which presentation a task uses belong to `navigation`. Hit targets, reading order and the requirement that text scales belong to `accessibility`. Text styles and truncation mechanics belong to `typography`, surfaces and the glass layer to `ui` and the words to `writing`. The UIKit form of every API here is in [cheat-sheet.md](cheat-sheet.md).

## A finding needs a failure you can show

System margins, list insets, bar spacing and safe areas are tuned by Apple for every device, window and text size. Reach for `.padding()` with no argument, `List` and `Form` insets and the safe area before a number of your own. Where the project has spacing tokens, use them.

A finding is a failure you can point to: a clip, an overlap, a control under the home indicator, a broken mirror or a group that reads wrong. A value that differs from a starting point here is not one.

## Group with space, then shape, then lines

Space separates groups first. A background shape comes next, where a group must read as one unit such as a card. Separator lines come last, for dense lists where space costs too much. The space between groups is clearly larger than the space within one, and twice as much is a starting point.

`List` and `Form` sections already group with insets, headers and separators. Never hide their separators to follow this rule. Recipes are in [grouping.md](grouping.md#space-shape-lines).

## Controls look like controls

A control reads as one through tinted text, a system button style or a known place such as a toolbar or a list row with a chevron. Never style an action like the body text beside it, and never style a static label like a button. See [grouping.md](grouping.md#controls-and-content).

## Align to the system's margins

Inset content with `.padding()` and no argument, or with the list's own insets. Give each column one leading edge, and indent only to show that something belongs to the item above it. Rows that mix sizes align on `.firstTextBaseline`. Label and value columns go in a `Grid` or `LabeledContent`, with numbers trailing. See [grouping.md](grouping.md#alignment).

## Most important content first

Put the most important content near the top and the leading edge. In a row, what identifies the item leads, and metadata and actions trail. Keep the visual order and the view order the same, since VoiceOver reads the view order, and never move content out of sequence with offsets. See [grouping.md](grouping.md#order).

## One prominent action per screen

A screen has at most one `.borderedProminent` or `.glassProminent` action. Beyond three secondary actions, put the rest in a `Menu`. Where toolbar items go is `navigation`'s. See [grouping.md](grouping.md#actions).

## Show that more exists

Content past an edge shows that it is there. A horizontal row lets its next item peek past the edge, and a collapsed section names what it hides. Never nest two scroll views on the same axis.

Truncated text people need keeps a way to the full value, through an expand control or a detail view. Hover tooltips do not exist on touch. Truncation mechanics are `typography`'s. Recipes are in [disclosure.md](disclosure.md).

## Backgrounds bleed, content stays safe

Backgrounds and media fill the screen. Text and controls stay inside the safe area, clear of the status bar, the Dynamic Island, the home indicator and the bars. `.ignoresSafeArea()` goes on the background alone, never on a container that holds controls. Never reserve those regions with hand-picked padding. See [edges.md](edges.md#safe-areas).

## Pinned actions ride the safe area

An action pinned to the bottom of a scrolling screen goes in the safe area, through `.safeAreaBar(edge: .bottom)`, inset from the screen's edges. It then stays above the home indicator and rises with the keyboard. Never pin it with an overlay and a bottom padding. The bar's surface is `ui`'s. See [edges.md](edges.md#pinned-actions).

## The keyboard never covers the field or its action

SwiftUI keeps content above the keyboard on its own, so never add `.ignoresSafeArea(.keyboard)` to a container that holds a text field. A scrolling form takes `.scrollDismissesKeyboard(.interactively)`. Controls that belong to the text being typed go in a `.keyboard` toolbar. In UIKit, constrain to `keyboardLayoutGuide` rather than reading keyboard notifications. See [edges.md](edges.md#the-keyboard).

## Adapt to the space, never the device

Decide structure from `horizontalSizeClass` or from the space a container gives, never from the device type, the orientation or the screen's bounds. iPad windows resize freely down to a minimum size, and `UIScreen.main` is deprecated in iOS 26. Within a component, prefer `ViewThatFits` or an adaptive grid to a size-class branch.

Keep the same features at every size, and show more of them where there is room. See [adaptivity.md](adaptivity.md#size-classes).

## Stack at accessibility sizes

At accessibility text sizes, side-by-side text stacks vertically. Switch an `HStack` of label and value to a `VStack` through `AnyLayout` when `dynamicTypeSize.isAccessibilitySize`. Rows grow taller, and multicolumn content drops columns. Keep the primary content near the top at every size. See [adaptivity.md](adaptivity.md#accessibility-sizes).

## Let the text set the size

Never fix the width or height of a view that holds text; use a minimum where a floor is needed. Buttons take the size of their labels, and rows of them wrap or stack when they run out of room. Translated text grows, and a one-word label grows the most in proportion. See [adaptivity.md](adaptivity.md#growth).

## Widgets and Live Activities fit their slots

A widget comes in fixed sizes. Offer only the families where the content adds value, through `supportedFamilies(_:)`, and lay out each one from `widgetFamily`. A small widget shows one piece of information. A larger one adds detail about the same idea and never stretches the small layout.

Keep the content margins the system applies, and never pad the root view again. Inside them, 11pt suits a tight group of graphics or buttons. Where content must reach the edge, add `contentMarginsDisabled()` and inset the text by `widgetContentMargins`. A widget holds a few controls and never an app-like layout, and an inline accessory widget has one tap target.

A Live Activity supplies four layouts:

- The compact leading and trailing views read as one piece of information. They keep similar widths and sit snug against the camera.
- The minimal view shows live data, such as a remaining time, rather than only a logo.
- The expanded view keeps the compact view's placement and wraps close around the camera.
- The Lock Screen view takes 14pt margins, Apple's standard, and grows or shrinks with its content.

StandBy shows the Lock Screen view at twice the size, and `isActivityFullscreen` lets it rearrange for the space. For Apple Watch and CarPlay, add `supplementalActivityFamilies([.small])` and branch on `activityFamily`. Recipes are in [widgets.md](widgets.md).

## Mirror with leading and trailing

Stacks, `.leading`, `.trailing` and leading or trailing padding mirror in right-to-left on their own. Offsets, `.position`, geometry arithmetic, `Path` and `Canvas` do not. Progress, ratings and steps run from the leading edge, while a control that points to a real direction keeps it. Text direction belongs to `typography`, and directional symbols to `ui`. See [mirroring.md](mirroring.md).

## Before you finish

| Pattern | Fix |
| --- | --- |
| `.frame(width:)` or `.frame(height:)` on a view that holds text | A minimum, or no frame |
| `UIScreen.main` or `userInterfaceIdiom` deciding a layout | The size class, or the container's size |
| `GeometryReader` wrapping a whole screen | `containerRelativeFrame`, `onGeometryChange` or stacks |
| `.ignoresSafeArea()` on a view that holds text or controls | Move it to the background |
| `.edgesIgnoringSafeArea(_:)` | `.ignoresSafeArea(_:edges:)` |
| A hard-coded bottom or top padding for the home indicator or the Dynamic Island | The safe area, or `.safeAreaBar` |
| An action pinned with `ZStack` alignment and padding over a `ScrollView` | `.safeAreaBar(edge: .bottom)` |
| `.ignoresSafeArea(.keyboard)` on a container with a text field | Remove it |
| Keyboard notifications changing a frame or an inset | SwiftUI's own avoidance, or `keyboardLayoutGuide` |
| An `HStack` of label and value with no accessibility-size branch | `AnyLayout` switching to `VStackLayout` |
| `.offset(x:)` or `.position` placing content | Stacks, alignment or an aligned overlay |
| `leftAnchor`, `rightAnchor` or left and right `UIEdgeInsets` in UIKit | `leadingAnchor`, `trailingAnchor`, `NSDirectionalEdgeInsets` |
| `.listRowSeparator(.hidden)` across a grouped list | Keep the separators |
| A `ScrollView` inside a `ScrollView` on the same axis | One scroll view |
| A horizontal row of cards that ends exactly at the screen edge | `.contentMargins` with a peek |
| A hard-coded leading padding in a column that elsewhere uses `.padding()` | The system margin |
| Two prominent buttons on one screen | One prominent action |
| `.environment(\.layoutDirection, .leftToRight)` forced on a screen | Fix what does not mirror |
| `.padding()` on a widget's root view | Remove it, since the system's content margins apply |
| `contentMarginsDisabled()` with text against the edge | Inset the text by `widgetContentMargins` |
| A `widgetFamily` branch that only scales the small layout up | A layout for each family, or drop the family |
| Padding between `compactLeading` or `compactTrailing` content and the camera | Remove it |
| `.frame(height:)` on a Live Activity's Lock Screen view | Let the content set the height |

## Reporting

**Severity.** `HIGH` hides content or an action at a supported size. Four of `design-review`'s escalation triggers land here and are `HIGH` on sight. One is content or a control clipped, overlapped or unreachable at the narrowest width, at AX5 or with the keyboard shown. The others are a control outside the safe area, truncated content with no way to the full value and content past an edge with no cue. `MEDIUM` harms hierarchy, grouping, adaptivity or the mirror. `LOW` is isolated alignment or spacing polish.

**Verification.** Without Xcode, read every frame, padding, safe area modifier, stack and size-class branch in scope against the rules above. Look for fixed sizes on text and physical directions. With Xcode, preview the smallest and largest iPhones, a full-screen iPad and a narrow iPad window, each at AX5. Run once in the Double-Length pseudolanguage, once in the right-to-left pseudolanguage and once with the keyboard shown. Report every check you could not run as `Not verified`.

**Format.** Group findings under the principle each violates, ordered by severity, one row per root cause listing every location it appears in:

| Severity | Location | Before | After | Why |
| --- | --- | --- | --- | --- |

`Location` is `path/to/file.swift:line`. `Why` names the principle and the user impact.

End with `Block` when any `HIGH` remains, `Approve` otherwise, leaving the rest in the table as work to do. Never `Approve` coverage you did not inspect. With nothing to report, state "No actionable layout findings" and report verification.
