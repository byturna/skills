---
name: accessibility
description: Reviews and fixes VoiceOver, Voice Control, keyboard, Dynamic Type, touch target, form and Reduce Motion support in SwiftUI and UIKit apps, against Apple's accessibility criteria.
---

# Accessibility

This skill reviews and fixes how an iOS app works with VoiceOver, Voice Control, Switch Control, keyboards, larger text and the display settings. It reports each failure as a task someone cannot complete, against Apple's accessibility criteria.

Reviewing means walks. Swipe through every element with VoiceOver and check its label, trait, value and order. Then say "Show names" in Voice Control, then repeat the screen at the largest accessibility text size. On iPad, also tab through it with Full Keyboard Access. When unsure, take the system control over a custom rebuild, and remove an accessibility modifier rather than add one.

Contrast measurement and color fixes belong to `color`. Text styles and custom font scaling belong to `typography`, and how a layout changes at accessibility sizes belongs to `layout`. Label, hint and error wording belong to `writing`. Animation recipes belong to `motion`, and materials under Reduce Transparency belong to `ui`.

## Tasks, not checkboxes

A finding is a common task someone cannot complete with an assistive technology or a display setting. It can also be an element that breaks Apple's criteria for an App Store accessibility label. Those labels are VoiceOver, Voice Control, Larger Text, Sufficient Contrast, Dark Interface, Differentiate Without Color Alone, Reduced Motion, Captions and Audio Descriptions. Everything else is a recommendation and never `HIGH`.

The 28×28pt minimum target and the contrast table are exact. The 44×44pt default target is a recommendation, so keep an established dense layout that clears 28pt. Cite Apple's criteria or the HIG, never a WCAG criterion number.

## System controls first

`Button`, `Toggle`, `Picker`, `Slider`, `Stepper`, `Menu`, `Link` and `NavigationLink` bring their label, trait, value, actions, Voice Control name and keyboard focus with them. `.onTapGesture` on a plain view brings none of these, so use it only where the view is not a control.

