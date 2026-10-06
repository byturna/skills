> Written on 2026-10-06 before the repository decisions in [README.md](README.md). Where the two disagree, README.md wins.

# iOS conversion audit: jakubkrehel/skills + emilkowalski/skills

**Scope read:** every `SKILL.md` and every reference file it links in both repos (27 skills, 45 reference files). Also `.claude-plugin/*`, `AGENTS.md`, `CLAUDE.md`, both READMEs, `opencode.json`, every `agents/openai.yaml`, both LICENSEs, Emil's root `performance-cheatsheet.md` and the empty `.pl` file.

**Nothing in either repo was changed.**

**Legend:** **KEEP** works as-is · **ADAPT** principle holds, implementation changes · **DROP** web-only · **CONFLICT** following it makes the app less native or contradicts HIG.
`(17)` means iOS 17+. With an iOS 26 floor everything listed is available. Versions are shown in case you lower the floor.

---

## 0. Thoughts on the approach (read this first)

**1. The "merge" is a design merge, not a git merge. Don't do it first.**
If you copy Emil's tree into `byturna/skills` now, you get a repo with 27 skills, two pairs of duplicates (`break`/`break-ui`, `variant`/`prototype`) and at least 12 rules that contradict each other (see §2). You would then edit web content you're about to delete. Decide the target skill list first. Then build each target skill by pulling material from both sources. Use the two repos as source material.

**2. Use Jakub's repo as the base and his `AGENTS.md` as the house style.**
His architecture is the better one: one owner per rule, domain skills vs verb skills, a calibration section and a `## Reporting` section per domain. Emil's repo has the frequency table and easing tables copied into five skills, plus an "Initial Response" gate on every skill. It also uses keyword-list descriptions and a first-person "my knowledge comes from Emil Kowalski" voice. The merge means **absorbing Emil's knowledge into Jakub's architecture**.

**3. Expect the skills to get shorter, not just translated.**
Many web polish rules exist because browsers ship weak defaults: tap highlights, `100vh`, unitless line-height, focus rings, font smoothing, `transition: all`. iOS ships tuned defaults: text styles with tracking tables, semantic colors, system springs, button press states, sheets, safe areas and keyboard avoidance. So a large share of the rules become **CONFLICT: stop overriding the system**. Roughly a third of all rules are DROP and another fifth are CONFLICT. That is HIG flavour in practice: "use the platform" becomes the top rule.

**4. The biggest native-feel gaps aren't in either repo.**
Neither source covers these as first-class topics: navigation and presentation (push vs sheet vs full-screen cover, tab bars, toolbars, menus, swipe actions), Liquid Glass layering, SF Symbols, Dynamic Type, VoiceOver traits and haptics. Plan for new content, not only conversion. See §4.

