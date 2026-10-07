# AGENTS.md

This file is the single source of guidance for coding agents working in this repository. `CLAUDE.md` imports it and adds nothing but Claude Code specifics, so put repository facts here and do not maintain a second copy.

## What this repository is

A collection of agent skills for building native iOS interfaces with SwiftUI, with UIKit as the fallback, following Apple's Human Interface Guidelines. It is distributed two ways: as the Claude Code plugin `anr` from the marketplace `uix`, both defined in this repository, and through the skills CLI for other agents. It is documentation-only. The one build step is `checks/`, a Swift package that compiles every snippet.

`.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json` define the plugin and its marketplace. Users install with `/plugin marketplace add byturna/skills` and `/plugin install anr@uix`, then invoke skills as `/anr:<skill>`. Skills are discovered from `skills/` automatically, so adding a skill needs no manifest change.

Users of Codex, OpenCode, Cursor and the other agents the skills CLI supports install with `npx skills add byturna/skills`. It copies each skill directory whole. Codex reads `agents/openai.yaml` in each skill for its display name, short description and invocation policy, and every other agent reads only `SKILL.md`. There is no `opencode.json`, because OpenCode users install through the skills CLI like everyone else.

Bump `version` in `plugin.json` in the same commit as any change under `skills/`. That number is the only signal installed users update on. `claude plugin update` compares it and nothing else, so a change shipped without a bump never reaches them. Run `claude plugin validate .` and `claude plugin validate .claude-plugin/plugin.json` after touching either manifest. The warning that a root `CLAUDE.md` is not loaded as plugin context is expected, since that file is for working on this repository.

## Where the content comes from

The skills are derived from `jakubkrehel/skills` and `emilkowalski/skills`, both MIT. `NOTICE.md` carries both licenses and the source commits, and it ships for as long as any derived file does.

Never write in either author's voice, and never attribute a rule to them inside a skill. A rule in this repository is this repository's.

The conversion is tracked in `plan/`, which holds the decisions, the order, the status of every planned skill and two audits classifying every source rule. A skill named under **Rule ownership** but absent from `skills/` is planned, not missing. Delete `plan/` when the last planned skill ships.

## Platform baseline

- iOS 26 is the minimum deployment target, and the SDK is iOS 26.2, from Xcode 26.3. Use no API introduced after iOS 26.2. Apple's documentation already lists iOS 27 APIs, so check each API's availability before naming it. When the baseline moves, this section moves with it.
- The iOS 26 SDK applies Liquid Glass to system components, so every skill writes for that design.
- SwiftUI first. A principle states the SwiftUI form. The UIKit form appears in a reference file's cheat sheet, never as a second statement of the rule.
- iPhone and iPad. Mac Catalyst, macOS and visionOS are out of scope. Where iPad behaves differently, through size classes, pointer, hardware keyboard or resizable windows, the rule says so.
- Units are points: `pt` in prose, bare numbers in code.

## The platform default wins

Before writing a rule, find what the system already does. Text styles, semantic colors, system controls and their press states, system springs, sheets, navigation transitions, safe areas and keyboard avoidance are tuned by Apple. They also adapt to Dynamic Type, Increase Contrast and Reduce Motion without help.

A rule that overrides one of them must name the case it exists for. Without that case it is wrong for this repository, however good it was on the web.

So the exact value a skill gives is often the system's own: `.body`, `.secondary`, `.padding()` with no argument, `.smooth`. Never invent a number Apple does not publish to make a rule look exact.

## Structure

Each skill lives in `skills/<skill-name>/`, with `SKILL.md` as the entry point, supporting `.md` files beside it and `agents/openai.yaml` for Codex.

Skills come in two shapes. A domain skill holds knowledge: what is true about typography, color or layout. A verb skill holds a procedure: review this change, explore these variants, preview these states. A procedure sitting inside a domain skill is a candidate for extraction, and a domain rule sitting inside a verb skill belongs to its owner instead.

The content headings belong to the skill, not to a house style. A set of files all filling one section template reads like instances of one file. What is shared is the small amount of framing that calibrates behaviour rather than organising content.

Every `SKILL.md` carries:

