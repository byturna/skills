---
name: design-review
description: Reviews a SwiftUI or UIKit screen, flow or app across accessibility, navigation, layout, writing, typography, color, surfaces and motion, and returns one ranked verdict.
---

# Design review

This skill runs one review of an iOS interface across every design domain. It routes the interface to each domain skill, collects their evidence and consolidates one ranked verdict.

Orchestration is all it owns. The rules belong to `accessibility`, `navigation`, `layout`, `writing`, `typography`, `color`, `ui` and `motion`, and this skill never duplicates or overrides them. Review of a change, such as a branch, a pull request or uncommitted work, belongs to `change-review`. Rendering one view's states belongs to `previews`. Swift code quality belongs to `write-swift`.

## Evidence, not taste

Press hard on the escalation triggers and leave deliberate project choices alone. A trigger is a failure whatever the style guide says. A spacing, a radius or a voice you merely disagree with is not a finding.

The bar for reporting is evidence. The bar for `Approve` is that you inspected what you claim to have inspected.

## Resolve the scope first

Infer the screen, flow, feature or app from the request and the workspace, and state the resolved scope in the output. Cover all of it in every domain. That includes the empty, loading and error states, the dark appearance and the largest accessibility text size. It also includes the narrowest supported width, iPad where the app supports it and the keyboard shown where there is text entry.

When the scope is too large to inspect credibly, narrow it to one complete flow. Take the one the request centers on, or failing that the path every person passes through, such as onboarding or the first tab. State the boundary and what it excluded. Never imply that uninspected screens were reviewed.

## Send a change to `change-review`

A request naming a branch, a pull request, a commit range or uncommitted changes is a change review. Say so and ask the user to run `/anr:change-review`, which this skill cannot start. Never resolve a change scope yourself, because a guessed diff gives the report a scope nobody can check.

When `change-review` hands a review up, apply everything below to it. The cap and the verdict cover `Introduced` and `Regression` findings only, so a change whose only findings are `Pre-existing` is an `Approve`.

## Recon before judgment

Read the project before judging it:

- The deployment target, from `IPHONEOS_DEPLOYMENT_TARGET` or a package's `platforms`, since it decides which fix exists.
- The SwiftUI and UIKit mix, and any design-system package or shared components.
- Asset catalogs and String Catalogs, with the localizations they carry.
- The device families and orientations, from `TARGETED_DEVICE_FAMILY` and `UISupportedInterfaceOrientations`.
- `UIDesignRequiresCompatibility`, which opts the app out of Liquid Glass.
- The previews, snapshot tests and UI tests that can render or check a screen.

Then read what the project has written about its interface: `CONTRIBUTING.md`, `AGENTS.md`, `CLAUDE.md`, a design-system document or interface decision records. Name what you found, or that there is none.

A documented convention settles matters of taste but never excuses a trigger or a domain rule. What it changes is where you report. When a convention or a shared component is the cause, report it once against that source, with each view as a location.

These skills write for iOS 26. Where the project targets an earlier release, a fix that needs a newer API names the `if #available` branch or an alternative the target has.

## Domain skills are the sources of truth

Load every domain skill and complete each domain's review before consolidating. Review in this order, so a foundational failure is never hidden by polish:

1. `accessibility`
2. `navigation`
3. `layout`
4. `writing`
5. `typography`
6. `color`
7. `ui`
8. `motion`

From each, take its principles, its references and its verification checks. Its severity ladder and its format are for standalone use, and the ones here replace them.

If a domain skill is unavailable, mark that domain `Not reviewed`, name the skill and continue with the rest. Never recreate its rules from memory, substitute a neighbor or claim full coverage. When two skills seem to cover one issue, give it to the skill whose hand-off line claims the rule, and note secondary effects in the `Why` cell.

## Every finding cites its evidence

Every finding cites `path/to/file.swift:line` and shows the current code. Where the result depends on how it renders, source alone cannot support a visual finding, and a screenshot alone cannot support a code finding.

## Rank by user impact

One severity scale covers every domain:

- `HIGH` blocks a task, misleads, hides content or a control, risks data loss, fails an App Review guideline or repeats a failure across the app.
- `MEDIUM` meaningfully harms comprehension, efficiency, adaptability or consistency.
- `LOW` is isolated polish with little effect on the task.

Within a severity, rank by how many places a finding reaches and how much one fix buys. A fix in a shared component or color set outranks the same symptom in one view.

Once a domain skill confirms one of these escalation triggers, it is `HIGH` on sight, never averaged down because the screen is minor:

| Trigger | Checked in |
| --- | --- |
| An interactive element with no VoiceOver label, or exposed without its button, toggle or adjustable trait | `accessibility` |
| A control reachable by touch but not by VoiceOver, Voice Control or Switch Control | `accessibility` |
| A control a hardware keyboard on iPad cannot reach, or one with `.focusEffectDisabled()` and no replacement | `accessibility` |
| A custom modal that leaves the content behind it reachable by VoiceOver | `accessibility` |
| Motion or autoplaying content that ignores Reduce Motion | `accessibility`, `motion` |
| A state change carried by motion or haptics alone | `accessibility`, `motion` |
| Body or control text that does not scale with Dynamic Type | `accessibility`, `typography` |
| Content or a control clipped, overlapped or unreachable at the largest supported accessibility text size, at the narrowest width or with the keyboard shown | `accessibility`, `layout` |
| A control outside the safe area, under the status bar, the Dynamic Island or the home indicator | `layout` |
| Truncated content with no way to reach the full value | `layout` |
| Content or a control past a scroll edge or behind a disclosure with no visible cue | `layout` |
| Body or control text whose rendered contrast pair fails its required ratio, in either appearance | `accessibility`, `color` |
| State or meaning carried by color alone | `accessibility`, `color` |
| A semantic color used against its meaning | `color` |
| A destructive action with no confirmation, undo or distinct treatment | `writing` |
| An error that names no way to recover | `writing` |

These set severity, not rules. The skills that check a trigger decide whether the symptom is present, and this table decides what it costs. Where two skills check one trigger, report it once, under the domain whose rule the fix changes. Triggers rank above every other finding. When more fire than the cap allows, list them first and say how many the cap excluded. A cap may shorten a report, but it is never why a blocker went unreported.

## Prefer the cheaper fix

Severity says how bad a finding is, and this says which fix to propose. When more than one would work, take the earliest that does:

1. **Delete.** A divider that spacing would carry, an animation on a frequent interaction, an accessibility modifier a system control makes redundant or a color set nothing references.
2. **Use the platform.** A system control, presentation, text style, semantic color, spring or SF Symbol in place of a custom rebuild. The common rebuilds and what replaces them are in [platform.md](platform.md).
3. **Reuse what the project has.** An existing component, color set, spacing constant or text style before any new value.
4. **Correct the value.** The wrong spring, radius, spacing or contrast pair, using the exact value the owning skill gives.
5. **Add.** A new component or color set, `@ScaledMetric`, a custom `Layout` or an accessibility modifier the system cannot infer.

When the code under review adds what **Delete** would remove, that is a finding, and its `After` is the deletion. Write every fix in the framework the view already uses, never as a request to adopt the other.

## One root cause, one finding

One root cause is one finding, with every confirmed location in the same row. Report at most 15 findings. Never pad toward the cap, since a short review or no findings is a valid result.

## Verify what can be verified

Run each domain's verification checks, through Xcode's MCP server, `xcrun mcpbridge`, or the command line. The checks that span domains are these:

- Build with `xcodebuild build` and run the project's tests with `xcodebuild test`.
- Run `performAccessibilityAudit(for:_:)` in a UI test, or the audit in Accessibility Inspector.
- Render previews, or capture the Simulator with `xcrun simctl io booted screenshot`, in each state the scope names.

Report the exact command or interaction and its result. Without Xcode, as in a Linux or cloud session, every rendered check is `Not verified`, and the report hands over what the user should run. A check you could not run is never a finding.

## Review without changing code

Treat a review request as read-only. Never edit source unless the user also asks you to implement the findings. When they do, keep the consolidated report as the scope of the change and re-run the relevant checks afterward.

## Before you finish

| Pattern | Fix |
| --- | --- |
| A separate findings section per domain | One table, ranked by severity and then by reach |
| A rendering claim whose only evidence is source | Render it, or mark it `Not verified` |
| A missing VoiceOver label rated `MEDIUM` because the screen is minor | Triggers are `HIGH` on sight |
| A coverage row whose evidence names no file, view or check | Inspect that domain, or mark it `Not reviewed` with the reason |
| A domain marked `Clear` although its skill never loaded | `Not reviewed`, naming the skill |
| One symptom in several rows, one per view | One row against the shared component or color set, listing every location |
| An `After` that adds a wrapper, a modifier or a color set | Check whether a deletion or a system control fixes it first |
| A UIKit fix for a SwiftUI view, or the reverse | The view's own framework |
| An `After` using an API above the deployment target | An `if #available` branch, or an API the target has |
| A branch, pull request or diff reviewed here | Ask the user to run `/anr:change-review` |

## Review output format

The format is in [review-format.md](review-format.md): scope and coverage, the findings table, verification and the verdict. A review is not finished until its findings are reported there.
