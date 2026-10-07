# Scenario axes

The axes **List the states and the worst cases** selects from. Each axis has a cue, the property of the view that makes it worth running. Where the cue matches, the axis stays. Where it fails, the axis is dropped and the drop is named in the list.

An axis that stays contributes the scenarios below. Add any value the view's own inputs make worse, such as the longest option in the real data. The values to feed are in [fixtures.md](fixtures.md#worst-case-values).

## Content length

**Cue: the view renders text it does not write itself**, such as people's input, server data or translations. A fixed label in the code fails the cue.

| Scenario | Catches |
| --- | --- |
| Empty string | Collapsed rows, a label with nothing beside it |
| One word | Controls sized for their longest expected label |
| Typical content | The baseline the others are judged against |
| Several sentences | Wrapping, rows that assumed one line |
| One string with no spaces | A long email, URL or compound word with nowhere to wrap |

Breaks land in `typography` for wrapping and truncation, `layout` where the container has no room and `writing` where the source copy is the problem.

## Content shape

**Cue: the text can come from people or languages the team does not write.**

| Scenario | Catches |
| --- | --- |
| Emoji, alone and inside text | Line height jumps, centering that drifts |
| Right-to-left text | Punctuation and alignment on the wrong side |
| Mixed-direction text | A left-to-right name inside a right-to-left sentence, and the reverse |
| Stacked diacritics and tall scripts | Clipped tops and bottoms in tight rows |
| Numbers that update or align in columns | Digits that jitter or misalign |

Breaks land in `typography`. Structure that fails to mirror lands in `layout`.

## Quantity

**Cue: the view repeats over items**, such as a list, a grid, a tag row or an avatar stack.

| Scenario | Catches |
| --- | --- |
| Zero items | A blank region, a missing empty state |
| One item | Grids designed around plural content, "1 items" |
| The realistic count | The baseline |
| Ten times the realistic count | A missing scroll, sticky content that stops sticking, slow rendering |

An empty region with no message lands in `writing`, and the region itself in `layout`. A wrong plural lands in `writing`, and the rest in `layout`.

## Images

**Cue: the view shows an image it does not bundle.**

| Scenario | Catches |
| --- | --- |
| No image | The placeholder, and whether it matches a real image's size |
| A failed load | An `AsyncImage` with no failure phase |
| A very wide or very tall image | Stretching, and cards that grow with the image |
| A transparent logo in dark appearance | An image that disappears into the background |

Size and aspect breaks land in `layout`. The placeholder and image outlines land in `ui`.

## Container

**Cue: always**, since the view does not choose its width.

| Scenario | Catches |
| --- | --- |
| The narrowest width it gets in production, as a fixed frame | Clipping, controls pushed off the edge |
| Beside a sibling in an `HStack` that takes the space | A view that refuses to shrink |
| The widest width it gets, such as a regular-width iPad | Stretched controls, lines too long to read |
| A compact and a regular `horizontalSizeClass` | Branches on the size class |

Breaks land in `layout`. A whole screen is checked on the smallest and largest iPhone and on iPad, in the canvas or the Simulator, rather than in fixed frames.

## State

**Cue: the view has the state**, as an input, a model property or a branch.

| Scenario | Catches |
| --- | --- |
| Loading | Content that jumps when it arrives, a spinner with no label |
| Error | Messages that overflow, color as the only signal |
| Disabled | Contrast that collapses, a control that still looks active |

Breaks land in `accessibility` for labels and announcements, `writing` for the copy and `color` for contrast.

## Environment

**Cue: always.** These settings reach every view, so the previews render them. The environment is how the system applies them, so the preview shows the real view.

| Setting | In the preview | Breaks land in |
| --- | --- | --- |
| The largest accessibility text size | `.dynamicTypeSize(.accessibility5)` | `typography`, `layout` |
| The smallest text size | `.dynamicTypeSize(.xSmall)` | `typography` |
| Dark appearance | `.preferredColorScheme(.dark)` | `color`, `ui` |
| Right to left | `.environment(\.layoutDirection, .rightToLeft)` with a right-to-left `\.locale` | `layout`, `typography` |
| Another locale's formats | `.environment(\.locale, Locale(identifier: "de_DE"))` | `writing` |
| Bold Text | `.environment(\.legibilityWeight, .bold)` | `typography` |
| Landscape | `#Preview("Landscape", traits: .landscapeLeft)` | `layout` |

These settings are read-only in the environment, so no preview can set them. Name each one for the user to toggle with Environment Overrides while the app runs in the Simulator:

| Setting | Breaks land in |
| --- | --- |
| Increase Contrast | `color` |
| Reduce Motion | `motion` |
| Reduce Transparency | `ui` |
| Differentiate Without Color | `accessibility` |

The Double-Length and right-to-left pseudolanguages run through the scheme's App Language, as `layout` names.