- **Frontmatter** with `name` (matching the directory) and `description`.
- **A plain-name H1** and a two-sentence opener saying what the skill is and what it does. Not what the domain means or why it matters: an agent does not need motivating, and a reader can tell the difference.
- **A calibration line or two**, in the opener or in its own section where it needs the room. This is where a skill says how hard to press. It says which values are exact rather than approximate, what counts as a finding versus a preference and when the right answer is to write nothing. A skill that lists rules without saying how hard to press leaves that to chance. Give the section a heading that carries its own point (`Evidence, not taste`), not a generic label.
- **Headings that carry the point**, in sentence case. `System controls first`, not `Semantics`. Number them only where the steps genuinely run in order, as in a verb skill's procedure. Numbering flat reference implies a sequence that isn't there and makes every insertion a renumber.
- **A hand-off line** naming the sibling skills that own adjacent topics.
- **A `## Before you finish` table**, two columns, where the domain has recurring mistakes. The left column is the detection pattern, which a principle statement does not give you. It is a modifier, a type or a call an agent can search Swift code for. The heading names the moment on purpose. `Common mistakes` is a label an agent reads past while orienting. `Before you finish` names the point in the work where the table is worth consulting.
- **A `## Reporting` section** in every domain skill, carrying that domain's severity ladder, its verification checks and the format for a standalone review. See below.

Supporting `.md` files carry depth beyond the principle statements: recipes, code patterns, lookup tables and the UIKit cheat sheet. Link each one from the principle that needs it, so the link sits where the agent lands. A principle states the rule and links out for the recipe. It never restates the reference file in shorter form, and the reference file never restates the principle in longer form.

Each rule lives in exactly one skill. Other skills point to it by skill name in backticks (`layout`), never by cross-skill relative link, because each skill directory ships on its own.

Point at a principle by its heading in bold (**Classify every finding**), never by its number. A numbered reference breaks silently the moment a principle is inserted above it, and nothing in the file fails when it does.

### The review format

Each skill carries the format for the review it produces. `design-review` holds the orchestrated format: scope and coverage, the findings table, verification and the verdict. A domain skill's `## Reporting` holds the smaller standalone format, grouped by the principle each finding violates and with no `Domain` column. `change-review` holds the change-scoped format, with its status column and its pre-existing section, and `design-review` points at it rather than keeping a second copy.

Those three overlap, and that overlap is the price of a skill that works when installed alone.

The same test settles any other overlap. A skill keeps a fact its own output cannot be produced without, such as a threshold it reports against or the trigger list it builds to. It names the owner beside it. A hand-off is enough when, without the sibling, the topic is simply out of scope. A recipe or a longer restatement of another skill's rule never qualifies.

Where two skills need the same text whole, they carry identical copies and change them together. Name each such pair here when it is created. The escalation triggers in `design-review`'s **Rank by user impact** and the list in `variant`'s **The floor every variant clears** are one such pair. The `DebugPicker` code in the `## The picker` sections of `variant`'s and `previews`' `picker.md` is another.

### Verification needs Xcode

Rendering a view, running a preview, taking a Simulator screenshot and running an accessibility audit all need macOS and Xcode. Every verification step in a skill therefore has two branches. With Xcode, through the MCP server Xcode 26.3 ships or the command line, run the check and report the result. Without it, as in a Linux or cloud session, mark the check `Not verified` and hand over what the user should run. Never describe a rendered result nobody rendered.

### Invocation

A user-invoked skill may invoke model-invoked skills, but it can never reach another user-invoked skill. That rule decides the setting; it is not a preference:

- `change-review`, `previews` and `variant` are the user-invoked skills. Each carries `disable-model-invocation: true` in its frontmatter and `policy.allow_implicit_invocation: false` in its `agents/openai.yaml`. Those are the Claude Code and Codex halves of one switch, so set them together. Agents that read neither may still start these skills on their own.
- `variant` is user-invoked because a design exploration is never something to start on someone's behalf. It writes throwaway code and then asks a question only a person can answer.
- `previews` is user-invoked because it writes preview files and fixtures into the project. Only the person working on the view knows when that is wanted.
- The domain skills and `design-review` are model-invoked, because something must reach them: `design-review` routes to every domain skill, and `change-review` hands its review up to `design-review`.
- `build-design` is model-invoked although nothing routes to it, because a design link with a request to build it is already a direct request. It writes production code the user asked for, not a throwaway harness.
- `write-swift` is model-invoked because writing Swift is the task itself, not an exploration. It owns no interface rules.
- `design-review` therefore cannot start `change-review`. Where it would want to, it asks the user to run it.

### Rule ownership

