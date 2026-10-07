# Judgment calls

Calls made while converting the skills that the owner has not decided explicitly. Decisions the owner did make are under **Decisions** in [README.md](README.md) and are not repeated here.

Each row names the call, where it lives, how firm its basis is and the alternative. Mark a row kept or flipped. A flipped call changes its skill in a pull request of its own, with a version bump.

The basis column uses five values:

| Basis | Means |
| --- | --- |
| Apple | Apple's documentation or the HIG says it, and the skill follows |
| Source | Carried over from Jakub's or Emil's rule, with no Apple number behind it |
| Judgment | Chosen during the conversion, where Apple and the sources were silent |
| Behavior | Known iOS behavior that Apple's documentation does not state |
| Process | How the repository is run, not what a skill says |

## Repository and process

| Call | Where | Basis | Alternative |
| --- | --- | --- | --- |
| Claude Code only: no `agents/openai.yaml` or `opencode.json` | `AGENTS.md` | Judgment | Ship configs for other agents too |
| One plugin, with `write-swift` inside it | `.claude-plugin/` | Judgment | A second plugin for `write-swift`, so interface work and Swift work install separately |
| Not converted: Jakub's `explain-interface`, Emil's `mobile-native`, `pick-ui-library`, `ask-sonner`, `improve-animations` and `performance-cheatsheet.md` | `plan/README.md` | Judgment | Convert `explain-interface` as a verb skill that walks someone through a screen |
| Snippet check files live outside the repository, so a later edit cannot be rebuilt against them | Session scratchpad | Process | Commit them under a `checks/` directory, accepting that the plugin then ships Swift files nobody runs |
| Every domain skill ends its standalone review with `Block` or `Approve`, Jakub's format | Every `## Reporting` | Source | A softer verdict, or none outside `design-review` |
| A finding outranks a preference only with evidence, and a consistent project convention is never a finding | Every calibration section | Source | Report deviations from Apple's defaults even where the project is consistent |

## Conflicts between the sources

Settled in the plan's conflicts table so no skill argues them again.

| Call | Where | Basis | Alternative |
| --- | --- | --- | --- |
| System button styles own press feedback; only a custom `ButtonStyle` scales, to `0.97` | `motion` | Judgment | Jakub's `0.96`, or no scale at all on custom styles |
| Springs for movement, timing curves only for opacity and color | `motion` | Judgment | Allow curves from a design spec for movement too |
| One stagger value per project, `0.05`s as the start | `motion` | Judgment | Jakub's `0.1`s, or Emil's 30–80ms range |
| A rule people cannot see validates on submit, with its error beside the field; a visibly empty required field may keep Done disabled | `accessibility` | Judgment, plus the owner's decision on Done | Validate as people type |
| Text is not selectable by default; content people copy opts in | `typography` | Apple | Jakub's web rule, selectable by default |
| Review output follows Jakub's format, not Emil's | Every `## Reporting` | Judgment | Emil's format |

## Cross-skill

| Call | Where | Basis | Alternative |
| --- | --- | --- | --- |
| Haptics belong to `motion`, not `ui` | `AGENTS.md` | Judgment | `ui`, as the second audit proposed |
| The 12pt and 24pt clearances live in `ui` as iPad pointer hit-region padding, not in `layout` as control spacing | `ui` pointer file | Apple | Keep them in `layout` as visual spacing between controls |
| Vibrancy and foreground color on materials belong to `color`, so `ui` only hands off | `ui` | Judgment | Keep vibrancy with the material in `ui` |
| How toolbar items group on their shared glass belongs to `ui`, and where they go to `navigation` | `ui`, `navigation` | Judgment | Put all toolbar rules in `navigation` |
| `accessibility` accepts a custom overlay modal that contains VoiceOver; `navigation` still reports it as `MEDIUM` and asks for a system presentation | `accessibility`, `navigation` | Judgment | Ban custom modals outright in one skill |

## accessibility

| Call | Where | Basis | Alternative |
| --- | --- | --- | --- |
| A finding is a task someone cannot complete, or a break of an App Store accessibility label's criteria; everything else is a recommendation and never `HIGH` | **Tasks, not checkboxes** | Judgment | Grade any missed best practice as a finding |
| Hints only where the result of activating is not obvious from the label | **Every element announces a name, a type and a state** | Apple | Hints on every control |
| Never announce on every keystroke; a continuously changing value takes `.updatesFrequently` instead | **Announce what changes out of view** | Apple | Announce each change |

## motion

