---
name: previews
description: Writes previews that show one SwiftUI or UIKit view in every state and worst case it can reach, then reports what visibly broke and which skill owns the fix.
disable-model-invocation: true
---

# Previews

This skill takes one view and writes a `#Preview` for each state the code can reach and each worst case its inputs allow. It renders them once, reports what visibly broke and names the skill that owns each fix.

It observes rather than judges. Reviewing code against the rules is `design-review`, and a change under review is `change-review`. Exploring alternative designs is `variant`. Every fix follows the rules of the domain skill the report names. The UIKit form of every API here is in [cheat-sheet.md](cheat-sheet.md).

## Observed, not predicted

A break is something visibly wrong in a rendered preview: "The email runs under the trailing button", never "the spacing feels tight". A break you expect but did not render is not a finding. Without a render there are no findings, only the previews and their list.

"Everything survived" is a complete report. This skill issues no verdict and fixes nothing unasked.

## 1. Scope one view

One view per run. "The settings screen" spans several views, so list the candidates and ask which one. Restate the view in one sentence: what it takes, what it renders, where it appears and where its data comes from.

## 2. List the states and the worst cases

The states are the branches the view already has. Read the view, its model and its data source for each one:

| Kind | States |
| --- | --- |
| Data | Loading, empty, error, one item, a typical set, a set long enough to scroll, partly loaded, refreshing over stale data |
| Account | Plan tier, role, permission, the owner against a member |
| Feature | Flags, trials, a limit reached, a locked or disabled feature |

A state the code cannot reach is not a state, so never add a branch to show one. Where a design shows a state the code lacks, list it as missing. Combine kinds only where the code branches on the combination.

The worst cases come from the axes in [scenarios.md](scenarios.md). Keep an axis only where its cue matches the view. A view that shows a fixed label gets no content-length scenarios, and a single item gets no quantity scenarios.

Write the list down before writing code, one line per preview, named the way the product talks. Then say in one line which axes you dropped and why, so a wrong inference is cheap to catch.

## 3. Feed data at the boundary

Supply each state's data where the view receives it, without editing the view. In order of preference, use its initializer, the `@Observable` model it reads from the environment or the project's own mock or dependency container. A SwiftData view takes an in-memory container. Where the view builds its own model with no way in, say so and ask before adding one.

Make the data look like the product, with real-shaped names, amounts and dates in the counts people actually have. Worst-case values are ones a real person could produce, or the limit the model or the server enforces. A loading state holds still, injected directly, never resolved after a delay. The recipes and the catalog of values are in [fixtures.md](fixtures.md).

## 4. Write the previews

Put the previews where the project keeps them. With no convention, they go in one file beside the view, named for it, such as `MemberListPreviews.swift`. Wrap the file and every fixture in `#if DEBUG`, so nothing reaches a release build.

Write one named `#Preview` per line of the list. The canvas lists them by name, so no picker is needed. Each one renders the real view inside the container it gets in production, such as a `List` row, a `NavigationStack` or a sheet, and adds nothing else. The previews set no fonts, colors, tints or backgrounds of their own.

Environment scenarios go through the environment, which is how the system applies them, so the view renders as it would on a device. Settings the environment cannot set, such as Increase Contrast and Reduce Motion, are named for the user to toggle. Both lists are in [scenarios.md](scenarios.md#environment).

## 5. Render once, or hand over

With Xcode, render each preview once, through Xcode's MCP server or the canvas, and note what visibly broke. A preview that crashes or renders blank is broken plumbing, usually a missing environment value or model, so fix it before reporting. A preview showing real data instead of the fixture is broken the same way.

Without Xcode, as in a Linux or cloud session, say so. Hand over the file and the list, with no findings, so the user can render them.

## 6. Report what broke and stop

Report the breaks first, then what survived:

| Preview | Observed | Owner |
| --- | --- | --- |
| Worst case | The long email pushes the More button off the row | `layout` |
| AX5 | The plan name truncates with no way to read it | `typography` |
| Empty | A blank region with no message | `writing` |

Each break names the domain skill whose rules diagnose it. List the previews that survived, and name the settings the user should still toggle. End there, without suggestions.

On a request to fix, follow the owner skill's rules. Then render every preview again, since a fix for one state often breaks another.

## The previews stay

The previews are the report's evidence and the view's regression check, so they stay in the project. Delete them only when the user asks. Then remove the file and its fixtures and search for their names. Check that the diff leaves nothing behind.

## Before you finish

| Pattern | Fix |
| --- | --- |
| The view edited to accept a fixture, or a branch added to reach a state | Feed data at the boundary, and list missing states |
| A lookalike view rebuilt in the preview | The real view |
| `.font`, `.tint`, `.background` or `.foregroundStyle` wrapped around the view | Only the container production gives it |
| "Item 1", "Test User" or three identical rows | Product-shaped data in real counts |
| `Task.sleep` or `asyncAfter` in a fixture | Inject the loading state directly |
| `#Preview` with no name | A name from the list, such as `#Preview("Empty")` |
| A fixture or preview outside `#if DEBUG` | Wrap it |
| `.environment(\.accessibilityReduceMotion, …)` or another read-only setting | Name it for the user to toggle |
| `#Preview(_:traits:arguments:body:)` | One named preview per scenario, since that macro needs a later SDK |
| Every axis run against every view | Keep the axes whose cue matches, and name the drops |
| A predicted break reported as observed | Render it, or leave it out |
| A break with no owner | Name the domain skill that diagnoses it |
| A clean run padded with suggestions | "Everything survived" and the list |
| The previews deleted in the same turn | Keep them until the user says otherwise |