| Skill | Owns |
| --- | --- |
| `design-review` | Review orchestration, project convention discovery, shared severity and its escalation triggers, the shared remediation ordering including its **Use the platform** step, consolidation, coverage, the finding cap, the orchestrated output format and the verdict |
| `change-review` | Change scope resolution including the empty-scope offer, blast radius from changed files to affected screens, finding classification (`Introduced` / `Regression` / `Pre-existing`) and the change-scoped report format |
| `previews` | Making one view's states and worst-case inputs visible as `#Preview`s: finding them in the code, fixtures fed at the data boundary without editing the view, environment scenarios, the All states preview and its debug picker, rendering or handing over and the survived / broke report. Owns no domain rules and issues no verdict; each break names the domain skill that owns the fix |
| `variant` | Design exploration: the axis set variants may diverge on, how many to build, the in-app picker behind `#if DEBUG`, the tradeoff table and promotion. Owns no domain rules; every variant clears `design-review`'s escalation triggers as its floor |
| `build-design` | Building from a design: reading the Figma file or image at its source, mapping design values and instances onto existing tokens, components and system controls, the rounding rule, building only what the frames show, the side-by-side comparison and the fidelity report. Owns no domain rules; a design that breaks one is reported to its owner, never silently fixed |
| `accessibility` | VoiceOver labels, traits, grouping, actions and focus; Voice Control, Switch Control and Full Keyboard Access; the requirement that text scales and nothing clips at accessibility sizes; hit targets; input semantics; announcements; display accommodations as requirements; the contrast requirement |
| `layout` | Grouping, alignment, spacing, safe areas, size classes, adaptive structure, structure at accessibility text sizes, RTL mirroring of structure, keyboard avoidance, the expansion affordance for truncated content, widget families and margins and the Live Activity presentations |
| `navigation` | How people move through the app and where a task appears: stacks, split views, tabs and sidebars, which presentation a flow uses among push, sheet, full-screen cover, popover, alert and confirmation dialog, sheet detents, toolbar item placement, search placement and wayfinding |
| `writing` | Source wording, terminology, voice, tone, capitalization, labels, errors, empty states, permission requests and their purpose strings, notification copy, widget and Live Activity copy, App Shortcut phrases, App Intent titles and spoken dialog, the confirm-or-undo rule for destructive actions and localizable strings with their plurals and formatted values |
| `typography` | Text styles and the type scale, custom fonts and their Dynamic Type scaling, weights, numerals, wrapping and truncation mechanics, punctuation and text-level bidi behavior |
| `color` | System semantic colors, custom palettes and their construction, asset catalog structure and naming, appearance and high-contrast variants, gamut, rendered-pair contrast measurement, color remediation, color on materials and glass, widget rendering modes and Live Activity tints |
| `ui` | Surfaces: corner shape and concentricity, materials and Liquid Glass, elevation, image outlines and widget container backgrounds; SF Symbols and custom icons including directional mirroring; iPad pointer hover |
| `motion` | Whether something animates at all, system transitions first, springs and timing, interruption, gestures and their physics, symbol and content transitions, the reduced-motion implementation and haptics |
| `write-swift` | The Swift language: value types, errors, concurrency, generics, API design, performance, memory, testing and logging. Owns no interface rules |

When a concern crosses domains, keep the rule in the owner above and let other skills name only the handoff or secondary effect. In particular:

- `accessibility` decides when contrast is required and whether the pair fails; `color` owns measuring the rendered pair and changing its colors. Both carry the threshold numbers, because neither can report a failing pair without them, and they must match. Severity is `design-review`'s in an orchestrated review; each domain skill defines severity only for its own standalone output.
- `accessibility` owns the requirement that text scales through the accessibility sizes without clipping; `typography` owns text styles and custom font scaling; `layout` owns how structure changes at accessibility sizes.
- `accessibility` owns the header trait and reading order; `typography` owns how heading levels render visually.
- `layout` owns mirroring of structure; `typography` owns language metadata, punctuation and mixed-direction text; `ui` owns directional symbols.
- `typography` owns truncation mechanics; `layout` owns whether the surrounding layout has room or an expansion affordance; `writing` owns the source copy.
- `accessibility` owns whether an element has a label, which traits it carries and where an error sits; `writing` owns the words in each.
- `writing` owns formatting values through `FormatStyle`; `typography` owns how their digits render.
- `accessibility` owns Reduce Motion and Reduce Transparency as requirements; `motion` owns the reduced-motion implementation and `ui` owns surfaces under Reduce Transparency.
- `motion` owns haptics; `accessibility` owns the rule that no state rides on motion or haptics alone.
- `ui` owns where glass and materials go; `color` owns color and contrast on them.
- `navigation` owns which presentation a flow uses; `motion` owns how it animates, which is the system's unless a rule says otherwise.
- `navigation` owns where toolbar items go; `ui` owns the glass they share and how they group on it.
- `navigation` owns whether a flow is modal; `accessibility` owns how a modal contains VoiceOver.
- Widgets and Live Activities split like any screen. `layout` owns their families, margins and the four Live Activity presentations, and `typography` their text. `color` owns their rendering modes and tints, `ui` their container background and shapes and `motion` their update animations. `navigation` owns where a tap lands, and `writing` their copy.
- `change-review` owns what to review when the scope is a diff; `design-review` owns how that review is routed, ranked, consolidated and reported. The dependency runs one way: `change-review` hands its scope and statuses up, and `design-review` ranks, caps and issues the verdict. Neither file may restate the other's rules.