**5. Every verification and verb workflow needs macOS + Xcode.**
`break`, `state-machine`, `variant`, `build-design` and the domain verification steps all say "load the page in a browser". The SwiftUI equivalent is Xcode Previews or the Simulator. Xcode 26.3 ships an MCP server (`mcpbridge`) that lets agents build and render previews, and XcodeBuildMCP works with Claude Code ([MartianCraft](https://martiancraft.com/blog/2026/03/xcode26-3-what-is-mcp-and-agentic-development/)). A cloud Linux session like this one can't render anything. So every verb skill needs an honest "no Xcode available" branch. Decide your toolchain before rewriting the verbs.

**6. "iOS 26" needs pinning down.**
iOS 27 / Xcode 27 is out or imminent. Apps built with the Xcode 27 SDK ignore `UIDesignRequiresCompatibility`, so you can no longer opt out of Liquid Glass ([Apple forums](https://developer.apple.com/forums/thread/832543)). Do you mean iOS 26 as the minimum deployment target (fine) or the design spec? I haven't verified iOS 27's other changes. Don't trust blog claims about them.

**7. "A flavour of HIG" should show up as rules, not essays.**
Jakub's convention is exact values. Apple rarely publishes exact polish values. Its "exact value" is usually "the system's": `.body`, `.secondary`, `.padding()`, `.smooth`. Resist inventing numbers Apple doesn't specify. Also resist pasting Emil's WWDC quotes and principle essays; Jakub's pruning rule would cut them, correctly.

**8. Licensing and credit.**
Both repos are MIT. Forking, modifying and publishing are fine. You must keep **both** copyright notices: your LICENSE plus a NOTICE or credits file with Jakub's and Emil's MIT text.

Remove every "my knowledge comes from Emil Kowalski" line and the first-person persona. Once you rewrite the content, those lines attribute your rules to him.

Also remove Jakub's interfaces.dev image, skills.sh badges and personal-site links from the README. Credit them in a section instead.

**9. Installing Emil's repo as-is into a Swift project would actively hurt.**
`apple-design`, `animate`, `mobile-native`, `emil-design-eng`, `find-animation-opportunities`, `improve-animations` and `break-ui` are model-invoked. Their descriptions match iOS requests like "make it feel native", "add a spring", "materials" or "stress-test this". They would load CSS answers into a Swift session. See §6.

---

## 1. Summary table

| # | Source | Skill | Verdict | Effort | One-line reason |
| --- | --- | --- | --- | --- | --- |
| 1 | Jakub | `better-interface` | adapt | M | Orchestration is platform-agnostic; recon, escalation triggers and verification are web |
| 2 | Jakub | `interface-review` | adapt | M | Git scope logic transfers whole; removed-signal regexes, exclusions and consumer expansion are web |
| 3 | Jakub | `better-accessibility` | rewrite | L | Principles hold, but ~80% of mechanics are ARIA, DOM and WCAG-for-web; VoiceOver traits, Dynamic Type and Voice Control are missing |
| 4 | Jakub | `better-layout` | rewrite | L | Grouping, order and growth principles hold; every recipe is CSS; size classes, Dynamic Type layout and navigation are missing |
| 5 | Jakub | `better-typography` | rewrite | M | About half the rules are things SF Pro and text styles do automatically, so applying them by hand conflicts |
| 6 | Jakub | `better-colors` | adapt | M | Token, role and contrast thinking is excellent; ramp generation is mostly replaced by system semantic colors and asset catalogs |
| 7 | Jakub | `better-writing` | adapt | S | The most portable skill; swap i18n plumbing for String Catalogs and FormatStyle; align capitalization with Apple |
| 8 | Jakub | `better-ui` | rewrite + split | L | Surfaces and icons survive as concepts; motion moves to a new skill; press-scale and shadow rules conflict with HIG; Liquid Glass and SF Symbols are missing |
| 9 | Jakub | `break` | merge → `previews` | M | Process is good; the temporary page becomes a `#Preview` set |
| 10 | Jakub | `state-machine` | merge → `previews` | M | Xcode Previews already are a per-state workbench; the skill shrinks to fixtures plus preview conventions |
| 11 | Jakub | `variant` | adapt (+ prototype) | M | Workflow transfers; the URL-param picker becomes a debug overlay |
| 12 | Jakub | `build-design` | adapt | M | Figma workflow transfers; mapping to Apple's UI Kit, text styles and pt is new |
| 13 | Jakub | `explain-interface` | drop (for now) | — | ~85% is DOM and URL inspection; you can't inspect other people's iOS apps |
| 14 | Emil | `emil-design-eng` | drop (mine ideas) | S | A web animation umbrella; its durable ideas are duplicated in `animate`; the rest is CSS, Framer and Sonner |
| 15 | Emil | `animate` + RECIPES | merge → `better-motion` | M | The decision sequence is the right spine; the tools and values are CSS |
| 16 | Emil | `animate-expo` + RECIPES | merge → `better-motion` (main seed) | M | Closest to native: its "use the native stack, sheet, tabs, menu" table maps 1:1 to SwiftUI; the haptics table ports directly |
| 17 | Emil | `apple-design` | rewrite → split | M | It translates Apple to the web; reversed, most of it becomes "the system already does this" |
| 18 | Emil | `review-animations` + STANDARDS | merge → `better-motion` Reporting | S | Standards duplicate `animate`; its output format conflicts with Jakub's |
| 19 | Emil | `improve-animations` + AUDIT + PLAN-TEMPLATE | drop / defer | — | Audit-to-plans workflow is sound but heavy for a personal project; rules are duplicated |
| 20 | Emil | `find-animation-opportunities` | merge → `better-motion` section | S | The restraint gate already exists in `animate`; keep its hunt list |
| 21 | Emil | `animation-vocabulary` | merge → `better-motion/vocabulary.md` | S | Glossary is mostly portable; swap web terms for SwiftUI names |
| 22 | Emil | `write-swift` | convert as-is | S | Already Swift; strip the Initial Response block and trim the description |
| 23 | Emil | `mobile-native` | drop | — | Mobile Safari and PWA fixes; no native meaning; high misfire risk |
| 24 | Emil | `break-ui` + CATALOG | merge → `previews` | S | Its worst-case data catalog is the best part of either break skill |
| 25 | Emil | `prototype` + PICKER | merge → `variant` | S | Near-duplicate of `variant` |
| 26 | Emil | `pick-ui-library` | drop | — | npm and React picks; replace with a "first-party first" table in `better-interface` |
| 27 | Emil | `ask-sonner` + API | drop | — | Docs for a React toast library |
| — | Emil | `performance-cheatsheet.md` | drop | — | CSS and Framer performance |
| — | Emil | `.pl` (empty file) | delete | — | Junk |
| — | Jakub | `.claude-plugin/plugin.json` | adapt | S | Name, author, homepage, repository and version are Jakub's |
| — | Jakub | `.claude-plugin/marketplace.json` | adapt | S | Owner is Jakub; decide one or several plugins |
| — | Jakub | `AGENTS.md` | adapt | M | Architecture is excellent; the ownership table, invocation list, install line and "Tailwind vs CSS-in-JS" convention need replacing |
| — | Jakub | `CLAUDE.md` | keep | — | Just imports AGENTS.md |
| — | Both | `README.md` | rewrite | S | Install lines, OG images, badges and links all point at the originals |
| — | Jakub | `opencode.json`, `agents/openai.yaml` | keep or drop | S | Only if you use opencode or Codex (Q6) |
| — | Both | `LICENSE` | adapt | S | Keep both MIT notices |

**Net result: 27 skills → about 12.**

| Kind | Skills |
| --- | --- |
| Domain (model-invoked) | `better-accessibility`, `better-layout`, `better-typography`, `better-colors`, `better-writing`, `better-ui` (surfaces, Liquid Glass, SF Symbols), **`better-motion` (new: animation, gestures, haptics)**, possibly **`better-navigation` (new, Q9)** |
| Orchestration and building (model-invoked) | `better-interface`, `build-design` |
| Language (model-invoked) | `write-swift` |
| Verbs (user-invoked) | `interface-review`, **`previews`** (break + state-machine + break-ui), `variant` (+ prototype) |

---

## 2. Overlaps, conflicts and deletions

### 2.1 What overlaps and where it should land

| Topic | Copies today | Merge into |
| --- | --- | --- |
| Frequency gate ("should this animate at all") and purpose list | `emil-design-eng`, `animate`, `animate-expo`, `review-animations/STANDARDS.md`, `improve-animations/AUDIT.md`, `find-animation-opportunities`, `better-ui` (high-frequency rule) | `better-motion`, stated once |
| Easing and duration tables | Same six Emil files + `better-ui` | `better-motion` (replaced by springs, see conflicts) |
| Springs, interruptibility, velocity hand-off, projection, rubber-banding | `apple-design` §3–9, `emil-design-eng`, `animate`, `animate-expo` + RECIPES, `better-ui` | `better-motion` |
| Press feedback | `better-ui` (0.96); `emil-design-eng`, `animate`, STANDARDS, AUDIT, `apple-design`, `mobile-native`, `animate-expo` (0.97) | `better-motion` (resolved: system first) |
| Reduced motion | `better-accessibility` (requirement), `better-ui`, every Emil motion skill, `apple-design` §14 | Requirement in `better-accessibility`; recipe in `better-motion` |
| Hover gating and tap highlight | `better-ui`, `emil-design-eng`, `animate`, `mobile-native`, STANDARDS | Drop; iPad pointer hover becomes a small note in `better-ui` |
| Materials and translucency | `apple-design` §12, `better-colors/contrast.md` | `better-ui` (glass); text contrast over glass in `better-colors` |
| Tracking and leading by size | `better-typography`, `apple-design` §15 | `better-typography` |
| Design principles, feedback kinds, wayfinding | `apple-design` §16, `better-layout`, `better-writing` | `better-layout` / `better-navigation` and `better-writing` |
| Worst-case data testing | `break` + `scenarios.md`, `break-ui` + `CATALOG.md` | `previews`: Jakub's cue-based process, Emil's data catalog |
| Variants behind a picker | `variant` + `picker.md`, `prototype` + `PICKER.md` | `variant` |
| State harness and switcher | `state-machine` + `switcher.md` (and its twin `picker.md`) | `previews` |
| Review output formats | `better-interface`, `interface-review`, `emil-design-eng`, `review-animations`, `improve-animations` | Jakub's formats only |
| Safe areas | `better-layout`, `mobile-native`, `animate-expo` (toast) | `better-layout` |
| iOS Safari input zoom (16px) | `better-typography`, `better-accessibility`, `mobile-native` | Drop |
| Hit targets 44pt | `better-accessibility`, `animate-expo`, `apple-design` | `better-accessibility` |
| Haptics | `animate-expo` §8, `apple-design` §13 | `better-motion` |

### 2.2 Direct conflicts between the sources: pick one

| # | Jakub says | Emil says | iOS reality / recommendation |
| --- | --- | --- | --- |
| 1 | Press scales to `0.96`, `150ms`, `ease-out` | `scale(0.97)`, 100–160ms, custom curve | System `Button` styles and iOS 26 `.glass` already give press feedback. Only a custom `ButtonStyle` should scale, via `configuration.isPressed` with a spring. Pick one value for the project. |
| 2 | `cubic-bezier(0.2, 0, 0, 1)` | `cubic-bezier(0.23, 1, 0.32, 1)`, `(0.77, 0, 0.175, 1)`, `(0.32, 0.72, 0, 1)` | Native motion is springs: `.smooth`, `.snappy`, `.spring(duration:bounce:)` (17). Keep bezier only for opacity and color fades. No bezier tokens. |
| 3 | Stagger 100ms | Stagger 30–80ms (50ms in recipes) | Rare on iOS outside onboarding. If used, one value. |
| 4 | Validate on submit; never disable submit until valid | `apple-design`: validate inline, not on submit | iOS convention: nav-bar Done/Add stays disabled until required fields are filled (Contacts, Calendar). Rule: disabling is fine when the requirement is obvious; inline errors for non-obvious validation. |
| 5 | Exits use a fixed `-12px` and keep moving up | "Exit the way it entered" (symmetric path) | System transitions are symmetric. Use `.asymmetric(insertion:removal:)` only deliberately. |
| 6 | Icon swap spring `bounce: 0` always | Bounce 0.1–0.3 for some interactions | SF Symbols: use system symbol effects instead of hand-tuned values. |
| 7 | Severity, Location, Before, After, Why + Block/Approve | Before, After, Why + tiered verdict | Jakub's format |
| 8 | AGENTS.md conventions: lean descriptions, no em dashes, no persona | "Initial Response" gate, trigger-list descriptions, em dashes, persona | Jakub's |
| 9 | `better-colors`: ramp ends stop short of pure black | — | iOS dark `systemBackground` (base level) **is** pure black; elevated is `#1C1C1E`. Follow iOS. |
| 10 | `better-typography`: keep text selectable by default | — | iOS UI text is non-selectable by default. Use `.textSelection(.enabled)` (15) on content users copy. |
| 11 | `better-writing`: sentence case is the default | — | Apple uses title-style capitalization for buttons, menu items, nav titles and tab names ("Delete Photo", "Copy Link"). Sentence style for footers and messages. (Q8) |
| 12 | `better-accessibility`/`better-writing`: a placeholder is never a label | — | iOS `Form` routinely shows the title as the placeholder (Settings, Contacts). The title is still the accessible name. Visual concern only. |

### 2.3 Delete outright

- **Skills:** `mobile-native`, `pick-ui-library`, `ask-sonner`, `explain-interface` (defer), `improve-animations` (defer).
- **Reference files:** `css-cheat-sheet.md`, `no-browser.md`, `read-the-system.md`, `find-the-effect.md`, `STANDARDS.md` and `AUDIT.md` (duplicates), `focus-and-keyboard.md` and `semantics-and-aria.md` (rewrite from scratch).
- **Other:** every Tailwind section, `performance-cheatsheet.md`, `.pl`, and `opencode.json` if you don't use opencode.

### 2.4 How to do the merge mechanically

1. In `byturna/skills`, on a branch, keep Jakub's git history. It's the architecture you're keeping.
2. Don't import Emil's tree. Treat `byturna/Emil-skills` as read-only source material and credit it in `NOTICE`. A `git subtree add` for provenance is possible but pointless when about 85% gets dropped or rewritten.
3. **Rewrite `AGENTS.md` first.** It's what every agent reads while converting. It needs:
   - the target skill list and the new ownership table;
   - iOS authoring conventions: "SwiftUI first, UIKit column in reference cheat sheets", "a platform default beats any value here", pt units and min-iOS annotations;
   - the draft escalation-trigger list.
4. Delete the dropped skills in one commit. Convert **one skill per PR**, bumping `plugin.json` `version` each time (Jakub's rule).
5. When done, archive the `Emil-skills` fork.

---

## 3. Per-skill rule tables

### 3.1 `better-accessibility` → rewrite (L)

| Rule | Class | SwiftUI / UIKit equivalent | Note |
| --- | --- | --- | --- |
| Criteria, not conventions: cite WCAG A/AA | ADAPT | Cite HIG plus the App Store **Accessibility Nutrition Label** categories: VoiceOver, Voice Control, Larger Text, Dark Interface, Differentiate Without Color Alone, Sufficient Contrast, Reduced Motion, Captions, Audio Descriptions. Or name a concrete task a VoiceOver user can't complete. | Keep WCAG numbers only if you ship in the EU (Q7) |
| Two walks: keyboard, then screen reader | ADAPT | VoiceOver walk (order, name, trait, value), Dynamic Type walk at AX5, Voice Control "Show names". Full Keyboard Access only if you claim iPad keyboard support. | |
| Native elements first | KEEP | `Button`, `Toggle`, `Picker`, `Link`, `NavigationLink`, `Menu` instead of `.onTapGesture` | `.onTapGesture` is iOS's `<div onClick>` |
| Real links support Cmd/middle-click | DROP | — | |
| Disabled means unavailable (`disabled` vs `aria-disabled`) | ADAPT | `.disabled(_:)`; VoiceOver says "dimmed"; put the reason in visible footer text | |
| Visible focus rings | ADAPT | System draws Full Keyboard Access focus. Flag `.focusEffectDisabled()` (17) and custom tappables that aren't focusable. `@FocusState` (15) for fields. | Not an escalation trigger unless keyboard support is claimed |
| Focus not obscured by sticky chrome | DROP | Keyboard avoidance and VoiceOver auto-scroll are automatic. Use `.safeAreaInset(edge:)` (15), not `.overlay`, for floating bars. | |
| Full keyboard support, APG key maps | ADAPT | `.keyboardShortcut` (14) for primary actions on iPad; `.onKeyPress` (17) for custom controls | APG tables DROP |
| tabindex rules, roving tabindex, `aria-activedescendant` | DROP | Nearest: `.accessibilitySortPriority`, `.accessibilityElement(children: .contain)` | |
| Trap and restore focus (`<dialog>`, `inert`) | ADAPT | `.sheet`, `.alert`, `.confirmationDialog` and `.fullScreenCover` handle VoiceOver modality. Custom overlays need `.accessibilityAddTraits(.isModal)` + `@AccessibilityFocusState` (15). | |
| SPA route change: update title, move focus | ADAPT | `NavigationStack` posts screen changes itself. Custom view swaps post `AccessibilityNotification.ScreenChanged` (17). `.navigationTitle` is the screen name. | |
| Minimum hit area 24 / 44 / 40 | ADAPT | 44×44pt (HIG): `.contentShape(.rect)` + `.frame(minWidth: 44, minHeight: 44)` | No pseudo-elements; the no-overlap rule stays |
| Decorative layers get `pointer-events: none` | ADAPT | `.allowsHitTesting(false)` + `.accessibilityHidden(true)` | |
| Drag needs a single-pointer alternative | ADAPT | `.accessibilityAction(named:)`, `.accessibilityActions {}` (16), `List.onMove` + `EditButton`. `.swipeActions` (15) reach VoiceOver automatically; a custom `DragGesture` does not. | |
| Label and type every control | ADAPT | The `TextField` title is the label. `.textContentType(.emailAddress / .username / .password / .newPassword / .oneTimeCode)`, `.keyboardType`, `.textInputAutocapitalization(.never)` (15), `.autocorrectionDisabled()`, `.submitLabel` (15). | |
| A placeholder is never a label | CONFLICT | iOS Forms show the title as placeholder natively | Use `LabeledContent` (16) where an edited value needs a persistent visible label |
| Errors that announce: validate on submit, `aria-invalid`, focus first invalid | ADAPT + CONFLICT | Inline error text in the section footer; the error goes into `.accessibilityValue` or the hint; move `@FocusState` to the first invalid field; post an announcement | See conflict #4 |
| Accessible names everywhere; label in name | KEEP | `.accessibilityLabel`, `.accessibilityInputLabels` (14) for Voice Control, `Image(decorative:)`, `.accessibilityHidden` | Don't rely on SF Symbols' automatic labels |
| Don't rely on color alone | KEEP | Plus `@Environment(\.accessibilityDifferentiateWithoutColor)` | |
| Contrast requirement table | KEEP | Same ratios. Large text = 24pt regular or 18.67pt bold, since 1pt ≈ 1 CSS px. Must also hold in dark mode and with Increase Contrast. | Must match `better-colors` |
| Honor `prefers-reduced-motion` | ADAPT | `@Environment(\.accessibilityReduceMotion)`. System navigation and sheets already comply; custom `withAnimation` does not. | Add Reduce Transparency and Prefer Cross-Fade Transitions |
| Nothing the user needs runs on a timer | KEEP | Auto-advancing `TabView(.page)` carousels, custom toasts, `Timer` | |
| Announce dynamic content | ADAPT | `AccessibilityNotification.Announcement` (17) with priority set on the `AttributedString`; `.accessibilityAddTraits(.updatesFrequently)` | |
| Alt text by purpose | KEEP | `Image(decorative:)`, `.accessibilityLabel`; functional images name the action | |
| Structure is navigation: headings, `<main>`, skip link | ADAPT | `.accessibilityAddTraits(.isHeader)`, `.accessibilityHeading(_:)` (15), `.accessibilityRotor` (15) for long content | DROP skip link, landmarks, `scroll-margin` |
| Survive zoom and text resize (200%, 320px reflow) | ADAPT | Dynamic Type up to AX5 (about 3× body). `ViewThatFits` (16) or `dynamicTypeSize.isAccessibilitySize` to switch `HStack` → `VStack`; `AnyLayout` (16). `.accessibilityShowsLargeContentViewer()` (15) for chrome that can't grow. 320pt is still real: iPhone SE with Display Zoom. | Requirement lives here; text-style mechanics in typography |
| Never disable zoom; iOS input zoom via typography | DROP | — | |
| Before-you-finish table | REWRITE | New detection rows: `.onTapGesture` on a non-Button with no `.isButton` trait; icon-only `Button` with no label; `.font(.system(size:))` on body or control text; fixed `.frame(height:)` around `Text`; `.accessibilityHidden(true)` on an interactive view; custom `DragGesture` with no `.accessibilityAction`; movement in `withAnimation` with no reduce-motion branch; `.dynamicTypeSize(...)` clamp on content text | |
| `focus-and-keyboard.md` | DROP → new `voiceover-and-focus.md` | | |
| `hit-areas.md` | ADAPT | pt, `contentShape`, collision rule | |
| `motion-and-zoom.md` | ADAPT → `motion-and-dynamic-type.md` | The disable / replace / keep table is portable | |
| `forms.md` | ADAPT | `autocomplete` table → `textContentType` table; `inputmode` → `keyboardType` | |
| `screen-readers.md` | ADAPT | `.sr-only` → `.accessibilityElement(children: .combine)` or container labels; live regions → announcements | |
| `semantics-and-aria.md` | DROP → `traits-and-semantics.md` | Button vs Link vs NavigationLink table | |

**Add:**
- Voice Control and Switch Control (custom actions).
- Smart Invert: `.accessibilityIgnoresInvertColors()` (14) on photos and video.
- Bold Text (`legibilityWeight`), Button Shapes, and Reduce Transparency (critical with glass).
- `XCUIApplication().performAccessibilityAudit()` (Xcode 15 / 17), Accessibility Inspector, Xcode Environment Overrides.

---

### 3.2 `better-layout` → rewrite (L)

| Rule | Class | SwiftUI / UIKit equivalent | Note |
| --- | --- | --- | --- |
| Group with space, not lines (2× between groups) | KEEP | `VStack(spacing:)`, nested stacks | Exception: `List` / `Form` `.insetGrouped` separators are native. Don't strip `.listRowSeparator` to satisfy this. |
| Keep controls distinct from content | KEEP | Tint marks interactive text; `.buttonStyle(.bordered / .borderedProminent / .glass)` (glass: 26) | Button Shapes setting |
| Align to shared edges (16 default) | ADAPT | Prefer platform margins: `.padding()` with no value (16pt on iPhone), `.scenePadding()`, `.contentMargins` (17), `.safeAreaPadding` (17), list insets | HIG flavour: let the system pick |
| Logical properties for anything that mirrors | ADAPT (mostly free) | SwiftUI `.leading` / `.trailing` are logical already. Flag `.offset(x:)`, `.scaleEffect(x: -1)`, forced `.layoutDirection`, and `chevron.right` (use `chevron.forward`). `.flipsForRightToLeftLayoutDirection(true)` for custom images. UIKit: `leadingAnchor`, `NSDirectionalEdgeInsets`, `semanticContentAttribute`. | |
| Order by importance; visual order = source order | KEEP | VoiceOver follows view order. `.accessibilitySortPriority` only as a last resort; never lay out with `ZStack` + offsets. | |
| One primary action per view; more than 3 secondaries go in a menu | KEEP | `ToolbarItem(placement: .primaryAction / .confirmationAction)`, `Menu` with `ellipsis.circle`, `ToolbarSpacer` (26) | |
| Hint at hidden content (peek 16–32) | KEEP | `.scrollTargetBehavior(.viewAligned)` + `.scrollTargetLayout()` + `.containerRelativeFrame` + `.contentMargins` (all 17), `.scrollClipDisabled()` (17), `DisclosureGroup` | |
| Borderless controls need more clearance (12 / 24) | ADAPT | System toolbars and nav bars handle spacing. Custom icon rows: 44pt targets that never overlap. | |
| Inset buttons from the edges | ADAPT | iOS 26: bottom actions are capsules inset concentric with the display corners. `.safeAreaInset(edge: .bottom)`, `.buttonBorderShape(.capsule)`, `ConcentricRectangle` (26). | |
| Content bleeds, controls float | KEEP | `.background()` ignores safe areas by default; `.ignoresSafeArea()` on backgrounds only; `.backgroundExtensionEffect()` (26) for hero media under bars and sidebars | DROP `viewport-fit`, `env()`, RTL override recipe |
| Sticky header `scroll-padding` | DROP | System bars inset content; `.scrollEdgeEffectStyle` (26) | |
| Hold structure until it breaks; content breakpoints, container queries | ADAPT / partial CONFLICT | Size classes are the platform's adaptive signal (`horizontalSizeClass`). Use `ViewThatFits` / `AnyLayout` for component-level adaptation. `NavigationSplitView` collapses itself. iPadOS 26 windows resize freely. | "Not device presets" still holds: never branch on device model or `UIScreen.main.bounds` |
| Plan for growth: `max-width` / `min-height`, never fixed; pseudo-localize | KEEP | No `.frame(width:)` on text; `.fixedSize(horizontal: false, vertical: true)`. Xcode scheme pseudolanguages: Double-Length, RTL, Accented, Bounded String. | |
| Never park a critical action where it clips | KEEP | `.safeAreaInset(edge: .bottom)` follows the keyboard; sheets with detents | |
| Before-you-finish table (`minmax(0,1fr)`, `100vw`, `100vh`/`dvh`, `container-type`, `env()`, `float`, `translateX`) | DROP → rewrite | New rows: hardcoded `.frame(width: 375)`; `UIScreen.main.bounds` for layout; `GeometryReader` wrapping a whole screen; `.ignoresSafeArea()` on controls or text; `.offset` used for layout; fixed height on a text container; `HStack` with no `.layoutPriority` that pushes a trailing control off at AX sizes | |
| `grouping-and-alignment.md` | ADAPT | Recipes rewritten in SwiftUI | |
| `spacing-and-adaptivity.md` | ADAPT | Peek, growth and clearance recipes rewritten | |

**Add:**
- Size classes and iPad windowing.
- Dynamic Type layout switching.
- `List` / `Form` styles.
- Sheets and detents (`.presentationDetents` (16)).
- Navigation and presentation patterns (or a separate `better-navigation`, Q9).

---

### 3.3 `better-typography` → rewrite (M)

| Rule | Class | SwiftUI / UIKit equivalent | Note |
| --- | --- | --- | --- |
| Calibration: unitless line-height, weight ≥400 below 18px, 60–75 measure, 16px inputs, tabular nums | ADAPT | New exact values: text styles, Dynamic Type support, `.monospacedDigit()`, 11pt minimum (caption2) | |
| Fewer fonts, sizes and weights | KEEP | | |
| Weight ≥400 below 18px | ADAPT | Avoid `.ultraLight` / `.thin` / `.light` below ~20pt. Bold Text is automatic for text styles; custom fonts must honor `legibilityWeight`. | |
| Load the faces the design uses; font synthesis | ADAPT | Register custom fonts in `UIAppFonts`; bundle every weight you use | Synthesis longhands DROP |
| Properties over raw OpenType tags | DROP | — | CSS-specific |
| Leave optical sizing on auto | ADAPT (free) | SF Pro switches Text and Display cuts automatically. Never hardcode `"SFProDisplay-…"` by name. | |
| Use a type scale with semantic names | ADAPT | **Use system text styles**: `.largeTitle … .caption2`. A brand face uses `Font.custom(name, size:, relativeTo:)` (14) mapped to a text style, defined once in `extension Font`. UIKit: `UIFont.preferredFont(forTextStyle:)` / `UIFontMetrics.scaledFont(for:)` + `adjustsFontForContentSizeCategory`. | The core iOS typography rule |
| Heading sizes descend with level | KEEP | `.title > .title2 > .title3 > .headline` | Header trait is owned by accessibility |
| Line-height by role (unitless) | CONFLICT | Text styles carry tuned leading. `.lineSpacing` *adds* points, it isn't a multiplier. Use `Font.leading(.tight / .loose)` (14) only when needed. | |
| Letter-spacing by size | CONFLICT (SF) / ADAPT (custom fonts) | SF applies size-specific tracking automatically; adding `-0.02em` double-tightens. Custom fonts: `.tracking()` / `.kerning()` (16). | `apple-design` §15 says the same thing for the web |
| Cap the measure (60–75 characters) | ADAPT | iPad and Mac only: `readableContentGuide` (UIKit) or a `.frame(maxWidth:)` cap | Rarely matters on iPhone |
| Wrap deliberately (`balance`, `pretty`, `overflow-wrap`, `nowrap`) | ADAPT / DROP | `Text` already uses the standard line-break strategy (avoids lone last words in most cases) and breaks long URLs. No `balance` equivalent. `nowrap` = `.lineLimit(1)` + `.fixedSize()`. | `.minimumScaleFactor` conflicts with Dynamic Type when it shrinks enlarged text |
| `text-align: start`, never justify | KEEP | `.multilineTextAlignment(.leading)` | |
| Tabular numbers on changing values | ADAPT | `.monospacedDigit()` (15); animated values use `.contentTransition(.numericText(value:))` (17), owned by motion | |
| Truncate with a way back | ADAPT | `.lineLimit(n)`, `.truncationMode(.middle)` for file names, `.lineLimit(2, reservesSpace: true)` (16), expand control | "Way back" is owned by layout |
| Natural case, typographic punctuation | KEEP | `.textCase(.uppercase)` (14); typographic characters in String Catalogs | |
| Underlines from the font; dotted underline hint | DROP (mostly) | iOS links are tinted, not underlined; `.underline(pattern: .dot)` (16) if ever needed | |
| Inputs at 16px on mobile | DROP | — | Safari only |
| Size floors (16 / 14 / 13 / 12, in `rem`) | CONFLICT | iOS body is **17pt**; minimum 11pt; use text styles, never fixed pt | |
| Font smoothing on the root | DROP | — | |
| Language and bidi (`lang`, `dir`, `<bdi>`) | ADAPT | Locale-driven; `Text` detects paragraph direction; test with the RTL pseudolanguage; isolate interpolated user values (U+2068…U+2069) if they reorder | Digit-order rule stays |
| Trim text boxes (`text-box`) | DROP → ADAPT | Align icons with `.firstTextBaseline`; `Label` handles icon + text | |
| Decorative text in code, not images | KEEP | `Text` + `.foregroundStyle(gradient)`, `.shadow`; never rasterized text (VoiceOver, localization) | |
| Keep useful text selectable | CONFLICT (direction) | Non-selectable by default; `.textSelection(.enabled)` (15) on order numbers, addresses, error codes; `.contextMenu { Copy }` | Conflict #10 |
| `user-select: none` | DROP | — | |
| `choosing-fonts.md` | ADAPT | SF Pro / New York / SF Mono via `.fontDesign` (16.1), `.fontWidth` (16); formats table DROP; anatomy KEEP | |
| `spacing-and-sizing.md` | CONFLICT → replace | Text-style table at the default size: largeTitle 34, title 28, title2 22, title3 20, headline 17 semibold, body 17, callout 16, subheadline 15, footnote 13, caption 12, caption2 11 | |
| `details-and-accessibility.md` | DROP (mostly) | Caret color → `.tint` | |
| `wrapping-and-punctuation.md` | KEEP punctuation and i18n; DROP CSS measure | | |
| `variable-fonts-and-opentype.md` | DROP (mostly) | `Font.smallCaps()` (14); stylistic sets via `UIFontDescriptor` feature settings (rare) | |
| `css-cheat-sheet.md` | DROP → new SwiftUI ↔ UIKit cheat sheet with min-iOS column | | |

**Add:** `@ScaledMetric` (14) for spacing and icon sizes that should grow with text, Large Content Viewer, and `.dynamicTypeSize(...)` clamps on chrome only.

---

### 3.4 `better-colors` → adapt (M)

| Rule | Class | SwiftUI / UIKit equivalent | Note |
| --- | --- | --- | --- |
| Never report unmeasured contrast | KEEP | | |
| Match the project's color system; OKLCH for new systems | ADAPT | Asset catalog color sets (Any / Dark / High Contrast, sRGB / P3). Xcode 15 generates `Color.brandAccent` symbols. OKLCH only as authoring math; SwiftUI has no OKLCH. | |
| A system is ramps (one neutral, one accent, status) | CONFLICT (neutrals) / ADAPT (accent) | **Neutrals = system semantic colors**: `.primary` / `.secondary` / `.tertiary` / `.quaternary` (`.foregroundStyle`, 15/17), `Color(.systemBackground)`, `.secondarySystemBackground`, `.systemGroupedBackground`, `.separator`, fills. They adapt to dark, elevated and Increase Contrast. Accent = `AccentColor` asset + `.tint()`. Status = system `.red` / `.orange` / `.green` (adaptive). | A custom 12-step gray ramp loses elevated dark backgrounds and vibrancy |
| Every step has a job (Tailwind / Radix role table) | ADAPT | Replace with an iOS semantic-role table: label tiers, background tiers (base / grouped / elevated), separators, fills, tint | |
| Primitives by hue, semantics by role | KEEP | Asset catalog folders with "Provides Namespace", `extension ShapeStyle where Self == Color { static var textSecondary … }` | camelCase names |
| Use a token only in its role | KEEP | | |
| Hold the hue across the ramp | KEEP (brand ramps only) | Tooling, not runtime | |
| One color, one meaning (15°) | KEEP | Tint = interactive; never tint non-interactive text | |
| Fill exactly one action per view | KEEP | One `.borderedProminent` / `.glassProminent` (26) | |
| Measure the rendered pair | ADAPT | `Color.resolve(in:)` (17) for components; Accessibility Inspector's contrast calculator. Measure in light, dark, Increase Contrast and on elevated (sheet) backgrounds. | |
| Gradient interpolation space | DROP | No SwiftUI control that I know of; `Color.gradient` (16), `MeshGradient` (18) | Verify before writing |
| Before-you-finish table | ADAPT | New rows: `Color(red:green:blue:)` literals in views; `Color("name")` string lookups where generated symbols exist; `colorScheme == .dark ? a : b` branching instead of a dynamic asset color; `Color.black` / `.white` for text instead of `.primary`; `.white` text on the accent fill unmeasured; `.opacity()` text over glass; deprecated `.accentColor()` instead of `.tint()` | |
| Dark-mode notes: avoid pure-black ends; reversal is not dark mode | CONFLICT / KEEP | Base dark background **is** `#000`; elevated surfaces lighten. "Lower vividness in dark" stays. | Conflict #9 |
| `prefers-color-scheme` vs `.dark` class; `light-dark()` | DROP → ADAPT | One mechanism: dynamic asset colors. Override with `.preferredColorScheme` at the root for an in-app theme toggle. Never mix with per-view `colorScheme` branching. | |
| `prefers-contrast` per appearance | ADAPT | Asset catalog "High Contrast" variants; `@Environment(\.colorSchemeContrast)` | |
| Gamut (P3 with an sRGB fallback first) | ADAPT | Every supported iPhone is P3. Define P3 components in asset catalogs (`Color(.displayP3, …)`); the catalog handles fallback; Figma hex is usually sRGB. | |
| `color-mix()`, relative color syntax | DROP | — | |
| Cultural meaning of colors | KEEP | | |
| Translucent surfaces shift contrast | KEEP, more important | Liquid Glass and materials: let system vibrancy color text (`.secondary` inside a material); never put custom low-alpha colors on glass | |
| Tailwind `@theme` section | DROP | | |
| Audit an existing palette (grep literals) | ADAPT | Grep `Color(red:`, `UIColor(red:`, `#colorLiteral`, hex initializers, `.colorset/Contents.json` | |
| `color-formats.md` | ADAPT | Asset catalog gamut, P3 components; drop CSS sections | |
| `color-usage.md` | KEEP meaning, roles and cultures; DROP CSS gradients | | |
| `contrast.md` | KEEP thresholds and method; ADAPT translucency to glass | | APCA optional |
| `palette-generation.md` | ADAPT | Tooling only | |
| `palette-structure.md` | ADAPT | iOS role table replaces Tailwind / Radix | |
| `token-naming.md` | KEEP two tiers and grammar; DROP Tailwind | | |

**Add:** glass tinting (`.glassEffect(.regular.tint(…))` (26)), base vs elevated backgrounds and the app-icon variants (dark / tinted / clear, if in scope).

---

### 3.5 `better-writing` → adapt (S)

| Rule | Class | SwiftUI / UIKit equivalent | Note |
| --- | --- | --- | --- |
| Inventory the existing strings first | ADAPT | `Localizable.xcstrings`, `InfoPlist.xcstrings` (permission purpose strings), `String(localized:)` (15), `LocalizedStringKey` in `Text("…")`, `LocalizedStringResource`, App Intents phrases, notification copy | Purpose strings are interface copy too |
| One voice, one vocabulary; tone table | KEEP | | |
| Address the reader directly | KEEP | | |
| Plain words; tap vs click | KEEP | "tap" on iOS | |
| Build strings whole; ICU plurals; `Intl` | ADAPT | String Catalog "Vary by Plural"; automatic grammar agreement `^[\(n) photo](inflect: true)` (15, limited languages); `FormatStyle`: `.formatted(.currency(code:))`, `Date.FormatStyle`, `.relative(presentation: .named)`, `.list(type: .and)`, `Measurement`, `PersonNameComponents` | |
| Verb-first buttons | KEEP | | |
| Links describe their destination | KEEP | | |
| One capitalization policy (sentence case default) | CONFLICT | Default to Apple's style: title-style for buttons, menus, nav titles, tabs; sentence-style for footers and messages | Q8 |
| Settings describe the ON state | KEEP | `Toggle` labels; link with `UIApplication.openSettingsURLString` / `openNotificationSettingsURLString` (16) | |
| Errors say how to fix, next to the failure | KEEP | Section footer under the field | |
| Undo beats confirmation; confirmation copy rules | KEEP + ADAPT | `UndoManager` / shake to undo. `.confirmationDialog` + `Button(role: .destructive)`. On iPhone the dialog title is **hidden by default** (`titleVisibility: .automatic`), so the destructive button label must carry verb + object on its own. | |
| Empty states point forward | ADAPT | `ContentUnavailableView` (17), `.search(text:)` for the filtered case | |
| Placeholders show an example | KEEP + note | iOS Form title-as-placeholder convention (conflict #12) | |
| Before-you-finish table | ADAPT | New rows: `"\(n) items"` with no plural variant; `Text(verbatim:)` on user-facing copy; `DateFormatter` with a hardcoded `dateFormat`; "Are you sure"; Yes/No buttons. Single-button informational `.alert` with "OK" is native, so not a finding. | |
| `patterns.md` | KEEP destructive and status tables; ADAPT ICU → String Catalog and `Intl` → `FormatStyle` | | |

---

### 3.6 `better-ui` → rewrite and split (L)

**Surfaces and icons stay in `better-ui`. Motion rows move to `better-motion` (§3.13).**

| Rule | Class | SwiftUI / UIKit equivalent | Note |
| --- | --- | --- | --- |
| Outer radius = inner radius + padding | ADAPT | `ConcentricRectangle` / `.containerShape(…)` (26) compute concentricity with containers and device corners. Always continuous corners: `.rect(cornerRadius:, style: .continuous)`; UIKit `layer.cornerCurve = .continuous` (13). | Continuous corners are missing from both repos |
| Align optically where geometry looks off | KEEP (less needed) | SF Symbols are already optically aligned to text; `Label` handles icon + text; custom assets still need nudging | |
| Shadows for elevation, borders for structure | CONFLICT | iOS elevation = grouped backgrounds (`systemGroupedBackground` + `secondarySystemGroupedBackground`), materials and Liquid Glass. Layered ring shadows are a web look. Separators (`Divider`, list separators) are native. | Forced-colors part DROP |
| Outline images at pure black / white 10% | ADAPT, KEEP intent | `.overlay(shape.strokeBorder(.primary.opacity(0.1), lineWidth: 1 / displayScale))` | Apple's own artwork does this |
| Transitions, not keyframes, for interactive state | → motion | | |
| Press scales to 0.96 | → motion (CONFLICT) | | |
| High-frequency interactions get no animation | → motion (KEEP) | | |
| Gate motion behind reduced motion | → motion | | |
| Stagger, enter / exit, first render, icon cross-fade, theme switch, `transition-property`, `will-change` | → motion | | |
| Hover effects only on hover-capable pointers; tap highlight | ADAPT / DROP | iPad pointer: `.hoverEffect(.highlight / .lift)` (13.4), `.onContinuousHover` (16). No stuck-hover on touch. Tap highlight DROP. | |
| Contain scroll inside overlays | DROP | iOS scroll views don't chain to a page; `.presentationContentInteraction(.scrolls)` (16.4), `.scrollBounceBehavior(.basedOnSize)` (16.4) | |
| Match icon stroke to text weight | ADAPT | SF Symbols inherit weight and size from `.font()`; use `.imageScale` and `.fontWeight`. Custom symbols come from SF Symbols app templates. A hardcoded `.frame` or stroke width on a symbol is a CONFLICT. | |
| One SVG recolored per state | ADAPT | `.symbolRenderingMode(.hierarchical / .palette / .multicolor)` (15), `.foregroundStyle`, `.symbolVariant(.fill)` (15) | |
| Outline by default, fill when active | KEEP / CONFLICT | Toggles (bookmark, heart): `.symbolVariant(isOn ? .fill : .none)` is native. **Tab bars**: iOS uses the fill variant in both states and shows selection by tint and the glass lens. Don't swap outline/fill there. | |
| Mirror directional icons in RTL | ADAPT (mostly free) | Use `chevron.forward` / `.backward` (auto-mirrored), not `.right`. Asset catalog "Direction: Mirrors" for custom images. | |
| Design at render size; always SVG | ADAPT | Vector assets (PDF / SVG, "Preserve Vector Data") or custom SF Symbols | |
| Before-you-finish table | REWRITE | New rows: `RoundedRectangle` without `.continuous` (UIKit `cornerCurve`); nested radii not concentric; custom background on a toolbar or tab bar in iOS 26 (hides glass); glass on glass; `.shadow` stacks as borders; hardcoded symbol frames; `chevron.right` for navigation | |
| `surfaces.md` | REWRITE | Concentric, continuous, materials, glass | |
| `icons.md` | REWRITE | SF Symbols guide | |
| `animations.md`, `enter-exit.md`, `icon-transitions.md`, `performance.md` | → motion | | |

**Add Liquid Glass (26):**
- Glass belongs to the navigation and control layer that floats above content, never to content itself.
- Never stack glass on glass.
- System bars, toolbars and tab bars adopt it automatically, so remove custom bar backgrounds.
- APIs: `GlassEffectContainer` + `.glassEffectID` for morphing, `.glassEffect(.regular.interactive())`, `.buttonStyle(.glass / .glassProminent)`, `.scrollEdgeEffectStyle`, `.tabBarMinimizeBehavior(.onScrollDown)`, `.tabViewBottomAccessory`.
- Pre-26 fallback: `.ultraThinMaterial` … `.thickMaterial` (15).
- UIKit: `UIGlassEffect`, `UIButton.Configuration.glass()`.

---

### 3.7 `better-interface` → adapt (M)

| Rule | Class | SwiftUI / UIKit equivalent | Note |
| --- | --- | --- | --- |
| Evidence, not taste | KEEP | | |
| Resolve the scope first, incl. empty / loading / error / narrow | ADAPT | Add compact width, AX sizes, dark, iPad if supported | |
| Send a change to `interface-review` | KEEP | | |
| Recon before judgment | ADAPT | Deployment target, SwiftUI/UIKit mix, design-system package, asset catalogs, String Catalogs, supported devices and orientations, schemes, `xcodebuild` test command, preview availability; docs list unchanged plus any HIG references | |
| Domain order | ADAPT | Add `better-motion` (and `better-navigation`) | |
| Require evidence (`file:line` + rendered state) | ADAPT | Rendered = Preview or Simulator screenshot | |
| Rank by user impact (HIGH / MEDIUM / LOW) | KEEP | | |
| Escalation triggers | ADAPT | **No accessible name** KEEP. **Focus indicator** → custom tappable not exposed as a button. **Pointer but not keyboard** → custom gesture with no VoiceOver / Voice Control path. **Reduced motion** → `accessibilityReduceMotion`. **320px / 200%** → clipped at AX5 or 320pt. **Contrast, color-alone, destructive, truncation, scroll cue, error recovery, semantic misuse, motion-only** KEEP. **Add:** body or control text that ignores Dynamic Type (fixed `.system(size:)`). Candidate: targets under 44pt (Q12). | |
| Prefer the cheaper fix (Delete → Platform → Reuse → Correct → Add) | KEEP | "Use the platform" is where HIG lives: system control, modifier, text style, semantic color, system spring | Put the first-party-first table here (replaces `pick-ui-library`): `ContentUnavailableView`, `.searchable`, `.refreshable`, `.swipeActions`, `ShareLink`, `PhotosPicker`, TipKit, Swift Charts |
| Consolidate; cap at 15 | KEEP | | |
| Verify what can be verified | ADAPT | Xcode Previews (via Xcode MCP `mcpbridge` or XcodeBuildMCP), Simulator screenshot (`xcrun simctl io booted screenshot`), Accessibility Inspector, `performAccessibilityAudit()`, Environment Overrides | |
| Review without mutating | KEEP | | |
| Before-you-finish table | KEEP (one web row) | "Browser's own focus ring" row → "system control" | |
| `review-format.md` | KEEP | Domain names update | |

---

### 3.8 `interface-review` → adapt (M)

| Rule | Class | SwiftUI / UIKit equivalent | Note |
| --- | --- | --- | --- |
| The change, not the codebase | KEEP | | |
| Resolve the change scope first (merge base, counts) | KEEP | | |
| With no change, ask rather than invent | KEEP | | |
| A diff is not a surface: blast radius | ADAPT | Consumers of a View = call sites + its `#Preview`s. Tokens = asset color names (search the generated symbol, `Color("…")` and `Color(.…)`) and `ShapeStyle` extensions. Entry points = `App` / `Scene`, `NavigationStack` roots, `TabView` tabs, `.navigationDestination`. | |
| Read the removed lines (`removed-signals.md`) | ADAPT | New signals: `.accessibilityLabel/Hint/Value/AddTraits/Hidden/Element`, `Button` → `.onTapGesture`, `@FocusState`, `accessibilityReduceMotion`, `colorSchemeContrast`, `.font(.body)` → `.system(size:)`, `relativeTo:` removed, `.monospacedDigit`, `.lineLimit`, `.truncationMode`, `.textSelection`, `role: .destructive`, `chevron.forward` → `.right`, asset color → literal, `.xcstrings` entry deleted, `String(localized:)` → literal | Rewrite the grep regex |
| Equivalent replacements | ADAPT | E.g. `.accessibilityLabel` → `.accessibilityElement(children: .combine)` over visible text; `.onTapGesture` → `Button` | |
| Classify every finding; blame against the range | KEEP | | |
| Hold the change to its stated intent | ADAPT | State list becomes pressed / disabled / selected / focused / loading; "translation catalogue" → String Catalog; add dark mode and AX sizes | |
| Hand the review to `better-interface` | KEEP | | |
| Never mutate the working tree | KEEP | | Worktree rendering needs its own DerivedData and builds are slow |
| `scope-resolution.md`: excluded paths | ADAPT | Add `Pods/`, `Carthage/`, `DerivedData/`, `xcuserdata/`, `*.xcuserstate`, `Package.resolved`, `__Snapshots__/`, `*.xcresult`; treat `project.pbxproj` as metadata. **Keep in scope:** `*.colorset/Contents.json` (color change) and `*.xcstrings` (copy change). | |
| `gh` usage, PR refs, shallow clones, renames | KEEP | | |

---

### 3.9 `break` + `state-machine` + Emil's `break-ui` → one `previews` skill (M)

| Step / rule | Source | Class | SwiftUI workflow |
| --- | --- | --- | --- |
| Scope one component | all | KEEP | |
| Infer scenarios from the component (cue-based axes) | `break` | KEEP | Read init parameters, `@Environment` dependencies and model types |
| Find the states in the code (data / account / feature) | `state-machine` | KEEP | |
| Map every rendered value with its limit | `break-ui` | KEEP | Limits from SwiftData / Core Data models, API types, `TextField` length checks |
| Worst-case catalog (names, emails, numbers, time, media, states) | `break-ui` CATALOG | KEEP + ADAPT | Drop `.charAt(0)` / surrogate rows: Swift `Character` is a grapheme cluster. Initials via `PersonNameComponents.formatted(.name(style: .abbreviated))`. Plurals via String Catalog. Dates via `FormatStyle`. |
| Build a scratch route / throwaway page / `"use client"` | `break`, `state-machine` | DROP → ADAPT | One `#Preview("Long name")` per scenario or state, in a `…Previews.swift` file. Fixtures in "Preview Content" / Development Assets. Shared setup via a `PreviewModifier` (18). Interactive state via `@Previewable` (Xcode 16). |
| Feed data at the boundary, never edit the component | all | KEEP | Init parameters, a mock behind a protocol in `@Environment`, `.modelContainer(previewContainer)` for SwiftData |
| Environment scenarios: don't simulate them on the page | `break` | **REVERSE** | In SwiftUI, environment injection **is** the real mechanism. The component reads exactly these values, so they become first-class scenarios: `.environment(\.dynamicTypeSize, .accessibility5)`, `.environment(\.layoutDirection, .rightToLeft)`, `.environment(\.locale, …)`, `.preferredColorScheme(.dark)`, `#Preview(traits: .landscapeLeft)`. Plus canvas Variants (Color Scheme, Dynamic Type, Orientation). |
| Container widths as fixed boxes | `break` | ADAPT | `.frame(width: 320)` or `#Preview(traits: .sizeThatFitsLayout)` |
| Switcher (`__state` param, keys, `H` to hide) | `state-machine` | DROP → ADAPT | The canvas already flips between named previews. For an on-device workbench: a `#if DEBUG` state picker overlay. |
| "Demo / Worst case" toggle | `break-ui` | ADAPT | Two previews, or a `@Previewable @State` picker |
| Look once, then hand the URL over | `break`, `state-machine` | ADAPT | Render previews via Xcode MCP or snapshot tests (swift-snapshot-testing) or `ImageRenderer` (16). Without macOS: hand over the preview file and the list. |
| Failure signatures table (CSS causes and fixes) | `break-ui` | REWRITE | `Image` without `.resizable().aspectRatio(contentMode:)`; `HStack` pushing a trailing control off (`.layoutPriority`, `.fixedSize`); `.lineLimit(1)` on file names without `.truncationMode(.middle)`; `.font(.system(size:))` not scaling; fixed `.frame(height:)` clipping at AX sizes; `AsyncImage` without a failure phase |
| Truncate / wrap / clamp decision list | `break-ui` | KEEP | |
| Report table + owner skill, no verdict | `break` | KEEP | |
| Leave it up; delete on request | all | KEEP | Previews can be kept as regression fixtures; that's idiomatic in Swift |

---

### 3.10 `variant` + Emil's `prototype` → `variant` (M)

| Step / rule | Class | SwiftUI workflow |
| --- | --- | --- |
| Different answers on one axis; owners table | KEEP | Add a "Motion" axis owned by `better-motion` |
| The floor every variant clears (escalation triggers) | ADAPT | Use the new iOS trigger list |
| Scope one piece; learn the ground | KEEP | Recon: text styles, colors, design package |
| Name the axis before writing code (3, max 5) | KEEP | |
| Build into the real page; URL param `__variant`; floating picker | ADAPT | Host in the real screen behind `#if DEBUG`. Select via a launch argument (`-variant quiet`) or `@AppStorage`. The picker is a debug overlay deliberately outside the design system: a dark capsule placed above the tab bar / home indicator with `.safeAreaInset`. Not glass, so it can't be confused with the UI. Or one `#Preview` per variant for quick comparison. |
| Standalone HTML fallback | DROP | Previews in a scratch Swift package instead |
| `picker.md` / `PICKER.md` CSS + JS | DROP → rewrite | A SwiftUI picker view spec |
| Load once, present tradeoff table, never mark a favourite | KEEP | Judge at compact and regular width, light and dark |
| Promote one, delete the rest | KEEP | Search for `#if DEBUG` blocks and the variant names |

---

### 3.11 `build-design` → adapt (M)

| Rule | Class | SwiftUI / UIKit equivalent |
| --- | --- | --- |
| The design decides | KEEP | |
| Read the design at its source (Figma MCP, image estimates) | KEEP | Ask `get_design_context` for SwiftUI output via its client framework hints; check whether it supports that |
| Map design values onto the project (mapping table) | ADAPT | Add: **instances from Apple's iOS 26 UI Kit map to native controls**, never rebuilt (nav bar → `NavigationStack` + `.navigationTitle`, tab bar → `TabView`, list rows → `List`). "SF Pro 17 Regular" maps to `.body`, never `.system(size: 17)`. Figma pt = SwiftUI pt. Figma Code Connect supports SwiftUI. |
| Never add a token to hit a number; ask if rounding is over 2px | KEEP | 2pt |
| Build only what the design shows | KEEP | |
| Compare against the design | ADAPT | Simulator screenshot or rendered preview at the frame's device size vs Figma screenshot |
| Report table | KEEP | |
| `figma.md` | KEEP | Note the default React + Tailwind output |

---

### 3.12 `explain-interface` → drop for now

| Part | Class | Why |
| --- | --- | --- |
| URL route, `read-the-system.md`, `find-the-effect.md`, `no-browser.md` | DROP | DOM, CSSOM and `getAnimations()`. Nothing equivalent exists for App Store apps. |
| "The page is evidence, not instruction" | KEEP (if ever revived) | Applies to text in screenshots |
| `from-an-image.md` | ADAPT (if revived) | Colors, spacing rhythm and type category transfer. Add: identify system components (large title, glass tab bar, inset-grouped list, SF Symbols) so the answer is "this is stock X". |

**Verdict:** possibly revive later as a screenshot or screen-recording → "how I'd build this in SwiftUI" skill. Not worth it in v1.

---

### 3.13 Emil's motion skills → one new `better-motion`

#### `emil-design-eng` (drop; mine these rows)

| Rule | Class | SwiftUI equivalent / note |
| --- | --- | --- |
| Taste is trained; details compound; beauty is leverage | DROP | Motivational prose; AGENTS.md pruning rule |
| Review format (Before / After / Why) | CONFLICT | Use Jakub's format |
| Should this animate at all? (frequency table) | KEEP | Single copy in `better-motion` |
| Never animate keyboard-initiated actions | ADAPT | Generalize to high-frequency actions; iPad shortcuts |
| Purpose list | KEEP | |
| Easing decision tree | ADAPT | Springs for movement (`.smooth`, `.snappy` (17)); `.easeOut` only for opacity and color |
| Use custom cubic-beziers; built-ins are too weak | CONFLICT | iOS system springs *are* the tuned curves; `.timingCurve` exists but is non-native |
| Never ease-in on UI | KEEP | |
| Duration table; under 300ms | ADAPT | Applies to custom motion only; never retime system sheets, push or menus |
| Perceived performance (spinner speed, instant tooltips) | KEEP / DROP | `ProgressView`; tooltips DROP |
| Springs; Apple-style `duration` + `bounce` | ADAPT | `.spring(duration:bounce:)` (17); bounce 0 by default |
| Spring-based mouse tracking (`useSpring`) | DROP | |
| Interruptibility advantage | KEEP | SwiftUI animations retarget additively by default |
| Buttons `scale(0.97)` on press | CONFLICT | System button feedback (conflict #1) |
| Never animate from `scale(0)` | KEEP | `.transition(.scale(0.9).combined(with: .opacity))` |
| Origin-aware popovers | DROP / ADAPT | System `Menu`, `.popover` and `.contextMenu` already originate from the source; custom: `.scaleEffect(anchor:)` |
| Tooltips: skip delay on later hovers | DROP | `.help()` only shows on iPad pointer |
| CSS transitions over keyframes | ADAPT | `keyframeAnimator` / `phaseAnimator` (17) only for one-shot sequences |
| Blur to mask imperfect cross-fades | ADAPT | `.transition(.blurReplace)` (17) |
| `@starting-style` | DROP → `.transition` | |
| `translateY(100%)` percentages | ADAPT | `.transition(.move(edge:))` |
| `scale()` scales children; 3D; `transform-origin` | ADAPT | `.scaleEffect`, `.rotation3DEffect`, `anchor:` |
| `clip-path` recipes (hold-to-delete, tab color, reveal, comparison slider) | ADAPT | `.mask` / `.clipShape` with animatable shapes. Hold: `onLongPressGesture(minimumDuration:perform:onPressingChanged:)` + `.trim` progress. Tabs: `matchedGeometryEffect` (14). Reveal: `.scrollTransition` (17), marketing only. |
| Momentum dismissal (velocity > 0.11 px/ms) | ADAPT | `DragGesture.Value.velocity` (17), `predictedEndTranslation` (13); units are pt/s |
| Damping at boundaries; friction not walls | KEEP | `ScrollView` does it natively; keep a rubber-band function for custom drags |
| Pointer capture; multi-touch protection | DROP | `DragGesture` already handles both |
| Only animate transform and opacity | ADAPT (softer) | SwiftUI layout animations are acceptable; for continuous motion prefer `.offset` / `.scaleEffect` / `.opacity` |
| CSS variables inheritable; Framer shorthand; CSS beats JS; WAAPI | DROP | Analog: don't drive many child views from one `@State` changed every frame |
| Reduced motion | ADAPT | `accessibilityReduceMotion` |
| Hover gating | DROP | |
| Sonner principles | DROP | Library-author advice |
| Cohesion; opacity + height in lists | KEEP | |
| Asymmetric enter / exit timing | KEEP | `.asymmetric(insertion:removal:)` |
| Stagger 30–80ms | ADAPT | Rare on iOS (conflict #3) |
| Slow-motion and frame-by-frame debugging | ADAPT | Simulator → Debug → Slow Animations; screen recordings |
| Test on real devices | KEEP | Haptics and ProMotion only show on hardware |

#### `animate` + `RECIPES.md`

| Rule / recipe | Class | SwiftUI equivalent |
| --- | --- | --- |
| Run the sequence in order; no approximated values; extend tokens; cheapest tool | KEEP | |
| Tool ladder (CSS transition → `@starting-style` → CSS animation → WAAPI → Motion) | ADAPT | System component → `.animation(_:value:)` / `withAnimation` → `.transition` → `phaseAnimator` / `keyframeAnimator` (17) → gesture + spring → `TimelineView` / `Canvas` (15) / Metal shader effects (17) |
| Invoke `pick-ui-library` for components | DROP | "Use the system component" |
| Properties: transform / opacity, never `scale(0)`, origin at trigger, % translate, Motion shorthand | ADAPT / DROP | As above |
| Easing table, strong curves, duration table | ADAPT / CONFLICT | Springs |
| Interruption and exit | KEEP | |
| Reduced motion and pointer gating ship with it | ADAPT | Reduce motion yes; pointer gating DROP |
| Button press recipe | CONFLICT | System |
| Dropdown / popover / menu / select | DROP | `Menu`, `Picker`, `.popover` |
| Tooltip | DROP | |
| Modal | DROP | `.sheet` / `.fullScreenCover` |
| Drawer / sheet | DROP | `.sheet` + `.presentationDetents` (16) |
| Toast | ADAPT | Custom overlay (toasts aren't native; prefer inline confirmation) |
| Accordion | ADAPT | `DisclosureGroup` |
| Stagger | ADAPT | Rare |
| Hold to confirm | ADAPT | `onLongPressGesture` + `.trim` |
| Tab indicator with color transition | ADAPT | `matchedGeometryEffect` or `Picker(.segmented)` |
| Scroll reveal | ADAPT | `.scrollTransition`, marketing only |
| Drag to dismiss | DROP / ADAPT | System sheet; custom: `DragGesture` + `predictedEndTranslation` |
| Masking a cross-fade | ADAPT | `.blurReplace` |
| WAAPI | DROP | |

#### `animate-expo` + `RECIPES.md` (best seed for `better-motion`)

| Rule / recipe | Class | SwiftUI / UIKit equivalent |
| --- | --- | --- |
| No hover / two runtimes / finger on element | ADAPT | Hover → press: KEEP. Runtimes → "keep per-frame work out of `body`". Finger → gestures are primary: KEEP. |
| Gate; tab switches never slide | KEEP | `TabView` default; the iOS 26 tab-bar lens is system |
| Purpose | KEEP | |
| Tool table | ADAPT 1:1 | Transitions → `.animation(_:value:)`. Loops → `phaseAnimator` (17). Mount / unmount → `.transition`. List reflow → `withAnimation` on data change. Gestures → `DragGesture` + `@GestureState`. Screens → `NavigationStack`, never hand-rolled; `.navigationTransition(.zoom(sourceID:in:))` (18). formSheet → `.sheet` + detents (16). NativeTabs → `TabView` / `Tab` (18). `Link.Menu` / `Link.Preview` → `.contextMenu(menuItems:preview:)` (16). Large title → `.navigationBarTitleDisplayMode(.large)`. `RefreshControl` → `.refreshable` (15). Keyboard controller → automatic avoidance + `.safeAreaInset(edge: .bottom)`. Lottie → SF Symbol effects or `phaseAnimator` first. Skia → `Canvas` / `TimelineView` / shaders. |
| Install dependencies with `npx expo install` | DROP | |
| Properties: transform / opacity free | ADAPT | Softer, as above |
| Absolute childless `width` exception; Android elevation | DROP | |
| Never `scale(0)` | KEEP | |
| Transform order matters | ADAPT | Modifier order matters (`.scaleEffect` before vs after `.offset`) |
| Never animate `BlurView` intensity | ADAPT | Don't animate material or blur radius on large surfaces; glass morphing is system-driven |
| A finger means a spring | KEEP | |
| Spring config table (`dampingRatio`) | ADAPT | `.spring(duration: 0.4, bounce: 0)`; bounce ≈ 1 − dampingRatio; no `overshootClamping` equivalent, so use bounce 0 |
| Easing table, bezier tokens | CONFLICT | Springs |
| Durations; match the platform for navigation | KEEP | |
| Keep it off the JS thread | ADAPT | SwiftUI equivalent: don't write `@State` every frame from scroll or gesture callbacks. Use `.scrollTransition` / `.visualEffect` (17). Use `onScrollGeometryChange(for:of:action:)` (18) with a Bool transform so it fires only on threshold crossings (the `useAnimatedReaction` equivalent). |
| Press feedback on press-in, commit on press-out | KEEP | System `Button` does it |
| Scale 0.97 | CONFLICT | |
| 44×44pt + `hitSlop`; `pressRetentionOffset`; Android ripple | ADAPT / DROP | `.contentShape`; the rest DROP |
| Haptics table | ADAPT 1:1 | `.sensoryFeedback(.selection / .impact(weight: .light) / .impact(weight: .medium) / .success / .error, trigger:)` (17). UIKit: `UISelectionFeedbackGenerator`, `UIImpactFeedbackGenerator`, `UINotificationFeedbackGenerator`. Custom patterns: Core Haptics. |
| Haptic rules: same frame, one per action, never the only feedback | KEEP | Plus: system controls (pickers, swipe actions, context menus) already emit haptics, so don't double them |
| Reduced motion; text scales | ADAPT | Never animate to a hardcoded height |
| Setup that silently breaks motion | DROP | |
| 120fps: `CADisableMinimumFrameDurationOnPhone` | ADAPT (verify) | Matters when you drive frames yourself (`TimelineView`, `CADisplayLink`); check on device |
| Recipes: press | CONFLICT | |
| Recipes: bottom sheet | DROP | `.sheet` + detents; custom only for in-screen panels |
| Recipes: swipe to delete | DROP | `.swipeActions` (15) + `.onDelete` |
| Recipes: collapsing header | DROP | Large titles; custom: `.scrollTransition` |
| Recipes: list entrances | CONFLICT | Don't animate `List` rows in |
| Recipes: keyboard | DROP | Automatic |
| Recipes: tab indicator | ADAPT | `matchedGeometryEffect` |
| Recipes: screen transitions table | ADAPT 1:1 | Push / `.sheet` / `.fullScreenCover` / detents; Reduce Motion is automatic |
| Recipes: toast | ADAPT | |
| Recipes: firing once at a threshold | ADAPT | `onScrollGeometryChange` with a Bool |
| `project()` / `rubberband()` worklets | ADAPT | `predictedEndTranslation` is built in; keep `rubberband` as a Swift function |

#### `apple-design` (rewrite; split between `better-motion`, `better-ui` and `better-interface`)

| Section | Class | SwiftUI equivalent / note |
| --- | --- | --- |
| 1 Response: feedback on press-down, kill latency | KEEP | System controls do it; audit artificial delays |
| 2 Direct manipulation 1:1 + grab offset | ADAPT | `DragGesture` translation from the start location; pointer capture DROP |
| 3 Interruptibility: start from presentation value, blend velocity | KEEP (mostly free) | SwiftUI and `UIViewPropertyAnimator` retarget from presentation values; springs keep velocity (17). Don't hand-build it. |
| 4 Springs: damping + response; Apple value table | ADAPT | `.spring(response:dampingFraction:)` or `.spring(duration:bounce:)` (17); `.smooth` / `.snappy` / `.bouncy` |
| 5 Velocity hand-off | ADAPT (mostly free) | Pass gesture velocity, or let iOS 17 springs inherit it |
| 6 Momentum projection | ADAPT | `predictedEndTranslation` |
| 7 Spatial consistency; mirror easing | KEEP | System transitions are symmetric |
| 8 Hint in the direction of the gesture | KEEP | |
| 9 Rubber-banding | KEEP | `ScrollView` native; custom function |
| 10 Gesture feel checklist (hysteresis, parallel recognition) | ADAPT | `DragGesture(minimumDistance:)`, `.simultaneousGesture`, `.highPriorityGesture` |
| 11 Frame-level smoothness | ADAPT | `CADisplayLink` / `TimelineView` |
| 12 Materials and depth | REWRITE → `better-ui` | Liquid Glass and materials; "never stack glass on glass" and "scroll edge effects, not hard dividers" are now system rules (`.scrollEdgeEffectStyle` (26)) |
| 13 Multimodal feedback | ADAPT → motion | `.sensoryFeedback` |
| 14 Reduced motion / transparency / contrast | ADAPT → accessibility | Environment values |
| 15 Typography | ADAPT → typography | System does it (conflict) |
| 16 Eight principles + feedback / wayfinding / grouping / labels | CONDENSE | Turn into rules in `better-layout` / `better-navigation` and `better-writing`; drop the essays |
| 17 Process (prototype, review with fresh eyes) | DROP | Covered by `variant` |
| Quick reference | REWRITE | SwiftUI values |

#### `review-animations` + `STANDARDS.md` → `better-motion` `## Reporting`

| Rule | Class | Note |
| --- | --- | --- |
| Ten standards | ADAPT | Justified, frequency, asymmetric and cohesion: KEEP. Easing: CONFLICT (springs). Sub-300ms: custom motion only. Origin / `scale(0)`: KEEP `scale(0)`, drop origin for system UI. Interruptibility: KEEP (flag `keyframeAnimator` on interactive state). GPU-only: softer. Accessibility: reduce motion only. |
| Escalation triggers | REWRITE | New: `.animation(_)` with no `value:` (deprecated in iOS 15; it's SwiftUI's `transition: all`), `.easeIn` on entrances, `.repeatForever` on functional UI, custom bezier tokens, custom press scale on system buttons, motion with no reduce-motion branch, hand-rolled sheets / push / tab transitions, entrances on `List` rows |
| Remedial hierarchy | KEEP, merged | Matches Jakub's Delete → Platform → … ladder |
| Output format | CONFLICT | Use Jakub's |
| `STANDARDS.md` | DROP | Duplicate |

#### `improve-animations` (+ `AUDIT.md`, `PLAN-TEMPLATE.md`): drop or defer

| Part | Class | Note |
| --- | --- | --- |
| Recon greps | ADAPT | `withAnimation`, `.animation(`, `.transition(`, `.spring`, `.easeIn`, `.repeatForever`, `matchedGeometryEffect`, `UIView.animate`, `accessibilityReduceMotion` |
| Audit categories | MERGE → motion | |
| Self-contained plans for weaker executors (`plans/`) | KEEP (if you keep the skill) | Platform-agnostic workflow; verification becomes Simulator Slow Animations + Reduce Motion override |
| `AUDIT.md` | DROP | Duplicate |
| `PLAN-TEMPLATE.md` | KEEP if kept | |

#### `find-animation-opportunities` → fold into `better-motion` as "Where motion is missing"

| Part | Class | Note |
| --- | --- | --- |
| The gate (frequency, purpose, speed, function) | MERGE | One copy |
| Hunt list | ADAPT | `if isOpen { … }` with no `.transition`; state swaps outside `withAnimation`; SF Symbol swaps without `.contentTransition(.symbolEffect(.replace))` (17); changing numbers without `.numericText`; commits with no haptic; long-press with no feedback |
| Rejected-candidates section | KEEP | Valuable restraint device |

#### `animation-vocabulary` → `better-motion/vocabulary.md`

| Group | Class | Note |
| --- | --- | --- |
| General terms (fade, scale, stagger, spring, damping, momentum, rubber-banding, crossfade, morph, interruptible…) | KEEP | |
| Web terms (keyframes "browser fills", fill mode, `will-change`, layout thrashing, compositing, view / page transition, ripple, CSS clip-path / mask) | ADAPT / DROP | Map to SwiftUI: `matchedGeometryEffect`, `.navigationTransition(.zoom)`, symbol effects (Bounce, Pulse, Variable Color, Replace, Magic Replace, Draw (26)), `phaseAnimator` / `keyframeAnimator`, `.contentTransition(.numericText)`, `.scrollTransition`, `.visualEffect`, glass morphing (`glassEffectID`) |

---

### 3.14 Emil's other skills

#### `write-swift`: convert as-is (S)

| Section | Class | Note |
| --- | --- | --- |
| 1–16 and Quick Reference (value types, errors, concurrency, Sendable, structured concurrency, SwiftUI concurrency, generics, API design, performance, ARC, Swift Testing, macros, logging, unsafe, modern syntax, migration) | KEEP | Accurate as of Aug 2026. Version-stamped claims ("Swift 6.3 current", ⚠ 6.4) will go stale; review each Swift release. |
| Initial Response block | CONFLICT (house style) | Remove |
| Description | ADAPT | 70-word keyword list; cut to one or two sentences per AGENTS.md |
| Gap | — | It covers the language, not SwiftUI data flow (`@State` / `@Observable` / `@Bindable` / `@Environment`), view identity or `List` performance. Possibly a future `better-swiftui`. |

#### `mobile-native`: drop

| Rule | Class | Note |
| --- | --- | --- |
| All 11 fixes (sticky hover, tap highlight, `vh`, input zoom, 300ms delay, overscroll, notch / `viewport-fit`, long-press select, carousel `touch-action`, `theme-color`, test on hardware) and the Baseline | DROP | Mobile Safari only |
| "Test on hardware" | KEEP | Moves to `better-motion` (haptics, ProMotion) |
| "Never disable zoom" | — | Its native counterpart (Dynamic Type) lives in `better-accessibility` |

#### `prototype` (+ `PICKER.md`) → merged into `variant`

| Part | Class | Note |
| --- | --- | --- |
| Divergence, axes, craft bar | KEEP | Merged with `variant` |
| Isolated route vs Jakub's "real page" | CONFLICT | Pick Jakub's (real screen); previews for quick looks |
| Picker spec (CSS / JS, replay key `R`) | DROP → rewrite | Keep the replay idea: re-trigger with `.id(UUID())` |
| `riff` / `keep` invocation variants | KEEP | Nice ergonomics |

#### `pick-ui-library`, `ask-sonner` (+ `API.md`), `performance-cheatsheet.md`: drop

All npm, React or Framer content.

---

## 4. Missing iOS-specific concerns

| Concern | Covered today? | Owner | Key APIs |
| --- | --- | --- | --- |
| **Dynamic Type** | No (only web 200% zoom) | Accessibility (requirement), Typography (mechanics), Layout (AX-size layout) | Text styles, `Font.custom(…, relativeTo:)` (14), `@ScaledMetric` (14), `dynamicTypeSize.isAccessibilitySize`, `ViewThatFits` (16), Large Content Viewer (15) |
| **VoiceOver** | ARIA only | Accessibility | Labels, traits, `.accessibilityElement(children:)`, custom actions, rotors, `AccessibilityNotification` (17), `@AccessibilityFocusState` (15) |
| Voice Control, Switch Control, Full Keyboard Access | No | Accessibility | `.accessibilityInputLabels` (14), custom actions, `.keyboardShortcut` |
| **Reduce Motion / Transparency, Increase Contrast, Bold Text, Differentiate Without Color, Smart Invert, Button Shapes** | Only reduce-motion / contrast in CSS form | Accessibility (requirement); colors, ui and motion (implementation) | Environment values; `.accessibilityIgnoresInvertColors()` |
| **Safe areas** | CSS `env()` | Layout | Default behaviour, `.safeAreaInset` (15), `.safeAreaPadding` (17), `.ignoresSafeArea` on backgrounds only, `.backgroundExtensionEffect` (26) |
| **SF Symbols** | No | UI | Rendering modes, variants, `variableValue` (16), effects (17/18), Draw (26), `.forward` / `.backward` localized names, custom symbols |
| **Materials / Liquid Glass** | Web `backdrop-filter` only | UI | See §3.6 |
| **Haptics** | RN only | Motion | `.sensoryFeedback` (17), `UIFeedbackGenerator`, Core Haptics |
| **Dark mode** | CSS media / class | Colors | Semantic colors, asset appearances, base vs elevated, previews in both |
| **Display P3** | CSS `@media (color-gamut)` | Colors | Asset catalog gamut, `Color(.displayP3, …)`, P3 images |
| **`#Preview` for state testing** | No | `previews` verb (+ verification in every domain) | `#Preview` (Xcode 15), traits, `@Previewable` (Xcode 16), `PreviewModifier` (18), canvas Variants |
| Continuous corners and concentricity | Concentric only | UI | `.continuous`, `ConcentricRectangle` (26) |
| **Navigation and presentation** | Barely | Layout or new `better-navigation` | `NavigationStack` / `NavigationSplitView`, `TabView`, `.sheet` / detents / `.fullScreenCover` / `.popover`, toolbars, `Menu`, `.contextMenu`, `.swipeActions`, `.searchable`, `.confirmationDialog` |
| **System components first** | Web libraries list | `better-interface` "Use the platform" | `ContentUnavailableView`, `.refreshable`, `ShareLink`, `PhotosPicker`, TipKit, Swift Charts |
| Localization | ICU / `Intl` | Writing (copy), Layout (growth), Typography (bidi) | String Catalogs, pseudolanguages, `FormatStyle` |
| iPad / pointer / keyboard / windowing | No | Layout, Accessibility | Size classes, `.hoverEffect`, `.keyboardShortcut`, iPadOS 26 windows |
| Permission prompt timing and copy | No | Writing | `NSCameraUsageDescription` and friends, `InfoPlist.xcstrings` |
| Automated accessibility audit | No | Accessibility / `better-interface` verification | `performAccessibilityAudit()` (Xcode 15) |
| UIKit fallback | No | Every domain's cheat sheet | `preferredFont` + `adjustsFontForContentSizeCategory`, `cornerCurve`, `UIColor.label`, `UIView.animate(springDuration:bounce:)` (17), `UIGlassEffect` (26) |
| App icon (light / dark / tinted / clear, Icon Composer) | No | Optional, `better-ui` | Probably out of scope |

---

## 5. Workflows that don't translate

| Skill | Web workflow | SwiftUI workflow instead |
| --- | --- | --- |
| `break`, `state-machine`, `break-ui` | Scratch route + fixtures + URL-param switcher, one browser load | `#Preview` per scenario or state with fixtures; environment overrides as first-class scenarios; render via Xcode MCP or snapshot tests; keep previews as regression fixtures |
| `variant`, `prototype` | Real page + `?__variant=` + CSS picker | `#if DEBUG` overlay in the real screen, launch argument or `@AppStorage` selection; previews for quick comparison |
| `build-design` | Browser screenshot at each frame width | Simulator screenshot or rendered preview at the frame's device size |
| `explain-interface` | Chrome DevTools MCP + fetch | None for other people's apps; screenshot reconstruction only |
| Domain verification ("with a browser…") | DevTools, Animations panel at 10%, zoom 200% | Previews, Simulator Slow Animations, Environment Overrides (Dynamic Type, appearance, contrast), Accessibility Inspector, `performAccessibilityAudit()` |
| `interface-review` rendered verification | Render the worktree in a browser | Build the worktree in Xcode (separate DerivedData), or mark **Not verified** |
| `improve-animations execute` | Executor in a worktree, browser feel-check | Same, with a Simulator feel-check; device for haptics |

All of the above need macOS. In a Linux cloud session, every rendering step is **Not verified**. The skills must say so up front (Q5).

---

## 6. Descriptions and triggers

Jakub's convention is one or two plain sentences, no trigger list, mirrored in the README. Keep it. But the sentence **must name the platform** ("…in SwiftUI and UIKit apps") or the skill can't distinguish an iOS request from a web one.

| Skill | Current description issue | Risk in a Swift project |
| --- | --- | --- |
| `better-accessibility` | "ARIA … against WCAG 2.2" | Fires on accessibility questions, then answers with ARIA |
| `better-ui` | "border radius, optical alignment, shadows" | Fires, then steers toward shadows and CSS |
| `better-typography` | "font features, wrapping, truncation" | Fires, then answers in CSS |
| `better-layout` | "responsive structure … mirrored" | Fires, then answers in CSS |
| `better-colors` | Neutral | Fires; ramp-building content |
| `better-writing` | Neutral | Fine |
| `break` | "on a temporary page" | User-invoked; wrong workflow |
| `state-machine` | "throwaway page" | User-invoked; wrong workflow |
| `explain-interface` | "website … live URL" | User-invoked; irrelevant |
| `apple-design` | "translated for the web … springs, materials, typography" | **High.** Named "apple-design", fires on exactly iOS questions, answers with `backdrop-filter` |
| `mobile-native` | "Make a web app feel native on a phone" | **High.** "Make this feel native" in an iOS project loads tap-highlight CSS |
| `animate` | "Use when asked to animate something, add motion…" | **High.** Fires on any animation request; CSS + Motion answers |
| `animate-expo` | "React Native and Expo … sheets, haptics, gestures" | **Medium.** Haptics and sheet requests |
| `emil-design-eng` | "UI polish, component design, animation decisions" | **High.** Vague; fires anywhere |
| `find-animation-opportunities` | "make this feel more alive" | Medium |
| `improve-animations` | "make this app feel better" | Medium |
| `break-ui` | "stress-test, break, edge cases" | Medium; CSS fixes |
| `write-swift` | Long keyword pile | Fires correctly; violates house style |

**Name collisions.** If you keep Jakub's or Emil's originals installed for web work, model-invoked skills named `better-typography` exist twice. Plugin namespacing only helps slash commands (Q4).

---

## 7. Recommended conversion order (highest value first)

| Phase | Work | Effort | Why this position |
| --- | --- | --- | --- |
| 0 | Repo skeleton: rewrite `AGENTS.md` (target list, ownership table, iOS conventions, draft trigger list), manifests, LICENSE + NOTICE, README; delete dropped skills; drop in `write-swift` as-is | M | Every later conversion reads AGENTS.md. `write-swift` is free value. |
| 1 | `better-accessibility` | L | Foundation: Dynamic Type and VoiceOver requirements that every other skill references. Largest native gap. |
| 2 | `better-motion` (new, from `animate-expo` + `animate` + `apple-design` + `better-ui` motion + review standards + vocabulary) | L | Most of Emil's value; removes the biggest misfire risk; resolves conflicts 1, 2, 3, 5, 6 |
| 3 | `better-ui` (surfaces, Liquid Glass, SF Symbols) | L | iOS 26 look lives here |
| 4 | `better-typography` | M | Mostly deletion plus text styles |
| 5 | `better-layout` (+ `better-navigation` if split) | L | Needs accessibility's Dynamic Type rules in place |
| 6 | `better-colors` | M | Mostly deletion plus semantic colors |
| 7 | `better-writing` | S | Small diff |
| 8 | `better-interface` | M | After the domains, so the trigger list and domain order are final |
| 9 | `previews` | M | Biggest workflow win once Xcode tooling is decided |
| 10 | `build-design` | M | Useful as soon as you build from Figma |
| 11 | `interface-review` | M | Git logic is already done; it needs the final signal lists |
| 12 | `variant` | M | Lowest-frequency verb |
| Later | `explain-interface` (screenshot → SwiftUI), `improve-animations` | — | Only if you miss them |

---

## 8. Open questions

1. **iOS 26 as deployment target or as design spec?** Which Xcode SDK do you build with? Xcode 27 ignores `UIDesignRequiresCompatibility` ([Apple forums](https://developer.apple.com/forums/thread/832543)).
2. **How much UIKit?** (a) SwiftUI rules + a UIKit column in each cheat sheet, or (b) full parity. I recommend (a).
3. **Platforms:** iPhone only, or iPad / Mac Catalyst / visionOS? This changes layout, keyboard and pointer coverage.
4. **Coexistence:** will you keep Jakub's or Emil's originals installed for web projects? If so, rename (e.g. an `ios-` prefix or a different plugin name) to avoid duplicate model-invoked names.
5. **Toolchain:** local Claude Code on macOS with Xcode 26.3+ `mcpbridge` or XcodeBuildMCP? Or cloud sessions like this one, which can't build or render?
6. **Codex / opencode:** keep `agents/openai.yaml` and `opencode.json`? If not, drop them and the "set both halves together" rule.
7. **Accessibility standard:** HIG + Nutrition Label criteria only, or keep WCAG numbers (needed if the app ships in the EU under the Accessibility Act)?
8. **Capitalization:** adopt Apple's title-style convention for buttons, menus and titles?
9. **Navigation and presentation:** a new `better-navigation` skill, or a section of `better-layout`?
10. **Keep or drop** `improve-animations` (plans for cheaper models) and a future screenshot-based `explain-interface`?
11. **Repo identity:** keep `byturna/skills` as a GitHub fork of `jakubkrehel/skills` (visible credit, but PRs default to upstream), or start a fresh repo with a NOTICE? Archive `Emil-skills` after extraction?
12. **Severity:** should a tap target under 44pt be a HIGH escalation trigger, or MEDIUM?
13. **Plugin shape:** one plugin (`interfaces`-style), or two in the marketplace (e.g. `ios-interface` + `swift`) so `write-swift` installs separately?

---

### Sources

- [Apple Developer Forums: planned removal of UIDesignRequiresCompatibility](https://developer.apple.com/forums/thread/832543)
- [MartianCraft: Xcode 26.3, MCP and agentic development](https://martiancraft.com/blog/2026/03/xcode26-3-what-is-mcp-and-agentic-development/)
- [Noqta: Liquid Glass iOS 27 adoption guide](https://noqta.tn/en/blog/apple-liquid-glass-ios-27-developer-adoption-guide-2026) (third-party; used only for "iOS 27 refines Liquid Glass")
