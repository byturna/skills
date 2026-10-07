---
name: build-design
description: Builds SwiftUI or UIKit views from a Figma file or design image, using the project's tokens, components and system controls, then compares the result against the design.
---

# Build design

This skill turns a design into an iOS view that matches it. It reads the design at its source, builds with what the project and the system already have, then compares the result against the design before calling it done.

It owns no domain rules. Where a design breaks one, build it as designed and report the conflict to the skill that owns the rule: `accessibility`, `navigation`, `layout`, `writing`, `typography`, `color`, `ui` or `motion`. Reviewing finished work is `design-review`, exploring alternatives is `variant` and rendering states and worst cases is `previews`. The UIKit form of every API here is in [cheat-sheet.md](cheat-sheet.md).

## The design decides, the system draws

Values come from the design file, never from your taste or a pattern you liked elsewhere. A change the design does not show is a deviation, and a deviation is the user's call.

The exception is a part of the screen the system draws. A status bar, navigation bar, tab bar, toolbar, sheet, keyboard or home indicator in the design stands for the system component. Build it with the system API, even where the design draws it differently, and report the difference. Requirements the design cannot show, such as VoiceOver labels and traits, go in without asking.

## 1. Read the design at its source

A Figma link means the Figma MCP server. Search the available and deferred tools for `figma` before saying it is unavailable, since the server often sits under a name you did not expect. A server that lists only an authenticate tool is connected but signed out, so ask the user to sign in. With no Figma tool at all, ask the user to connect one, and build nothing from memory meanwhile. Which tools to call and what to trust are in [figma.md](figma.md).

A screenshot has no values to read. Work out its scale from the pixel size: 1179×2556 is a @3x capture of a 393×852pt screen. State the scale you assumed and treat every measurement as an estimate. Ask for the Figma link when one exists, since it replaces the whole estimate.

Scope the run to the frames named. Frames that show one screen on several devices, or in light and dark, are one piece with several targets, not separate pieces.

This step is done when you hold a screenshot of every frame in scope and its values for spacing, size, radius, color, type and the components used. From a Figma file they are exact. From an image they are estimates at the scale you stated.

## 2. Map the design onto the project

Read the project's color sets, text styles, spacing constants and shared views before writing anything. Then map every design value to what exists, by the table in [mapping.md](mapping.md). In short, a token maps to the project's token, an instance from Apple's iOS UI Kit maps to the system control and a project component maps to the project's view.

Text always maps to a text style or the project's type role, never to a fixed size. Positions map to stacks, alignment and spacing, never to the coordinates the design file holds. Figma's points are SwiftUI's points.

Never add a color set, a text style or a component variant to hit a number. Stop and ask when rounding would visibly change the design. That means more than 2pt on spacing or size, or a color landing on a different step.

Check what data the design needs and wire it to what exists. Where the source for part of it does not exist yet, build that part from parameters and name it in the report as unwired.

## 3. Build only what the design shows

Build the frames, the device sizes they define and the states the file draws, such as empty or error. A state the file does not draw is not yours to design. Leave it to the existing view's default and list it as missing.

Dynamic Type, dark appearance, Increase Contrast and right to left are not undrawn states. Text styles, semantic colors and leading and trailing edges carry them without a design. List each one the file does not draw as not compared.

Leave everything around the piece as it was: no neighboring copy edits, no symbol swaps and no cleanups on the way past. A diff wider than the design is the most common way this goes wrong.

## 4. Compare against the design

Render the build at each frame's size beside the design screenshot, and walk it element by element. Compare the properties **Read the design at its source** collected. "The gap is 12pt and the design says 16pt" is a finding. "It feels a bit tight" is not.

With Xcode, render a preview or run the Simulator device whose size matches the frame, and capture it with `xcrun simctl io booted screenshot`. Without Xcode, as in a Linux or cloud session, name the previews and devices to check and say the comparison is `Not verified`. Never report a match you did not look at.

Fix every mismatch you caused, then compare again. This step is done when every remaining difference is a rounding, a system component or a question.

## 5. Report and stop

| Element | Design | Built | Status |
| --- | --- | --- | --- |
| Card padding | 16pt | `.padding()` | Matches |
| Title | SF Pro 21pt Semibold | `.title3`, 20pt Semibold | Rounded to a text style |
| Tab bar | Opaque bar with a top line | `TabView` | System component |
| Badge | Filled capsule | Text label | Deviates, asked: no badge view exists |

Then list, one line each, and leave out a list with nothing in it:

- **Unwired.** What renders from parameters until its source exists.
- **Missing states.** What the design does not draw.
- **Not compared.** Text sizes, appearances and directions the design does not draw.
- **Domain conflicts.** Where the design breaks a rule, with the owning skill.

Close by saying which previews or devices you compared.

## Before you finish

| Pattern | Fix |
| --- | --- |
| "Figma isn't connected" written before any tool search | Search the tools for `figma` first |
| Values in code that appear in no Figma response, only in the screenshot | Read them from the design context |
| React, Tailwind or `className` from the design context in the diff | Translate it through the mapping |
| `.font(.system(size:))` or `Font.custom` with a fixed size from the design | A text style, or the project's type role |
| `Color(red:green:blue:)` or a hex value from the design | The project's color set, or the system color for that role |
| `.frame(width:)` equal to the frame's device width, or `.position` and `.offset` from layer coordinates | Stacks, alignment and spacing |
| A hand-built tab bar, navigation bar, status bar or home indicator | The system component, with the difference reported |
| A PNG exported from an SF Symbols layer | `Image(systemName:)` |
| A Figma asset URL in the code | The asset downloaded into the asset catalog |
| A new view file for a group that is not a component | Build it in place |
| A loading or error branch the design never drew | Remove it, keep the default and list it as missing |
| Files in the diff that no frame touches | Revert them |
| A color, size or contrast change the design does not show | Restore the design and report the conflict with its owner |
| A comparison claimed with no render of the build | Render each frame's size, or mark it `Not verified` |
| Hard-coded sample data with no mention in the report | List it under **Unwired** |