## Authoring conventions

- Principles are prescriptive and specific: exact modifiers, exact API names and exact values, not vague advice.
- Match the degree of prescription to the decision: requirements may be unconditional, while design heuristics name the context and escape conditions before giving exact recipe values.
- Skills instruct agents to match the target project's mix of SwiftUI and UIKit rather than impose one.
- Name an API only after confirming it in Apple's documentation, with its exact spelling. An API you cannot confirm does not go in a skill.
- Every Swift snippet compiles against the iOS 26 SDK in the Swift 6 language mode. `checks/` is a Swift package with one file per skill holding every snippet it shows, and its README gives the build command. A change to a snippet changes its file there in the same pull request. An agent that cannot compile, such as one without Xcode, lists the unchecked snippets in its pull request.
- Frontmatter `description` is how a skill gets found, and it is one or two plain sentences saying what the skill does for the user. It names the platform, as in "in SwiftUI apps", so it neither fires on web work nor gets confused with a web skill of the same name. It loads on every turn, so it earns harder pruning than the body. No trigger list: a keyword pile is a worse match signal than a clear sentence, and it goes stale the moment the skill's scope moves. The wording is the same as the skill's line in `README.md`, so changing one means changing both. The README may bold key terms and append `User-invoked.` for a user-invoked skill, and nothing else.
- A domain skill is named for its domain as a bare noun, as in `typography` or `motion`. A verb skill is named for what it does, as in `change-review`. `write-swift` holds knowledge but keeps its verb name, so the command installed users type does not change. The `anr:` namespace and the platform in each description keep them apart from other plugins' skills.
- A skill's name appears in three places: its directory, its frontmatter `name` and `display_name` in its `agents/openai.yaml`. Renaming means changing all three, then `grep`ing for the old name to confirm nothing survived.
- `short_description` in `agents/openai.yaml` is a phrase of a few words for Codex's skill list. Change it when the skill's scope moves, as you would the frontmatter `description`.
- Never open a skill with a scripted first reply or a persona. The skill's content is the instruction.
- Prefer counts and lists that cannot go stale. Say "every skill in this repository" rather than a number the next skill invalidates.
- Straight quotes, sentence-case headings. No em dashes and no parentheses or mid-sentence colons standing in for one: end the sentence or use a comma. En dashes are for numeric ranges only.
- No serial comma. Write `surfaces, icons and motion`, never `surfaces, icons, and motion`. The comma stays where `and` joins two clauses, and where dropping it would swallow an appositive or make the last two items read as one.

Four checks after an edit, since prose drifts back toward the mean:

- **No sentence over 30 words**, counting a code span as one word. A ceiling, not an average. What makes a file hard to read is the individual 40-word sentence carrying four clauses, so split those and leave the rest alone.
- **A description that matches its `README.md` line.** Two wordings of one skill is one skill described twice.
- **One statement of each rule.** Before adding a sentence, check whether the file already says it somewhere else. The reflex to restate a boundary "for clarity" produces several copies of one ownership line, and mistake tables whose every row repeats the principle above it.
- **A pruning pass, not a word ceiling.** Read each sentence and ask what it changes. A sentence that cannot be restated as an instruction, a fact or a number is cut. A sentence that could appear unchanged in another project's docs says nothing about this one. Prose about this repository's own filing decisions belongs in this file, never in a skill.
