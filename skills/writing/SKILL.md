---
name: writing
description: Writes and checks the words in SwiftUI and UIKit apps, from buttons, alerts and errors to empty states, permission requests and notifications, in one voice and ready to translate.
---

# Writing

This skill writes and reviews the words an iOS app shows, along with the terms that run through them. It matches the app's existing voice, follows Apple's conventions for each component and keeps every string whole for translation.

How text renders, including displayed capitals, truncation and typographic punctuation, belongs to `typography`. Whether an element has an accessibility label, where an error appears and how it reaches VoiceOver belong to `accessibility`. Which presentation a message uses belongs to `navigation`, and room for longer translations to `layout`. The UIKit form of every API here is in [cheat-sheet.md](cheat-sheet.md).

## Clarity is a finding, taste is not

A deliberate voice is not a defect. Raise a departure from plain language only where it creates inconsistency, ambiguity, translation risk or a tone the stakes do not support. Rewording that merely suits your taste is not a finding.

Apple's conventions below are the default where the project has none, and a project's consistent convention wins over them. Copy that misleads, hides the way to recover or cannot be translated is a finding in any voice.

## Inventory the strings first

Before writing or reviewing, find where the copy lives and read the copy around the change. The places to search are in [strings.md](strings.md#where-strings-live). Copy may also come from a server.

List the noun used for each object and the verb used for each action, as in "project" or "workspace" and "Delete" or "Remove". Note the capitalization each element type uses. New copy uses the terms on that list, and a synonym is a finding only where one thing is named two ways.

## One voice, one vocabulary

The app's existing copy sets its voice, and a local edit never invents a new one. If it's Archive in the menu, it isn't Move to Storage in the dialog. Tone flexes with the stakes:

| Context | Tone |
| --- | --- |
| Success, onboarding and empty states | Warm, can be light |
| Routine actions and settings | Neutral and brief |
| Errors and destructive confirmations | Calm and plain, never playful |
| Data loss, security and privacy | Serious and explicit |

A flow uses one vocabulary from start to end. Get Started enters it, either Continue or Next advances it and Done ends it. The system's own words name the system's actions, such as Cancel, Done, Close, Edit and Share.

## Address people as you

Write "you", never "the user". Avoid "we", which leaves people unsure who is speaking, and never use it in an error. "Unable to load messages" is clearer than "We're having trouble loading your messages".

Use possessives sparingly, since "Favorites" says what "Your Favorites" says. Never switch perspective within the app, as in My Account beside Your Settings.

## Plain words, and the device's verbs

Choose words a tired reader gets on the first pass, and cut every word that does no work. Avoid idioms, humor and jargon that will not translate, and define a technical term before relying on it. Leave out gender where it adds nothing: "Subscribers can post recipes", not "A subscriber can post his or her recipes".

People tap on iPhone and iPad, so never write "click". To point at a control in text, write "choose" and its exact title without quotes, which holds for touch, pointer and keyboard alike.

## Capitalization follows the component

Apple sets the style for most components:

| Element | Style |
| --- | --- |
| Button, menu item, notification action and undo action name | Title style, no ending punctuation |
| Alert or dialog title | Title style with no ending punctuation for a fragment, sentence style with its punctuation for a full sentence |
| Notification title | Title style, no ending punctuation |
| Alert message, footer, description, error, purpose string and notification body | Sentence style in complete sentences, with ending punctuation |
| Navigation title, tab label and list row label | The project's style, or title style where it has none, as in the system apps |

Any other element type takes one style of the project's choosing. A project that uses another style for an element type throughout keeps it. Mixed styles within one element type are the finding, such as Save Changes beside Discard changes. Which words title style leaves lowercase is in [patterns.md](patterns.md#title-style).

## Every string goes through the catalog

Every word people see passes through a localizable API, so Xcode extracts it into the String Catalog. A string literal in `Text`, `Button` or `Label` is localized on its own. A `String` variable passed to `Text` is shown verbatim. So a property that holds copy is a `LocalizedStringResource`, and copy built outside a view uses `String(localized:)`.

Reference strings the way the project already does, by literal key or by the symbols Xcode generates. Comment a key wherever its words leave a translator guessing, such as a one-word label that could be a noun or a verb. Write the source language only, and leave other languages to translators unless asked. See [strings.md](strings.md#localizable-apis).

## Build strings whole

A sentence is one key with its values interpolated, because word order changes between languages. Never assemble one from fragments with `+` or `String(format:)`. A count takes the catalog's plural variants rather than `count == 1 ?`, since many languages have more than two plural forms. Dates, numbers, currencies, measurements, names and lists pass through a `FormatStyle`, never a fixed format. The recipes are in [strings.md](strings.md#plurals) and [strings.md](strings.md#values).

## Buttons start with a verb

A button names the result of tapping it and starts with a verb, as in Send, Save Draft and Delete Project. Never Let's Go, and never Yes or No. OK answers only an alert that purely informs, and Cancel always cancels. An alert's buttons take one or two words tied to its text, such as Try Again or View All.

Menu items leave out articles. Add an ellipsis to one that asks for more before it acts, as Rename… does. A toggled item says what it will do, Show Map or Hide Map.

An icon-only button's accessibility label is the same verb phrase. It names the action, "Delete Project", never the glyph, "Trash". A hint describes the result without naming the element or the gesture: "Selects the message", not "Tap this row to select the message". Whether a label or hint is needed belongs to `accessibility`.

## Links name their destination

Link text makes sense out of context, since VoiceOver users can move from link to link. Write "Learn more about exports", never "Click here". Two "Learn more" links on one screen each name what they lead to.

## Settings describe the on state

Label a toggle for what happens when it is on: Send Read Receipts, never Don't Send Read Receipts. People infer the off state. Add a footer only where the label cannot say enough.

Send people to a setting with a button that opens it, never a path to follow by hand. `UIApplication.openSettingsURLString` opens the app's page in Settings, and `openNotificationSettingsURLString` its notification settings. See [patterns.md](patterns.md#links-to-settings).

## Errors say what happened and how to fix it

An error states the fix: "Choose a password with at least 8 characters", not "That password is too short". Phrase it positively, as in "Use only letters for your name", not "Don't use numbers or symbols". Never blame, never write "Oops" and never end on an exclamation mark. "Invalid name", "Error" and a bare error code tell people nothing.

An alert for a failure not tied to a field names it in its title, such as Couldn't Save Note. Its message gives the reason and the next step. Show a known requirement in the footer before people type, not only in the error. When one error keeps firing, change the interaction rather than the words. See [patterns.md](patterns.md#errors).

## Common deletions undo, rare ones confirm

Never confirm a common action people can undo, such as deleting a message or archiving a project. Act at once and keep it recoverable, through a Recently Deleted list or an undo. Name each registered undo with `setActionName(_:)` in a word or two, since the system adds "Undo" before it.

Confirm before an action that cannot be undone or is rare, and before one that affects other people or many items at once. The dialog answers itself without its message:

- The title names the action and the object, never "Are you sure?".
- The message says what is lost for good, with counts where they apply.
- The destructive button repeats the verb and the object, such as Delete Project, beside Cancel.

Templates are in [patterns.md](patterns.md#destructive-actions). Which presentation asks and the destructive role belong to `navigation`.

## Empty states point forward

An empty screen says what belongs there and how to fill it, with one action to do so. Build it with `ContentUnavailableView`. The title names what is missing, such as No Projects. The description says what will appear, and the one action creates the first item.

An empty search takes `ContentUnavailableView.search(text:)`, which names the query. A filtered view that shows nothing offers to clear its filters. An empty state disappears once content arrives, so never park information there that people still need afterward. See [patterns.md](patterns.md#empty-states).

## Permission requests say why, when it matters

Ask for access when people first use the feature that needs it, never at launch unless the app cannot work without it. The purpose string is one complete, active sentence in sentence style, ending in a period. It says what the app does with the access. App Review requires that it "clearly and completely" describe that use.

A screen shown before the system alert has one button, titled Continue or Next and never Allow. It offers no way to skip the alert. After a denial, the feature says what it needs, links to Settings and offers a way forward without access where one exists. Examples and where purpose strings live are in [patterns.md](patterns.md#permission-requests).

## Notifications carry content, not instructions

A notification's title is specific, such as an event name or a headline, in title style. Where only a generic title would fit, leave it out and the system shows the app's name. The body is complete sentences in sentence style. Neither repeats the app's name or holds anything people would not want seen on a Lock Screen.

Never tell people to do something in the app, which they forget once the notification is gone. Set each category's `hiddenPreviewsBodyPlaceholder` to a generic phrase, such as "New comment", for people who hide previews. An action title names its result, never only opening the app. Errors go in an alert, never a notification. See [patterns.md](patterns.md#notifications).

## Placeholders show the format

In a `Form`, a text field's title doubles as its placeholder, which `accessibility` covers. Where a visible label names the field, its `prompt:` shows a realistic example in the accepted format, such as name@example.com, never an instruction. A search prompt names what the search covers, such as "Search recipes".

## Before you finish

| Pattern | Fix |
| --- | --- |
| A `String` property holding copy, passed to `Text` or `Button` | `LocalizedStringResource`, or `String(localized:)` where it is built |
| `Text(verbatim:)` on copy people read | `Text("…")` |
| `+`, `String(format:)` or `.joined()` assembling a sentence | One key with its values interpolated |
| `count == 1 ?` choosing a word | Plural variants in the catalog |
| `DateFormatter` with a fixed `dateFormat`, or a number built with `String(format:)` | A `FormatStyle` |
| `", "` and `" and "` joining names | `.formatted(.list(type: .and))` |
| `Button("OK")` in an alert that confirms an action, or `"Yes"` and `"No"` | Verb plus object |
| `"Are you sure"` in a title | Name the action and the object |
| `"Error"` as an alert title, or an error code alone | What failed, then the next step |
| `Oops`, `Uh-oh`, `!` or `we` in an error string | A plain statement of what failed and the fix |
| `successfully` in a status | Cut it: "Changes saved" |
| `Please` in a routine instruction | Cut it |
| `click` in a string | `tap`, or "choose" and the control's title |
| `the user` in copy | `you` |
| A `Toggle` label starting with `Don't`, `Disable` or `Hide` | Describe the on state |
| `.accessibilityLabel` naming a glyph, such as `"Trash"` or `"X icon"` | Name the action |
| `.accessibilityHint` starting with `"Tap"` or `"Double-tap"` | Describe the result: "Selects the message" |
| Save Changes beside Discard changes, or any mixed case in one element type | One style per element type |
| An `.alert` or `.confirmationDialog` around a common, recoverable action | Act at once and offer recovery |
| `registerUndo` with no `setActionName` | Name the action |
| `ContentUnavailableView` with no description or action, or `Text("No results")` alone | Say what fills it, and offer the action |
| A `UsageDescription` that is passive, vague or an instruction | One active sentence on how the app uses it |
| A screen before a permission alert with a button titled Allow, or a Cancel | One button, Continue or Next |
| A notification `title` that is the app's name or a generic label | A specific title, or none |
| `UNNotificationCategory` with no `hiddenPreviewsBodyPlaceholder` | A generic phrase for hidden previews |
| Two identical "Learn more" links, or "Click here" | Name each destination |

## Reporting

**Severity.** `HIGH` misleads people or hides how to recover. Two of `design-review`'s escalation triggers land here and are `HIGH` on sight. They are an error that names no way to recover and a destructive action with no confirmation, undo or distinct treatment. A purpose string that does not say how the app uses the access is `HIGH` as well, since App Review requires one that does. `MEDIUM` breaks voice, terminology or capitalization consistency, or leaves a string that cannot be translated. `LOW` is isolated wording polish.

**Verification.** Without Xcode, read every string in scope against the rules above. That covers literals in views, String Catalogs, purpose strings and notification content. Check each label against the action it invokes, each error for a fix and each term against the inventory. Report copy from a server you could not see as `Not verified`. With Xcode, build so the catalog picks up new strings, and confirm each one appears there. Preview each state that carries copy, such as empty, error, confirmation and denied access, and read every rendered string. Report every check you could not run as `Not verified`.

**Format.** Group findings under the principle each violates, ordered by severity, one row per root cause listing every location it appears in:

| Severity | Location | Before | After | Why |
| --- | --- | --- | --- | --- |

`Location` is `path/to/file.swift:line`, or the catalog key for a string that lives only there. `Why` names the principle and the user impact.

End with `Block` when any `HIGH` remains, `Approve` otherwise, leaving the rest in the table as work to do. Never `Approve` coverage you did not inspect. With nothing to report, state "No actionable writing findings" and report verification.
