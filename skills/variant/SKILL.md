---
name: variant
description: Builds several genuinely different versions of one piece of a SwiftUI or UIKit screen behind a debug picker in the app, so you can flip between them and choose.
disable-model-invocation: true
---

# Variant

This skill takes one described piece of an iOS screen and builds three versions that differ on purpose. They go behind a picker in the real screen, in debug builds only, so you can flip between them and choose.

It produces candidates and never ranks them. Reviewing existing work is `design-review` and `change-review`, rendering one view's states is `previews` and building from a finished design is `build-design`. The UIKit form of every API here is in [cheat-sheet.md](cheat-sheet.md).

## Different answers, not different tints

Each variant is a different answer to the same brief, on an axis one domain skill owns:

| Axis | Owner | What varies |
| --- | --- | --- |
| Structure | `layout` | Grouping, order, column count, what collapses |
| Density | `layout` | Spacing, how much fits |
| Emphasis | `color` | Where the tint and filled color go, what recedes |
| Type | `typography` | Which text styles, weight contrast |
| Voice | `writing` | Labels, tone, how much copy |
| Surface | `ui` | Glass, a material or a plain background, symbol treatment |
| Motion | `motion` | Whether and how it moves |
| Presentation | `navigation` | Inline, pushed, in a sheet or in a popover |

Pick one primary axis and give each variant a different position on it. Secondary choices follow from it rather than varying on their own. A dense variant may need a smaller text style, and that is coherence, not a second axis.

## The floor every variant clears

Every variant follows the domain skills' rules, and before it enters the picker it clears `design-review`'s escalation triggers. No variant may show any of these:

- An interactive element with no VoiceOver label, or exposed without its button, toggle or adjustable trait
- A control reachable by touch but not by VoiceOver, Voice Control or Switch Control
- A control a hardware keyboard on iPad cannot reach, or one with `.focusEffectDisabled()` and no replacement
- A custom modal that leaves the content behind it reachable by VoiceOver
- Motion or autoplaying content that ignores Reduce Motion
- A state change carried by motion or haptics alone
- Body or control text that does not scale with Dynamic Type
- Content or a control clipped, overlapped or unreachable at the largest supported accessibility text size, at the narrowest width or with the keyboard shown
- A control outside the safe area, under the status bar, the Dynamic Island or the home indicator
- Truncated content with no way to reach the full value
- Content or a control past a scroll edge or behind a disclosure with no visible cue
- Body or control text whose rendered contrast pair fails its required ratio, in either appearance
- State or meaning carried by color alone
- A semantic color used against its meaning
- A destructive action with no confirmation, undo or distinct treatment
- An error that names no way to recover

The floor is identical across variants. It is not an axis and never trades against one. Where a direction can only work by breaking it, say so and drop the direction.

## 1. Scope one piece

One piece per run. "The home screen" is not a piece, and the activity card on it is. Where the request spans several, list the candidates and ask which one to explore.

Restate the brief in one sentence: what the piece is, which screen it lives on and what it has to do.

## 2. Learn the ground

Variants have to look as though they could ship tomorrow, so read what they stand on:

- The deployment target, which decides which APIs a variant may use.
- The SwiftUI and UIKit mix, the color sets, text styles, spacing constants and shared views.
- The product's density and voice. A dense professional tool bounds how far the boldest variant may go.
- Where the piece renders: on which screen, beside which neighbors, in which size classes and appearances.

With no project to read, build from system colors, the tint, text styles and SF Symbols, and say that is what you did.

## 3. Name the axis before writing code

Build three variants by default, and up to five only when asked. Write the set down first, a name and an axis position each. Names say what the direction is, such as `Quiet`, `Editorial` or `Dense`, never `Option A`.

This step is done when no two variants share a position and you can state each one's axis in a phrase.

## 4. Build it into the real screen

Host the variants in the screen that will contain the piece, with its real bars, real neighbors and realistic data. A picker over the screen switches between them, and an `@AppStorage` key holds the choice, so a relaunch keeps it. The picker, the hosting code and the variant files all sit inside `#if DEBUG`, so nothing reaches a release build. The picker's spec and the hosting code are in [picker.md](picker.md).

Render one variant at a time, at full size. Spacing is usually the thing you are choosing between, and only the real screen shows it.

Variant views may use the project's shared views and styles. Only the hosting screen refers to a variant, and nothing else refers to the variant files. Give each variant a `#Preview` in its real container, so the canvas compares them without a run.

Give every variant real content: product-shaped copy, plausible names and the number of items the screen really carries. Placeholder text and three rows make every structure look good.

## 5. Present the tradeoffs and stop

With Xcode, run the app once and flip through every variant. Each one renders, each interaction responds and Xcode shows no runtime warnings. Look at the smallest iPhone, the largest iPhone and an iPad where the app supports it, and at one accessibility text size. Without Xcode, as in a Linux or cloud session, say so, mark the look `Not verified` and say how to open the screen and use the picker.

Then hand the decision over:

| Variant | Axis position | Right when | Costs |
| --- | --- | --- | --- |
| Quiet | Lowest visual weight | The screen is used daily | Least memorable |
| Editorial | Largest text styles, most space | The moment deserves weight | Pushes content below the fold |

Say which devices and text sizes you judged at, since the answer can change between them. Never mark a favorite in the table. Asked directly, answer from how often the piece is seen and from the product's personality, not from which one you enjoyed building.

## 6. Promote one, delete the rest

On a choice, build that variant properly where it belongs, following the project's conventions. Then delete the other variants, the picker and the hosting code. Search for the variant names and the `__variant` key, and check that the diff leaves nothing of the harness behind.

Asked for another round instead, keep the harness and run **Name the axis before writing code** again, taking new positions around the direction the user leaned toward.

## Before you finish

| Pattern | Fix |
| --- | --- |
| Variants that differ only in tint or copy | Move one to a different position on the primary axis, or cut it |
| Every axis varying at once | Vary one, and let the rest follow from it |
| Variants judged in a bare preview or a blank screen | Host them in the screen that will contain the piece |
| Placeholder text, three rows, "Jane Doe" | Real copy and the item count the screen really carries |
| The boldest variant with a fixed font size, or missing a VoiceOver label | Clear the floor or drop the direction |
| A favorite marked in the table | State each variant's cost and let the user choose |
| The picker in glass, the tint or the project's colors | Keep it visibly outside the design system |
| A variant, the picker or the hosting code outside `#if DEBUG` | Wrap it |
| The harness left behind after promotion | Delete it, then search for the names and `__variant` |
