# Conversion plan

Status, decisions and audits for converting `jakubkrehel/skills` and `emilkowalski/skills` into native iOS skills. Delete this directory when every planned skill has shipped.

## Status

One skill per pull request, in this order. Each one bumps `version` in `plugin.json` and adds its line to `README.md`.

| # | Skill | Built from | Status |
| --- | --- | --- | --- |
| 0 | `write-swift` | Emil: `write-swift`, with the scripted first reply removed and the toolchain baseline set to Swift 6.2. The prose pass against `AGENTS.md` is still to do | Added |
| 1 | `accessibility` | Jakub: `better-accessibility` and every reference file, rebuilt on the HIG Accessibility and VoiceOver pages and the App Store accessibility label criteria | Added |
| 2 | `motion` | Emil: `animate-expo` + RECIPES, `animate` + RECIPES, `apple-design` §1–11 and §13, `emil-design-eng`, `review-animations` + STANDARDS, `find-animation-opportunities`, `animation-vocabulary`. Jakub: `better-ui` `animations.md`, `enter-exit.md`, `icon-transitions.md`, `performance.md` | Planned |
| 3 | `ui` | Jakub: `better-ui`, `surfaces.md`, `icons.md`. Emil: `apple-design` §12 | Planned |
| 4 | `typography` | Jakub: `better-typography` and every reference file. Emil: `apple-design` §15 | Planned |
| 5 | `layout` | Jakub: `better-layout` and both reference files. Emil: `apple-design` §16, the navigation rows of `animate-expo` | Planned |
| 6 | `color` | Jakub: `better-colors` and every reference file | Planned |
| 7 | `writing` | Jakub: `better-writing`, `patterns.md` | Planned |
| 8 | `design-review` | Jakub: `better-interface`, `review-format.md`. The draft triggers below | Planned |
| 9 | `previews` | Jakub: `break` + `scenarios.md`, `state-machine` + `switcher.md`. Emil: `break-ui` + `CATALOG.md` | Planned |
| 10 | `build-design` | Jakub: `build-design`, `figma.md` | Planned |
| 11 | `change-review` | Jakub: `interface-review` and both reference files | Planned |
| 12 | `variant` | Jakub: `variant` + `picker.md`. Emil: `prototype` + `PICKER.md` | Planned |

Not converted: Jakub's `explain-interface`; Emil's `mobile-native`, `pick-ui-library`, `ask-sonner`, `improve-animations` and `performance-cheatsheet.md`. The reasons are in [audit.md](audit.md).

Source material lives at the commits named in `NOTICE.md`. The owner's renamed fork `byturna/jakub-skills` and the fork `byturna/Emil-skills` hold the same trees.

## Names

The audits use the source names. They map to this repository's names as follows.

| Source | Here |
| --- | --- |
| `better-accessibility` | `accessibility` |
| `better-layout` | `layout` |
| `better-typography` | `typography` |
| `better-colors` | `color` |
| `better-writing` | `writing` |
| `better-ui` | `ui` |
| new | `motion` |
| `better-interface` | `design-review` |
| `interface-review` | `change-review` |
| `break`, `state-machine`, `break-ui` | `previews` |
| `variant`, `prototype` | `variant` |
| `build-design`, `write-swift` | unchanged |

## Decisions

**Confirmed**

- An own repository at `byturna/skills`, not a fork, with fresh history.
- Plugin `anr`, marketplace `uix`.
- Bare skill names, mapped under **Names** above.
- A skeleton first, then each skill added finished. No verbatim import of either source.
- iOS 26 minimum deployment target, built with Xcode 26.3, so no API newer than iOS 26.
- SwiftUI first, with a UIKit column in each reference cheat sheet.
- iPhone and iPad. No Mac Catalyst, macOS or visionOS.
- Contrast: Apple's table, the one Accessibility Inspector checks against. Up to 17pt needs 4.5:1, 18pt and up 3:1, bold at any size 3:1 and controls 3:1.
- Tap targets: under 28×28pt is a finding; 28pt to 44pt is a recommendation.
- A toolbar Done may stay disabled while a required field is visibly empty.
- Findings cite Apple's criteria and the HIG, never WCAG criterion numbers.

**Defaults, pending the owner's confirmation**

| Question | Default in `AGENTS.md` |
| --- | --- |
| Other agents | Claude Code only: no `agents/openai.yaml`, no `opencode.json` |
| Plugins | One plugin, `write-swift` included |