| Call | Where | Basis | Alternative |
| --- | --- | --- | --- |
| A frequency table decides whether something animates at all: none on constant interactions, delight only at the rare end | **Decide whether it moves at all** | Source | Let the design decide per animation |
| Bounce is `0` unless a gesture flung the motion | **Springs for movement, curves for fades** | Judgment | Allow small bounce on playful UI |
| `keyframeAnimator` and `phaseAnimator` never drive a state people can toggle back | **Never make people wait for motion** | Source | Allow them where the sequence is short |
| The spring table uses `.spring(response:dampingFraction:)`, because Apple documents no conversion to `bounce` | `springs-and-timing.md` | Apple | Convert to `duration` and `bounce` by the common formula |
| Haptics named only for the controls the HIG lists; swipe actions and context menus were left out | `haptics.md` | Apple | Claim system haptics for every system control |
| Drag recipe values `0.4` duration and `0.2` bounce, and a `1.5`s hold to delete | `gestures.md` | Judgment | Leave the numbers to the design |

## ui

| Call | Where | Basis | Alternative |
| --- | --- | --- | --- |
| A shadow or a depth-only border on a content card is a finding; elevation comes from background levels | **Background levels show elevation** | Apple, from the dark mode base and elevated colors | Keep shadows as a project choice |
| Image outlines kept: a 1pt line in `Color.primary.opacity(0.1)` | **Outline images that could merge with the background** | Source | Drop the rule, since Apple publishes nothing on it |
| Custom glass on a button goes through `.buttonStyle(.glass)` first; morphing shapes use `.glassEffect` with IDs | **Custom glass goes through the glass APIs** | Apple | Allow hand-built glass where a design asks for it |
| An enclosed symbol such as `play.circle.fill` beats a glyph centered in a shape of your own | **Optical corrections live in the asset** | Judgment | Allow an `.offset` nudge on any glyph |
| A large hoverable element changes tone on `.onHover` rather than scaling, because the custom hover closure is visionOS only | **Pointer effects on iPad come from the system** | Apple | Scale with `.hoverEffect(.lift)` anyway |
| An app that sets `UIDesignRequiresCompatibility` skips the glass rules | **The system draws most surfaces** | Judgment | Report the opt-out itself as a finding |

## typography

| Call | Where | Basis | Alternative |
| --- | --- | --- | --- |
| Light weights are kept to a large display number judged on screen, with no size threshold | **Regular weight and up** | Apple, which gives no threshold | Jakub's 28pt threshold |
| A custom font that ignores Bold Text is `MEDIUM` | `## Reporting` | Judgment | `HIGH`, as an accessibility failure |
| Mixed-direction values take Unicode isolates only when they visibly reorder | **Mixed scripts keep their order and height** | Behavior | Isolate every interpolated user value |
| A custom role starts at the size of the system style it stands in for | `custom-fonts.md` | Judgment | Take sizes from the design's own scale |
| The 60–75 character measure is dropped; only a readable width on iPad survives, in `layout` | **Let the text set the size** in `layout` | Judgment | Keep a measure rule in `typography` |
| Never propose a new typeface unless the task asks for a type change | **Text styles first, values second** | Source | Suggest a type change where the current face fails legibility |

## layout

| Call | Where | Basis | Alternative |
| --- | --- | --- | --- |
| The space between groups is clearly larger than within them, twice as a starting point | **Group with space, then shape, then lines** | Source | No number |
| Beyond three secondary actions, the rest go in a `Menu` | **One prominent action per screen** | Source | Leave the count to the design |
| One prominent action per screen | **One prominent action per screen** | Source, with the HIG's one primary toolbar action | Allow two where they are true alternatives |
| A readable width in SwiftUI is one project-defined `maxWidth`, since SwiftUI has no readable guide | `adaptivity.md` | Judgment | Name a value, such as 672pt |
| Offsets, `.position`, geometry math, `Path` and `Canvas` do not mirror in right-to-left | **Mirror with leading and trailing** | Behavior | Confirm each case on a device before listing it |
| Playback controls keep left-to-right order | `mirroring.md` | Apple, through UIKit's `.playback` attribute | Mirror them with the rest |
| Four escalation triggers land in `layout` and are `HIGH` on sight | `## Reporting` | Judgment | Leave the clipping and truncation triggers to `accessibility` |

## navigation

| Call | Where | Basis | Alternative |
| --- | --- | --- | --- |
| Swipe to dismiss is disabled only while there are unsaved changes, and Cancel confirms the discard | **Every modal names its task and its way out** | Judgment, since SwiftUI has no dismiss-attempt callback | Always allow swipe to dismiss and autosave a draft |
| Forcing `.presentationCompactAdaptation(.popover)` on iPhone is a finding beyond a few controls | **Popovers in regular width only** | Apple | Allow it for small, menu-like content without a count |
| Five or fewer default tabs | **Tabs switch sections, toolbars act** | Apple, from the iPad customization note | No number, only "avoid overflow" |
| Several Booleans driving sheets on one view are replaced by one optional value | **One modal at a time** | Judgment | Allow Booleans where the sheets cannot overlap |
| A top-level screen keeps its large title | `structure.md` | Apple | Leave the title mode to the design |

## color

