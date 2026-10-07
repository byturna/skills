# Review output format

The format for a review `design-review` runs across every domain.

## Scope and coverage

State the exact scope, the deployment target, the SwiftUI and UIKit mix, the project documents found in recon and any review boundary. Then show coverage:

| Domain | Evidence inspected | Result |
| --- | --- | --- |
| Accessibility | Files, views, states or checks | A findings count, `Clear` or `Not reviewed` |

List every domain under **Domain skills are the sources of truth**. `Clear` means inspected with no actionable finding, and `Not reviewed` says why.

## Findings

One table, ordered by severity and then by reach:

| Severity | Domain | Location | Before | After | Why |
| --- | --- | --- | --- | --- | --- |
| HIGH | Accessibility | `Sources/Player/PlayerControls.swift:42` | `Button(action: close) { Image(systemName: "xmark") }` | `Button("Close", systemImage: "xmark", action: close).labelStyle(.iconOnly)` | The icon-only button has no VoiceOver label |

- `Severity` comes from **Rank by user impact**.
- `Domain` is the skill whose rule the finding cites.
- `Location` is `path/to/file.swift:line`, or the screen and view where there is no source, such as a screenshot or a design.
- `Before` and `After` show the current code and a replacement that works, each in its own cell.
- `Why` names the violated principle and its effect on people.

With no findings, leave out the table and state "No actionable interface findings."

## Verification

List each check, its exact command or steps and the observed result. Separate the checks that passed from those marked `Not verified`. Without Xcode, list what the user should run to close each `Not verified` check.

## Verdict

End with one of two:

- `Block`: one or more `HIGH` findings remain. Do not ship until they are fixed.
- `Approve`: no `HIGH` findings remain. Any `MEDIUM` and `LOW` findings stay in the table as work to do.

`Approve` covers only the domains the coverage table shows as inspected. Name every `Not reviewed` domain in the verdict line.

## Change-scoped reviews

When `change-review` hands a review up, use its format. It adds its scope block, a `Status` column and its section for pre-existing findings to the sections above.