**Open, decided when the affected skill is converted**

- Capitalization: adopt Apple's title style for buttons, menu items, alert titles and navigation titles.
- Navigation and presentation: inside `layout`, as `AGENTS.md` currently says, or a skill of its own.
- Preview lifetime: keep state previews committed, the Swift norm, or delete them on request.
- Surfaces in scope: widgets, Live Activities, notifications and App Intents.

## Corrections to audit.md

The second audit cites Apple's documentation for these. Confirm each against the docs when its skill is converted.

1. Hit targets have a 28×28pt minimum as well as the 44×44pt default.
2. Jakub's `12px` and `24px` control clearances match the HIG's 12pt and 24pt, so they are KEEP, not ADAPT.
3. The HIG's contrast table differs from WCAG: up to 17pt needs 4.5:1, 18pt and up needs 3:1 and bold at any size needs 3:1.
4. Gradients do have a space option, `Gradient.colorSpace(.perceptual)`. `Color.mix(with:by:in:)` replaces `color-mix()`.
5. `RoundedRectangle` already defaults to continuous corners. iOS 26 also offers `.rect(cornerRadius: .containerConcentric)` under `.containerShape`.
6. Previews can set `colorScheme`, `dynamicTypeSize`, `layoutDirection`, `locale` and `legibilityWeight`. Increase Contrast, Reduce Motion, Reduce Transparency and Differentiate Without Color are read-only, so the user toggles them.
7. `ImageRenderer` does not render UIKit-backed views such as `List` and `TextField` faithfully, so it is a weak "look once" path.
8. Swift files in one module never import each other. `change-review` finds consumers by searching symbol names, not imports.
9. `.typesettingLanguage` keeps tall scripts from clipping, `accessibilityPlayAnimatedImages` and `accessibilityDimFlashingLights` gate autoplay and `.scrollDismissesKeyboard` covers keyboard dismissal.
10. The second audit puts haptics in `ui`. This plan keeps them in `motion`, as `AGENTS.md` says.

## Draft escalation triggers

`design-review` owns these once it ships. `variant` restates them as its floor, and each domain skill's `## Reporting` names its share.

- An interactive element with no VoiceOver label, or exposed without its button, toggle or adjustable trait.
- A control reachable by touch but not by VoiceOver, Voice Control or Switch Control, such as a gesture-only action with no `.accessibilityAction`.
- A control a hardware keyboard on iPad cannot reach, or one with `.focusEffectDisabled()` and no replacement.
- Motion or autoplaying content that ignores Reduce Motion.
- Body or control text that does not scale with Dynamic Type.
- Content or a control clipped, overlapped or unreachable at the largest supported accessibility text size, at 320pt width or with the keyboard shown.
- A control outside the safe area, under the home indicator, status bar or Dynamic Island.
- A custom modal that leaves the content behind it reachable by VoiceOver.
- Body or control text whose rendered contrast pair fails its required ratio, in either appearance.
- State or meaning carried by color alone.
- A destructive action with no confirmation, undo or distinct treatment.
- Truncated content with no way to reach the full value.
- Content or a control past a scroll edge or behind a disclosure with no visible cue.
- An error that names no way to recover.
- A semantic color used against its meaning.
- A state change carried by motion or haptics alone.

## Conflicts between the sources

Resolved here so no skill has to argue them again. Details are in [audit.md](audit.md) §2.2.

| Topic | Resolution |
| --- | --- |
| Press scale, `0.96` or `0.97` | System button styles own press feedback. Only a custom `ButtonStyle` scales, with one project-wide value |
| Easing curves from either source | Springs for movement. Timing curves only for opacity and color |
| Stagger, 100ms or 30–80ms | Rare on iOS; one value where used |
| Validate on submit or inline | Inline for non-obvious rules; a disabled toolbar Done is fine when the requirement is obvious |
| Exit direction | System transitions are symmetric; asymmetric only on purpose |
| Pure black at the dark end | iOS dark base background is pure black; follow the system |
| Text selectable by default | Not on iOS; opt content in |
| Placeholder never a label | The `Form` title doubles as label and placeholder natively |
| Review output formats | Jakub's |

## Files

- [audit.md](audit.md): the rule-by-rule audit of both repositories. It was written before the repository decisions above, so its advice on forks and on importing first is superseded.
- [audit-second-opinion.md](audit-second-opinion.md): an independent audit of Jakub's repository only, from another session. It is the source of the corrections above.