| Call | Where | Basis | Alternative |
| --- | --- | --- | --- |
| A custom color standing in for a system one is a finding, and custom ramps are for the brand, the accent and product categories | **System colors first** | Apple | Allow a custom neutral ramp where the brand calls for one |
| Roles are color sets filled from the ramp, and the ramp itself is never referenced, because a color set cannot point at another | **Views reference roles, never the palette** | Judgment | Roles in code, built with `UIColor(dynamicProvider:)` from fixed palette sets |
| Color sets are referenced through generated symbols, never strings | **Every custom color is a color set with four variants** | Judgment | Allow `Color("Name")` where the project already uses it consistently |
| Hues within about 15° count as one color | **One color, one meaning** | Source | No number |
| Ramp step sizes of `0.04`–`0.05` and `0.07`–`0.10` of OKLCH `L` | `palettes.md` | Source | Leave step sizes to the design tool |
| The HIG's 7:1 for custom pairs is a recommendation, never a finding | `contrast.md` | Judgment | Report custom pairs under 7:1 as `LOW` findings |
| An in-app light and dark setting is a `MEDIUM` finding | **Follow the system appearance** | Apple | Allow it as a user preference |
| Contrast computed from two opaque custom color sets counts as measured without Xcode | `## Reporting` | Judgment | Mark every pair `Not verified` without a render |
| The luminance ratio function matches what the thresholds are stated in | `contrast.md` | Behavior | Use only Accessibility Inspector's reading |
| A gradient that grays in the middle gets an extra stop, since SwiftUI offers only device and perceptual spaces | `palettes.md` | Apple | Accept the gray, or draw the gradient another way |

## writing

| Call | Where | Basis | Alternative |
| --- | --- | --- | --- |
| Apple's capitalization is the default only where the project has none; a project's consistent style for an element type wins, and only mixed styles are a finding | **Capitalization follows the component** | Judgment, on the HIG Writing page's one-style-per-element rule | Report every departure from Apple's component rules, such as sentence-case buttons |
| Navigation titles, tab labels and list row labels default to title style | **Capitalization follows the component** | Behavior, from the system apps; the HIG names no style | Sentence style, or no default |
| Avoid "we" everywhere and never use it in an error, overriding Jakub's allowance for an established first-person voice | **Address people as you** | Apple | Keep a brand's established "we" outside errors |
| An agent writes the source language only and leaves translations alone unless asked | **Every string goes through the catalog** | Judgment | Fill new keys with machine translations, which Xcode marks as such |
| Recovery for a common deletion is a Recently Deleted list or an undo; Jakub's undo toast is not prescribed | **Common deletions undo, rare ones confirm** | Apple, from the Alerts page | Require a visible Undo for every destructive action |
| Typing an object's name to confirm deleting an account or workspace was dropped | **Common deletions undo, rare ones confirm** | Judgment, since iOS apps rarely do it | Keep it for accounts and shared spaces |
| A purpose string that does not explain its use is `HIGH` | `## Reporting` | Apple, from App Review Guideline 5.1.1 | `MEDIUM`, as a wording finding |
| Notification copy is in scope; widgets, Live Activities and App Shortcut phrases are not yet | `writing` | Judgment | Cover every system surface now |
| Plural variants in the catalog are the recipe; automatic grammar agreement is kept only where a project already uses it | `strings.md` | Judgment | Prefer `inflect: true` where it supports the languages shipped |

## design-review

| Call | Where | Basis | Alternative |
| --- | --- | --- | --- |
| Domains run in the order `accessibility`, `navigation`, `layout`, `writing`, `typography`, `color`, `ui`, `motion` | **Domain skills are the sources of truth** | Judgment, extending Jakub's order | Put `navigation` after `layout`, or `motion` before the visual domains |
| `HIGH` includes failing an App Review guideline | **Rank by user impact** | Judgment | Leave App Review out of the shared scale and let each domain grade it |
| A trigger two skills check is reported once, under the domain whose rule the fix changes | **Rank by user impact** | Judgment | Always report it under `accessibility` |
| Sixteen triggers against a cap of 15 findings, with the excluded count reported | **One root cause, one finding** | Source | Raise the cap, or exempt triggers from it |
| A fix for a project below iOS 26 names the `if #available` branch or an older API | **Recon before judgment** | Judgment | Report the API and leave availability to the developer |
| Gesture rebuilds such as swipe to delete and pull to refresh are filed under `motion`, and permission-free pickers under `writing` | `platform.md` | Judgment | File every rebuild under `accessibility`, since the system version brings VoiceOver |
| `write-swift` is not a review domain | **Domain skills are the sources of truth** | Judgment | Add a code-quality row to the coverage table |

## write-swift

| Call | Where | Basis | Alternative |
| --- | --- | --- | --- |
| Converted with only its frontmatter, first reply and toolchain line changed; the prose pass waits | `skills/write-swift` | Process | Do the pass before any further skills |
| Swift 6.3 and 6.4 features stay in, labeled, although the toolchain is Swift 6.2 | `write-swift` | Source | Remove them until Xcode ships them, so an agent never reaches for one |