A custom control either wraps a system control in `.accessibilityRepresentation` or supplies its own label, trait, value and actions. See [voiceover.md](voiceover.md#custom-controls).

## Every element announces a name, a type and a state

Give every control and meaningful element a concise label. The label never names the control type or its state, because the trait and value carry those, so "Unsubscribe" with the toggle trait, not "Unsubscribe checkbox".

An icon-only button keeps its name with `.labelStyle(.iconOnly)` on a titled `Button`, or takes `.accessibilityLabel`. Never rely on the name VoiceOver derives from an SF Symbol. Repeated actions name their object, as in each cart row's "Delete Wireless Mouse". Add a hint only where the result of activating is not obvious from the label.

## Hide decoration, describe meaning

Decorative images take `Image(decorative:)` or `.accessibilityHidden(true)`, never on a view that contains a control. An informative image describes what it conveys, and a functional image names its action. A chart needs a summary and its data. Swift Charts provides an audio graph on its own, and a custom chart supplies one through `.accessibilityChartDescriptor`. Where users upload media, let them add a description. See [voiceover.md](voiceover.md#images-and-charts).

## Group what reads as one, in reading order

VoiceOver reads in view order, top to bottom and in the reading direction. Combine a row that reads as one with `.accessibilityElement(children: .combine)`, and keep a container's children separate with `.contain`. Reach for `.accessibilitySortPriority` only when the view order cannot be fixed.

Mark section headings with `.accessibilityAddTraits(.isHeader)`; `.navigationTitle` is the screen's title. Give long or structured content a rotor. A refresh or a page of new content never moves the VoiceOver cursor back to the top. See [voiceover.md](voiceover.md#grouping-and-order).

## Every gesture has another path

Swipes, long presses, drags, double taps and controls revealed on swipe each need a path through VoiceOver, Voice Control and Switch Control. `.swipeActions` and `.contextMenu` provide one automatically. A custom gesture does not, so add `.accessibilityAction(named:)` or `.accessibilityActions`.

Also give the core action an onscreen control, such as a close button beside swipe to dismiss. Prefer the simplest gesture that works, and never require a custom multifinger one. Recipes are in [touch-and-input.md](touch-and-input.md#gesture-alternatives).

## Modals contain VoiceOver, and focus follows the change

`.sheet`, `.fullScreenCover`, `.alert`, `.confirmationDialog` and `.popover` hide the content behind them from VoiceOver and support the escape gesture. A custom overlay is a finding unless it adds `.accessibilityAddTraits(.isModal)` and an `.accessibilityAction(.escape)`. It also moves focus inside with `@AccessibilityFocusState` and returns it on dismissal.

A content swap without navigation posts `AccessibilityNotification.ScreenChanged` for a new screen or `LayoutChanged` for a partial change. See [voiceover.md](voiceover.md#modality-and-focus).

## Announce what changes out of view

A status banner, completed background work or an error not tied to a field posts `AccessibilityNotification.Announcement`. Set its priority through `AttributedString`, and keep `.high` for errors that interrupt. Never announce what a focus move already reveals, and never on every keystroke. A value that changes continuously, such as a timer, takes the `.updatesFrequently` trait instead. See [voiceover.md](voiceover.md#announcements).

## Targets of 28pt or more, 44pt by default

A tappable area under 28×28pt is a finding, and one under 44×44pt is a recommendation. Grow the hit area inside the button's label with `.frame(minWidth: 44, minHeight: 44)` and `.contentShape(.rect)`, not by enlarging the glyph. Spacing between targets belongs to `layout`. Decorative overlays above a control take `.allowsHitTesting(false)`. See [touch-and-input.md](touch-and-input.md#targets).

## Voice Control says what the screen shows

A control's spoken name starts with its visible text. Add alternatives with `.accessibilityInputLabels`, visible text first, so "Tap Compose" works whatever the label says. Test with "Show names" and "Show numbers". System text fields support dictation and editing on their own, and custom text entry needs the same commands checked. See [touch-and-input.md](touch-and-input.md#voice-control).

## Keyboards reach everything on iPad

With a hardware keyboard, Full Keyboard Access reaches system controls without help. Build a custom control as a `Button` with a custom `ButtonStyle`, and never ship `.focusEffectDisabled()` without a visible replacement. Give primary and cancel actions `.keyboardShortcut(.defaultAction)` and `.keyboardShortcut(.cancelAction)`, and never override a system shortcut. See [touch-and-input.md](touch-and-input.md#keyboards).

## Label and type every field

A `TextField`'s title is its accessible label. In a `Form` the title also shows as the placeholder, which is native. Use `LabeledContent` where a filled value needs a label that stays visible.

Set `.textContentType` for AutoFill, plus the matching `.keyboardType`, `.textInputAutocapitalization` and `.submitLabel`. Never block paste, and never filter input in a way that rejects a pasted value. The tables are in [forms.md](forms.md#content-and-keyboard-types).

## Errors sit beside the field and reach VoiceOver

Show the error as text directly after its field, so VoiceOver reads it next. On a failed submit, move `@FocusState` to the first invalid field and announce the failure.

A toolbar Done or Add may stay disabled while a required field is visibly empty, as in Contacts and Calendar. Any rule the user cannot see validates on submit with an inline error. See [forms.md](forms.md#errors).

## Text scales to the largest accessibility size

Body and control text scale with Dynamic Type through the largest accessibility size. Nothing overlaps, and nothing truncates past use. Back buttons and tab bars may stay small, with `.accessibilityShowsLargeContentViewer()` so a long press shows them enlarged.

Truncated text keeps a way to the full value. Cap with `.dynamicTypeSize(...)` only chrome that cannot grow, never content. See [display-settings.md](display-settings.md#larger-text).

## Contrast meets Apple's table in both appearances

This skill decides which requirement applies to a pair. `color` measures it and owns the fix.

| Text size | Weight | Minimum |
| --- | --- | --- |
| Up to 17pt | All | 4.5:1 |
| 18pt and up | All | 3:1 |
| All | Bold | 3:1 |
| Controls and state indicators against what they sit on | All | 3:1 |

Disabled controls and logos are exempt. The table holds in light and dark appearances. A pair that fails by default passes only if Increase Contrast brings it up to the table. Text on a translucent surface is checked with Reduce Transparency both on and off.

## Color is never the only signal

Status, selection and values add a shape, a symbol, text or a position to their color. A color-coded chart labels its series or lets people choose another scheme. `accessibilityDifferentiateWithoutColor` may add further cues, but it never stands in for the default ones. Check a screen with the Grayscale color filter.

## Honor the display settings

Bold Text, Increase Contrast, Reduce Transparency, Smart Invert, Button Shapes and the dark appearance each change what a screen must do. System controls, text styles, semantic colors and materials follow them without help. Custom fonts, colors, translucency, button styles and media must be checked one by one. Photos, video and maps take `.accessibilityIgnoresInvertColors()`, and a dark screen never flashes white. What each setting requires is in [display-settings.md](display-settings.md).

## Reduce Motion removes the trigger, not the meaning

Read `@Environment(\.accessibilityReduceMotion)`. System navigation and sheets adapt to it; custom `withAnimation`, `.transition` and `.animation` do not.

Under it, decorative motion stops and meaningful motion becomes a dissolve, while motion that tracks a finger stays. Which animation falls where is in the table in [motion-and-media.md](motion-and-media.md#reduce-motion). The recipes belong to `motion`.

## Nothing the user needs runs on a timer

A banner carrying an action or an error stays until dismissed, and anything that moves or plays on its own can be paused. The rules for animated images, video, captions and audio are in [motion-and-media.md](motion-and-media.md#timers-and-media).

The UIKit forms of every API here are in [cheat-sheet.md](cheat-sheet.md).

## Before you finish

| Pattern | Fix |
| --- | --- |
| `.onTapGesture` on a view that acts as a button | `Button` |
| `Button { Image(systemName:) }` with no title and no `.accessibilityLabel` | A titled `Button` with `.labelStyle(.iconOnly)` |
| `.accessibilityLabel` containing "button", "checkbox", "selected" or "tap" | Move type and state into traits and the value |
| `.accessibilityHidden(true)` on a container holding a control | Hide only the decorative children |
| A `ZStack` or `.overlay` acting as a modal without `.isModal` | `.sheet` or `.fullScreenCover`, or add `.isModal`, an escape action and focus |
| `DragGesture`, `.onLongPressGesture` or a custom swipe without an accessibility action | `.accessibilityAction(named:)` and a visible control |
| A button label smaller than 28×28pt | `.frame(minWidth: 44, minHeight: 44)` with `.contentShape(.rect)` inside the label |
| `.font(.system(size:))` on body or control text | A text style; mechanics in `typography` |
| `.dynamicTypeSize(...)` on a screen or a content view | Cap only the bar, with the Large Content Viewer |
| `.focusEffectDisabled()` | Remove it, or draw focus from `@FocusState` |
| `withAnimation` or a `.move`, `.scale` or `.offset` transition with no Reduce Motion branch | A fade under `accessibilityReduceMotion` |
| `.repeatForever` or an auto-advancing `TabView` with no pause | A pause control, stopped under Reduce Motion |
| `AccessibilityNotification.Announcement` inside `.onChange` of a text field | Announce on submit or completion only |
| `TextField` for an email, password or code with no `.textContentType` | The matching content type from [forms.md](forms.md) |
| A photo, video or map view without `.accessibilityIgnoresInvertColors()` | Add it |

## Reporting

**Severity.** `HIGH` stops a common task with an assistive technology or setting. `MEDIUM` makes one meaningfully harder, such as a contrast pair that passes only under Increase Contrast. `LOW` is isolated polish, such as a target between 28pt and 44pt.

This domain's share of `design-review`'s escalation triggers is `HIGH` on sight:
- an element with no VoiceOver label or the wrong trait;
- a path reachable by touch but not by VoiceOver, Voice Control or Switch Control;
- a control a hardware keyboard on iPad cannot reach;
- a custom modal that leaves the content behind it reachable;
- body or control text that does not scale, or that clips at accessibility sizes;
- motion that ignores Reduce Motion;
- meaning carried by color, motion or haptics alone.

**Verification.** Without Xcode, read the code for every row in **Before you finish** and every custom control, gesture and overlay. With Xcode, run the Accessibility Inspector audit and `XCUIApplication.performAccessibilityAudit(for:_:)` in a UI test. Render previews at `.dynamicTypeSize(.accessibility5)` and in dark mode. Toggle Increase Contrast, Bold Text and Reduce Motion through Environment Overrides. A VoiceOver or Voice Control walk needs a person and a device, since the Simulator runs neither. Report every check you could not run as `Not verified`.

**Format.** Group findings under the principle each violates, ordered by severity, one row per root cause listing every location it appears in:

| Severity | Location | Before | After | Why |
| --- | --- | --- | --- | --- |

`Location` is `path/to/file.swift:line`. `Why` names the principle, the Apple criterion where one applies and the user impact.

End with `Block` when any `HIGH` remains, `Approve` otherwise, leaving the rest in the table as work to do. Never `Approve` coverage you did not inspect. With nothing to report, state "No actionable accessibility findings" and report verification.
