> An independent audit of jakubkrehel/skills only, written by another session on 2026-10-06 and recovered from the branch it was committed to. Its corrections to audit.md are listed in [README.md](README.md).

# SwiftUI conversion audit

An audit of every skill in this fork for use on native iOS apps built with Swift and SwiftUI. It is read-only. No file under `skills/` and no repository file was changed to produce it.

| | |
| --- | --- |
| Repository state | Branch `claude/practical-edison-d49i5o` at `d574cc8`, plugin version `1.10.2` |
| Read in full | All 13 `SKILL.md` files, all 38 reference files, all 13 `agents/openai.yaml`, `AGENTS.md`, `CLAUDE.md`, `README.md`, both `.claude-plugin` manifests, `opencode.json` and `.gitattributes` |
| Date | 2026-10-06 |
| API availability | Checked against Apple's developer documentation on the audit date. iOS 27 additions were not surveyed, so a newer replacement may exist for some entries |
| Apple's numbers | Quoted from the HIG pages on accessibility, alerts, buttons, tab bars, SF Symbols, materials, motion, color and dark mode, and from App Store Connect's Accessibility Nutrition Label criteria. Links are under **Sources** |

## How to read this

**Classifications**

- **KEEP**: platform-agnostic. Works as written.
- **ADAPT**: the principle holds and the mechanism changes. The SwiftUI column names the replacement.
- **DROP**: web-only with no meaningful native equivalent. Where a native concern sits nearby, the note names it.
- **CONFLICT**: following it would make the app feel less native or contradicts the HIG. The note says what the platform does instead.

**Min iOS** is the availability Apple's documentation lists for the API named. It is blank where the row names no API or where the API is iOS 13 or 14, below any deployment target a new app would choose.

**Effort**

- **S**: under a quarter of the text changes and no new reference files.
- **M**: a quarter to two thirds of the text changes, or reference files are rewritten.
- **L**: most of the text changes and new reference files are needed.

## Headline findings

1. **No skill converts as-is.** The closest are `better-writing` and `interface-review`, whose methods are platform-agnostic and whose code examples and file patterns are web.
2. **The principles mostly survive; the detection tables do not.** Every domain skill's `## Before you finish` table is a list of CSS, Tailwind and JSX patterns. Those tables are what an agent greps for. A skill with SwiftUI principles and web tables will review Swift code and find nothing, so each table has to be written from scratch rather than translated row by row.
3. **Typography and UI polish actively fight the platform.** Fixed `px` floors, `1.5` line-height, negative tracking on headings, a `0.96` press scale on every button, layered `box-shadow` rings and hand-set icon stroke widths all have a system answer on iOS. Those answers are Dynamic Type text styles, San Francisco's built-in tracking, system button styles, materials and SF Symbols weights. Ported literally, these two skills would make an app look like a web view.
4. **The escalation triggers are web-shaped and restated in three places.** `better-interface` owns the list, `variant` restates it as its floor and every domain skill's `## Reporting` names its share. "Visible focus indicator", "320px width or 200% zoom" and "`prefers-reduced-motion`" all need iOS forms, so the list is the first thing to rewrite. A proposed list is in **2.1**.
5. **The biggest gap is Dynamic Type.** The skills treat text resize as browser zoom and `rem` units. On iOS it is the central accessibility and typography concern, and Apple's Larger Text criteria require 200% or the system maximum. VoiceOver specifics, haptics, SF Symbols, materials and Liquid Glass, safe areas, keyboard avoidance and `#Preview` are also absent.
6. **The rendering skills belong in `#Preview`.** `break`, `state-machine` and `variant` are built on a scratch route and a browser. A preview can set Dynamic Type size, color scheme, layout direction and locale through the environment, which is how the system applies them. That reverses `break`'s rule against simulating viewing modes for dark mode, text size, RTL, locale and Bold Text. `break` and `state-machine` converge on the same harness and should probably merge.
7. **`explain-interface` does not translate.** Its method reads the DOM and stylesheets of a live page. A shipped iOS app is a compiled binary with nothing equivalent to read, and only the screenshot branch survives. I would not convert it.
8. **Rendering needs macOS and Xcode.** Every "load it once in a browser" step becomes "build in Xcode or the Simulator", which an agent on Linux, such as a cloud session, cannot do at all. The iOS skills need `Not verified` as the normal path there, not the exception.
9. **Several web values are already Apple's.** `better-layout`'s `12px` and `24px` control clearances match the HIG's 12pt and 24pt. HIG reduced-motion guidance matches `better-accessibility`'s disable, replace and keep table. HIG motion says to "avoid adding motion to UI interactions that occur frequently", which is `better-ui`'s rule word for word. Where Apple's numbers differ they are in **2.2**.

## 1. Summary

| Skill | Verdict | Effort | Reason |
| --- | --- | --- | --- |
| `better-accessibility` | Rewrite | L | The principles hold, but every mechanism is DOM and ARIA. VoiceOver traits, grouping and actions, Dynamic Type, Voice Control and Switch Control are missing, and five of six reference files are browser-only |
| `better-typography` | Rewrite | L | Built on CSS units, font loading and OpenType properties. On iOS, Dynamic Type text styles and San Francisco own most of it, and the size, leading, tracking and 16px-input values conflict with the platform |
| `better-ui` | Rewrite | L | The press scale, shadow rings, icon stroke table and tab-icon rule conflict with system button styles, materials, Liquid Glass and SF Symbols. Haptics and symbol effects are missing |
| `better-layout` | Adapt | M | Grouping, ordering, clearance and safe-area principles hold, and the HIG agrees with its numbers. The recipes and detection table are CSS, and SwiftUI already mirrors leading and trailing |
| `better-colors` | Adapt | M | The color science transfers: ramps, OKLCH, roles and contrast measurement. Notation, theming and gamut move to asset catalogs, and neutrals should default to system semantic colors |
| `better-interface` | Adapt | M | Orchestration, severity, consolidation and the verdict are agnostic. The escalation triggers, recon checklist and verification commands are web, and three other skills depend on the triggers |
| `better-writing` | Adapt (light) | S | Copy rules are platform-agnostic. String files, plural and format APIs change, and Apple's title-style default for buttons conflicts with the sentence-case default |
| `interface-review` | Adapt | S | Git scope resolution and classification are agnostic. The excluded paths, removed-signal patterns and consumer discovery change, because Swift files in one module never import each other |
| `state-machine` | Rewrite | M | One `#Preview` per state replaces the scratch route and the switcher, and the Xcode canvas already switches between previews. Data-boundary injection and real-shaped fixtures carry over |
| `break` | Rewrite or merge | M | A preview matrix replaces the harness page. The scenario axes carry over, and the environment axis can now render four viewing modes faithfully. It overlaps `state-machine` almost completely |
| `build-design` | Adapt | M | The workflow is agnostic. Figma returns React by default, iOS UI-kit layers must map to system controls rather than be rebuilt and the comparison step needs the Simulator |
| `variant` | Adapt | M | Axes, floor and tradeoff table carry over. The URL-param picker becomes a DEBUG-only overlay or one preview per variant |
| `explain-interface` | Drop | none | Its method is reading a live page's DOM, CSS and animations. An iOS app exposes none of that, and its screenshot branch is the only part that transfers. Keep the upstream web skill if studying websites is useful |
| Repository files | Adapt | M | Plugin and marketplace name collide with upstream, the README install path, author and links are upstream's and `AGENTS.md`'s ownership table and conventions name CSS |

## 2. Cross-cutting changes

### 2.1 Escalation triggers

`better-interface` owns these and `variant` restates them as its floor. Every domain skill's `## Reporting` names its share, so all three change together.

| Current trigger | Class | iOS form |
| --- | --- | --- |
| An interactive control with no accessible name | KEEP | A control with no VoiceOver label, or one exposed without its button, adjustable or toggle trait. An SF Symbol's derived label is not a reliable name |
| A keyboard-reachable control with no visible focus indicator | ADAPT | Only where the app supports a hardware keyboard or Full Keyboard Access: a focusable control with `.focusEffectDisabled()` and no replacement. Irrelevant on touch-only iPhone flows |
| A control or path reachable by pointer but not by keyboard | ADAPT | A control reachable by touch but not by VoiceOver, Voice Control or Switch Control. The common cause is a gesture-only action, such as a custom swipe or `.onTapGesture` on a non-button, with no `.accessibilityAction` |
| Motion or auto-playing content that ignores `prefers-reduced-motion` | ADAPT | Ignores Reduce Motion, read from `accessibilityReduceMotion` |
| Content or a control clipped, overlapped or unreachable at 320px width or 200% zoom | ADAPT | At the largest accessibility text size the app supports, at the narrowest supported width or with the keyboard shown. iPhone SE-class devices still render 320pt wide under Display Zoom |
| Body or control text whose rendered contrast pair fails its required ratio | KEEP | Thresholds in points per **2.2**, pending open question 7, measured in both appearances |
| State or meaning carried by color alone | KEEP | |
| A destructive action with no confirmation, undo or distinct treatment | KEEP | `Button(role: .destructive)` is the distinct treatment |
| Truncated content with no way to reach the full value | KEEP | Apple's Larger Text criteria require the same |
| Content or a control past a scroll edge or behind a disclosure with no cue | KEEP | |
| An error that names no way to recover | KEEP | |
| A semantic color used against its meaning | KEEP | |
| A state change carried by motion alone | ADAPT | Carried by motion or haptics alone |
| (new) | ADD | Body or control text that does not scale with Dynamic Type |
| (new) | ADD | A custom modal that leaves the content behind it reachable by VoiceOver |
| (new) | ADD | A control outside the safe area, under the home indicator, status bar or Dynamic Island |

That makes 16 triggers, one of them conditional on keyboard support, against a 15-finding cap. The cap rule already says triggers outrank everything and the excluded count is reported, so it still holds.

### 2.2 Apple's numbers that replace web numbers

| Value | Web skills | Apple | Source |
| --- | --- | --- | --- |
| Target size | WCAG 24×24 CSS px as the finding; 44px touch and 40px desktop as heuristics | 44×44pt default, 28×28pt minimum | HIG Accessibility |
| Clearance between controls | `12px` bordered, `24px` borderless | About 12pt with a bezel, about 24pt without. Identical | HIG Accessibility |
| Contrast, large-text threshold | 3:1 at `24px`, or `18.67px` bold | Up to 17pt 4.5:1; 18pt and up 3:1; bold at any size 3:1 | HIG Accessibility |
| Default body size | `16px` | 17pt | HIG Accessibility |
| Smallest text | `12px`, "rarely" | 11pt | HIG Accessibility |
| Text resize | 200% browser zoom and `rem` | 200% or the system maximum, across the accessibility sizes. Back buttons and tab bars are exempt | App Store Connect, Larger Text criteria |
| Narrowest layout | `320px` | 375pt on SE and mini models; 320pt on SE-class devices under Display Zoom | Device metrics |
| Reduced motion | Replace slides and scales with cross-fades | The same, plus tighten springs, avoid animating depth and avoid animating into and out of blurs | HIG Accessibility |

The HIG's "bold at any size" row is looser than WCAG, which needs bold text at 14pt or more. A light-mode `systemBlue` of `#007AFF` measures about 4.0:1 against white. That fails WCAG's 4.5:1 for a 17pt regular label and passes the HIG's 3:1 for a bold one. Which table the skills report against is an open question.

### 2.3 Missing iOS concerns

| Concern | Today | Proposed owner | Key APIs (min iOS) |
| --- | --- | --- | --- |
| Dynamic Type | Only `rem` and browser zoom | `better-typography` for the text styles, `relativeTo:` and `@ScaledMetric`. `better-accessibility` for the requirement and the Large Content Viewer. `better-layout` for switching stacks at accessibility sizes | Text styles, `Font.custom(_:size:relativeTo:)`, `@ScaledMetric`, `.dynamicTypeSize(_:)` (15), `.accessibilityShowsLargeContentViewer()` (15), `dynamicTypeSize.isAccessibilitySize` with `AnyLayout` (16) |
| VoiceOver structure | DOM tree, ARIA roles and landmarks | `better-accessibility` | `.accessibilityElement(children:)`, `.accessibilityAddTraits`, `.accessibilitySortPriority`, `.accessibilityAction`, `.accessibilityAdjustableAction`, `.accessibilityRepresentation` (15), `.accessibilityRotor`, `@AccessibilityFocusState` (15) |
| Voice Control, Switch Control, Full Keyboard Access | Absent | `better-accessibility` | `.accessibilityInputLabels`, `.focusable(_:interactions:)` (17), `.keyboardShortcut` |
| Display accommodations | `prefers-contrast` and forced-colors only | `better-accessibility` owns the requirement, `better-colors` the variants and `better-typography` Bold Text | `colorSchemeContrast`, `legibilityWeight`, `accessibilityReduceTransparency`, `accessibilityDifferentiateWithoutColor`, `.accessibilityIgnoresInvertColors()` for photos and video, `accessibilityDimFlashingLights` (17) |
| Safe areas and keyboard avoidance | `env(safe-area-inset-*)` | `better-layout` | `.safeAreaInset(edge:)` (15), `.ignoresSafeArea()` on backgrounds only, `.safeAreaPadding` (17), `.scrollDismissesKeyboard` (16) |
| Size classes and multitasking | Media and container queries | `better-layout` | `horizontalSizeClass`, `ViewThatFits` (16), `AnyLayout` (16), `onGeometryChange` (16), `NavigationSplitView` (16) |
| SF Symbols | Generic SVG icon rules | `better-ui` | Weights and scales from `.font`, `.symbolVariant` (15), `.symbolRenderingMode` (15), `.symbolEffect` (17), `.contentTransition(.symbolEffect(.replace))` (17), `.forward` and `.backward` names that mirror in RTL |
| Materials and Liquid Glass | Absent | `better-ui` for surfaces, `better-colors` for vibrancy and contrast on them | `.ultraThinMaterial` and siblings (15), `.glassEffect(_:in:)` (26), `GlassEffectContainer` (26), `.buttonStyle(.glass)` (26). HIG: no Liquid Glass in the content layer |
| Haptics | Absent | `better-ui` for when, `better-accessibility` for never being the only channel | `.sensoryFeedback(_:trigger:)` (17). HIG: use system patterns only for their documented meaning |
| Dark mode | CSS media query or `.dark` class | `better-colors` | Asset-catalog appearances, system semantic colors, base and elevated backgrounds, `.preferredColorScheme` for an in-app override |
| Display P3 | `@media (color-gamut: p3)` | `better-colors` | Asset-catalog color sets in Display P3, `Color(.displayP3, red:green:blue:)` |
| `#Preview` for state testing | Absent | `state-machine` and `break` | `#Preview` with traits (17), `@Previewable` (17), `PreviewModifier` (18), Xcode canvas variants |
| System components first | Only "native element over `<div>`" | `better-interface`'s **Use the platform** rung, each domain applying it | `NavigationStack`, `TabView`, `.toolbar`, `List`, `Form`, `.sheet`, `.confirmationDialog`, `.searchable`, `.swipeActions`, `.contextMenu`, `.refreshable` |
| Localization tooling | ICU strings and `Intl` | `better-writing`, with `better-layout` for growth | String Catalogs (`.xcstrings`), plural variants, `^[…](inflect: true)`, `FormatStyle` (15), the Xcode pseudolanguages |
| iOS-only copy surfaces | Absent | `better-writing` | Permission purpose strings in `InfoPlist.xcstrings`, notification text, VoiceOver labels and hints, App Shortcut phrases |
| Automated checks | axe-style audits in a browser | `better-interface` verification | `performAccessibilityAudit()` in UI tests (17), Accessibility Inspector, snapshot tests, `ImageRenderer` (16) |
| App Store accessibility claims | Absent | `better-accessibility` calibration | Accessibility Nutrition Label criteria: VoiceOver, Voice Control, Larger Text, Sufficient Contrast, Dark Interface, Differentiate Without Color Alone, Reduced Motion, Captions and Audio Descriptions |
| iPad pointer | `@media (hover: hover)` | `better-ui` | `.hoverEffect` (13.4), `.onHover` |

### 2.4 Descriptions and triggers

Two separate problems.

**Collision.** A user with the upstream web plugin and this fork installed, or one fork in a repository with a web app and an iOS app, sees two `better-typography` skills with near-identical descriptions. Plugin namespacing separates `/interfaces:better-typography` from `/<fork>:better-typography` for manual invocation, but model invocation chooses by description. Nothing tells it which one fits a `.swift` file. Every description should name the platform, such as "in SwiftUI apps". Per `AGENTS.md` the README line must match each description word for word, so the README changes with it.

**Web cues that misfire or fail to fire.**

| Skill | Web cue in the description | Effect in a Swift project | Proposed wording |
| --- | --- | --- | --- |
| `better-accessibility` | "keyboard and focus behavior, ARIA … zoom … against WCAG 2.2" | Weak match for "add VoiceOver labels" or "support Dynamic Type". Primes ARIA vocabulary | "Reviews and fixes VoiceOver, Voice Control, Dynamic Type, focus, forms and Reduce Motion support in SwiftUI views, against Apple's accessibility criteria and WCAG 2.2." |
| `better-typography` | "type scale and spacing … font features" | Fires correctly but primes `px` scales. No mention of Dynamic Type, the most common iOS type request | "Sets and reviews how text renders in SwiftUI apps, from Dynamic Type text styles and custom fonts to weights, numerals, truncation and punctuation." |
| `better-layout` | "responsive structure … resized" | "Responsive" is a web term; size classes and safe areas never appear | "Helps with grouping, alignment, safe areas, size classes and room for translated text in SwiftUI, so a layout holds up across devices, text sizes, languages and RTL." |
| `better-ui` | "border radius … shadows … animation" | Fires on "add a shadow" and answers with `box-shadow` recipes | "Polishes SwiftUI surfaces, SF Symbols, motion and haptics with exact values for corner radius, materials, symbol states and springs." |
| `better-colors` | None web-specific | Fine, though asset catalogs and dark mode are what iOS users ask about | Add "asset catalogs" and "dark mode" |
| `better-writing`, `better-interface` | None | Fine | Add the platform only for the collision |
| `build-design` | None | Fine | Add "into SwiftUI" for the collision |
| `break` | "on a temporary page" | User-invoked, so no misfire, but the slash menu promises a web page | "Renders a SwiftUI view you choose in previews under every scenario that can reach it and reports what breaks." |
| `state-machine` | "on a throwaway page … with a switcher" | Same | "Builds a preview for every state of a SwiftUI view you choose, with mock data, so you can work on each state." |
| `explain-interface` | "a website … from a live URL" | Accurate, which is the problem | Drop, or keep upstream's unchanged |

The `agents/openai.yaml` short descriptions repeat the cues. `better-accessibility` says "ARIA", `explain-interface` says "From a URL" and `state-machine` says "on a throwaway page".

### 2.5 Workflows that do not translate

| Step | Web workflow | SwiftUI workflow | Constraint |
| --- | --- | --- | --- |
| Harness | Scratch route in the app, `"use client"` in Next | A `#Preview` file beside the view, importing the real view | Previews compile into the app target, so fixtures must stay DEBUG-only |
| Selecting a variant or state | `?__variant=` or `?__state=` search param, a fixed picker | One named `#Preview` per variant or state; the canvas lists them. For the real app context, a launch argument or `@AppStorage` key plus a DEBUG-only overlay | A launch argument lives in the `.xcscheme`, which leaks into commits when the scheme is shared |
| Viewing modes | Never simulated; named for the user to toggle | `colorScheme`, `dynamicTypeSize`, `layoutDirection`, `locale` and `legibilityWeight` are settable in the environment and render faithfully. Increase Contrast, Reduce Motion, Reduce Transparency and Differentiate Without Color are read-only, so name them for the user to toggle in Xcode canvas or Environment Overrides | Settable list checked against Apple's declarations |
| Looking once | Load in a browser already at hand | Xcode canvas, or the Simulator plus `xcrun simctl io booted screenshot` | macOS only. An agent can read PNGs from snapshot tests, or from `ImageRenderer` in a unit test, which does not render UIKit-backed views such as `List` and `TextField` faithfully |
| Motion replay | Browser Animations panel at 10% | Simulator **Debug > Slow Animations** | macOS only |
| Accessibility tree | DevTools accessibility pane, axe | Accessibility Inspector, VoiceOver on device, `performAccessibilityAudit()` in a UI test (17) | macOS and Xcode 15 or later |
| Removing the harness | Delete the route on the user's word | Delete the preview file and any DEBUG fixtures. Many teams keep state previews permanently | Open question 10 |
| Reading someone else's interface | DOM, computed styles, `getAnimations()`, fetched CSS | Nothing equivalent. The View Debugger attaches only to debuggable builds you run | Screenshots and screen recordings are the only evidence |

## 3. Per-skill audit

### `better-accessibility` · Rewrite · L

About a third of the text survives. The two-walk method, the redundant-cue rule, the alt-text table, the timer rules, the reduced-motion table and the contrast hand-off all hold. Every mechanism is DOM, and the iOS centerpieces are missing.

| Rule | Class | SwiftUI equivalent or note | Min iOS |
| --- | --- | --- | --- |
| Opener: keyboard walk, then screen-reader walk | ADAPT | A VoiceOver walk: swipe through every element and check label, trait, value, hint and order. A Voice Control walk with "Show names". A Larger Text walk at the largest accessibility size. A Full Keyboard Access walk only where iPad keyboard support is claimed | |
| **Criteria, not conventions** | ADAPT | WCAG applies to native apps through WCAG2ICT and EN 301 549, but 2.4.1 bypass blocks, 2.4.2 page titles and the 1.4.10 reflow wording are web-shaped. Apple's Accessibility Nutrition Label criteria are the platform anchor. The 44pt and 28pt targets come from the HIG | |
| **Native elements first** | ADAPT | `Button`, not `.onTapGesture` on a view, which is the `<div onClick>` of SwiftUI. `Link` or `openURL` for URLs, `NavigationLink` or `navigationDestination` for navigation and `Toggle`, `Picker`, `Stepper`, `Slider` and `Menu` over custom builds. Cmd and middle-click DROP | |
| **Disabled means unavailable** | ADAPT | `.disabled(true)`. VoiceOver reads it as "dimmed" and keeps it in the swipe order, so the `aria-disabled` workaround for discoverability is unnecessary and DROP. Explain why in visible text or `.accessibilityHint` | |
| **Visible focus rings** | DROP / ADAPT | `:focus-visible`, outline and forced-colors DROP. On touch-only iPhone flows there is no ring. With iPad keyboard support, never `.focusEffectDisabled()` without a visible replacement driven by `@FocusState` | 17 |
| Focus not obscured (2.4.11) | ADAPT | Build sticky chrome with `.safeAreaInset(edge:)` rather than a `ZStack` overlay, so scroll content and VoiceOver frames inset. Never `.ignoresSafeArea(.keyboard)` on a container holding fields | 15 |
| **Full keyboard support** | ADAPT | APG key maps DROP on iPhone. On iPad, `.keyboardShortcut`, `.onKeyPress` (17) and `.focusable(_:interactions:)` (17). Escape maps through `.keyboardShortcut(.cancelAction)`. The VoiceOver form of an arrow-key composite widget is `.accessibilityAdjustableAction` | 17 for key handling |
| `tabindex`, roving tabindex, `aria-activedescendant` | DROP | The native concern is reading order and grouping: `.accessibilityElement(children: .combine)` or `.contain` and `.accessibilitySortPriority` as a last resort | |
| **Trap and restore focus** | ADAPT / CONFLICT | `.sheet`, `.fullScreenCover`, `.alert`, `.confirmationDialog` and `.popover` make the background inaccessible to VoiceOver and support the two-finger escape scrub. A hand-rolled `ZStack` modal is CONFLICT; if one must exist it needs `.accessibilityAddTraits(.isModal)`, `.accessibilityAction(.escape)` and `@AccessibilityFocusState` to move and restore focus | 15 for focus state |
| Route changes: `document.title`, focus the `<h1>` | ADAPT | `NavigationStack` handles focus and announcement. `.navigationTitle` is the title. A content swap without navigation posts `AccessibilityNotification.ScreenChanged` | 17 |
| **Minimum hit area** | ADAPT | HIG 44×44pt default and 28×28pt minimum replace 24px, 44px and 40px. Extend with `.contentShape(Rectangle())` plus `.frame(minWidth: 44, minHeight: 44)`, never a pseudo-element | |
| Overlapping hit areas, `pointer-events: none` on decoration | ADAPT | `.allowsHitTesting(false)` on decorative overlays, with `.accessibilityHidden(true)` | |
| Drag needs a single-pointer alternative (2.5.7) | KEEP | `.swipeActions` (15) surface as VoiceOver actions on their own; a custom `DragGesture` does not. Add `.accessibilityAction(named:)` or a menu. List reordering through `EditButton` and `.onMove` already has the alternative | 15 |
| `touch-action: none` | DROP | Gesture priority is `.simultaneousGesture` and `.highPriorityGesture` | |
| **Label and type every control**: a placeholder is never a label | CONFLICT (partial) | `TextField("Email", text:)` uses its title as both placeholder and VoiceOver label, and iOS `Form` fields and system apps use placeholder-only fields routinely. The VoiceOver label persists, so it is not an accessibility failure. Where a filled value becomes ambiguous to sighted users, use `LabeledContent` (16) or a visible label | 16 |
| Label and control share one hit target | KEEP | `Toggle("Send updates", isOn:)` gives it. Custom checkbox rows make the whole row one `Button` | |
| `autocomplete`, `type`, `inputmode`, `spellcheck` | ADAPT | `.textContentType(.emailAddress, .username, .password, .newPassword, .oneTimeCode)`, `.keyboardType(.emailAddress, .numberPad, .decimalPad)`, `.textInputAutocapitalization(.never)` (15), `.autocorrectionDisabled()`, `SecureField`. `name` attribute and `<form>` DROP. Password AutoFill needs the `webcredentials:` associated domain | 15 |
| Never block paste | KEEP | Never filter input in `.onChange` in a way that rejects pasted values | |
| **Errors that announce**: never disable submit to gate validation | CONFLICT (partial) | System apps keep the toolbar **Done**, **Add** or **Join** disabled until required fields hold a value, as in Contacts, Calendar and Wi-Fi join. Allow that when the missing requirement is visibly obvious; otherwise validate on submit | |
| Mark failing fields, link the error, focus the first | ADAPT | Error `Text` beside the field and carried in its `.accessibilityValue` or hint. `@FocusState` (15) and `@AccessibilityFocusState` (15) move to the first invalid field. Form-level failures post `AccessibilityNotification.Announcement` (17) | 15 / 17 |
| **Accessible names everywhere** | ADAPT | `Label("Delete", systemImage: "trash").labelStyle(.iconOnly)` keeps the name; `.accessibilityLabel` otherwise. Decorative content takes `Image(decorative:)` or `.accessibilityHidden(true)`, never on an ancestor of a control | |
| Label in Name (2.5.3) | ADAPT | Voice Control: `.accessibilityInputLabels(["Send", "Submit"])` with the visible text first | |
| **Don't rely on color alone** | KEEP | Thresholds move to points per **2.2**, pending open question 7. `accessibilityDifferentiateWithoutColor` is an extra mode, never a substitute for the cue | |
| **Honor prefers-reduced-motion** | ADAPT | `@Environment(\.accessibilityReduceMotion)`. System pushes and sheets adapt on their own; custom `withAnimation`, `.animation` and `.transition` do not. Use `.transition(.opacity)` under it, per HIG avoid blur in and out and tighten springs. Autoplay checks `accessibilityPlayAnimatedImages` and `accessibilityDimFlashingLights` | 17 for the last two |
| **Nothing the user needs runs on a timer** | KEEP | iOS has no system toast, so custom banners carrying an action stay until dismissed | |
| **Announce dynamic content** | ADAPT | `AccessibilityNotification.Announcement` (17), or `UIAccessibility.post(notification: .announcement, argument:)` below 17. Announcement priority (17) is the polite and assertive split. `.updatesFrequently` trait for timers. "Render the empty region first" DROP | 17 |
| **Alt text by purpose** | KEEP | Table holds. `Image(decorative:)`, `Image(_:label:)`, `.accessibilityLabel`; functional images are button labels | |
| **Structure is navigation** | ADAPT / DROP | Headings: `.accessibilityAddTraits(.isHeader)` and `.accessibilityHeading(.h2)` (15) for the rotor. `<main>`, landmarks, skip link and `scroll-margin-top` DROP; the rotor replaces them | 15 |
| **Survive zoom and text resize** | ADAPT | Becomes Dynamic Type through AX5, per Larger Text: 200% or the maximum. Bars that cannot grow use `.accessibilityShowsLargeContentViewer()` (15). Cap with `.dynamicTypeSize(...)` only where layout truly cannot grow. Viewport meta and the iOS Safari input-zoom note DROP | 15 |
| `## Reporting` | ADAPT | Triggers per **2.1**. Verification: VoiceOver walk on device, Accessibility Inspector audit, `performAccessibilityAudit()` (17) and Environment Overrides. Without macOS, everything rendered is `Not verified` | 17 |

**Reference files**

| File | Class | Notes |
| --- | --- | --- |
| `focus-and-keyboard.md` | DROP | Replace with a VoiceOver file: reading order, grouping, custom actions, adjustable controls, rotors, modality, `@AccessibilityFocusState` and iPad keyboard focus |
| `forms.md` | ADAPT | About 40% survives: the error pattern, trim before validating and unsaved-changes warnings, which map to `.interactiveDismissDisabled()` (15) plus a confirmation. The `autocomplete` and `inputmode` tables become `textContentType` and `keyboardType` tables |
| `hit-areas.md` | ADAPT | Target table gains HIG rows and drops Material. CSS and Tailwind recipes become `.contentShape`. Collision and gesture rules KEEP |
| `motion-and-zoom.md` | ADAPT | The disable, replace and keep table KEEP; it matches the HIG. Autoplay KEEP. Zoom and reflow rewritten as Dynamic Type |
| `screen-readers.md` | ADAPT | `.sr-only` and SVG DROP. The "choose how to announce" ladder KEEP with announcement APIs. Alt-text table and captions KEEP; AVKit provides captions and controls |
| `semantics-and-aria.md` | Rewrite | The rules of ARIA become the rules of accessibility modifiers: native control first, do not override traits and a custom control needs label, trait, value and actions, ideally through `.accessibilityRepresentation`. Button and link table becomes `Button`, `Link`, `NavigationLink` and `.onTapGesture` |

**`## Before you finish`.** All 14 rows are CSS or JSX and DROP. Proposed replacements:

| Detection pattern | Fix |
| --- | --- |
| `.onTapGesture` on a view acting as a button | `Button`, which brings the trait, highlight and Voice Control name |
| `Image(systemName:)` alone in a `Button` label with no label | `Label(_:systemImage:)` with `.labelStyle(.iconOnly)` |
| A `ZStack` overlay used as a modal | `.sheet` or `.fullScreenCover`, or add `.isModal` and an escape action |
| A `DragGesture` or custom swipe with no `.accessibilityAction` | Add a named action or menu |
| `.accessibilityHidden(true)` on a container holding controls | Remove it |
| `.font(.system(size:))` on body or control text | A text style, or `relativeTo:` |
| `.dynamicTypeSize(...)` capping a whole screen | Cap only the bar and add the Large Content Viewer |
| `withAnimation`, `.animation` or a move or scale `.transition` with no Reduce Motion branch | Branch to `.opacity` |
| `.focusEffectDisabled()` with no replacement | Remove it, or draw focus from `@FocusState` |
| `.accessibilityLabel` that omits the visible text | Start with the visible text |
| An announcement posted on every keystroke | Debounce, or use the field's value |

**Missing.** Bold Text for custom fonts, Smart Invert on media, Assistive Access, captions and audio descriptions as nutrition-label claims and the automated audit as a verification step.

### `better-typography` · Rewrite · L

About a quarter survives: fewer fonts and weights, descending headings, tabular figures, truncation with a way back, natural case with typographic punctuation and the bidi rules. The rest is CSS mechanics, and several of its exact values make a SwiftUI app look non-native.

| Rule | Class | SwiftUI equivalent or note | Min iOS |
| --- | --- | --- | --- |
| **Measured, not preferred**: unitless line-height, weight at least `400` under `18px`, 60–75 measure, `16px` inputs, `tabular-nums` | ADAPT | New exact list: text styles or `relativeTo:` on all text, scaling through the accessibility sizes, no light weights below about 17pt, `.monospacedDigit()` on changing values and 11pt as the floor. The `16px` input rule and unitless line-height DROP | |
| **Fewer fonts, sizes and weights** | KEEP | HIG: thin custom faces need larger sizes. Custom fonts must respond to Bold Text through `legibilityWeight`; San Francisco does on its own | |
| **Load the faces the design uses** | ADAPT | Register every face in `UIAppFonts` and reference it by PostScript name. A misspelled or unbundled face falls back to San Francisco silently, with no error. CSS synthesis longhands DROP | |
| **Properties over raw tags** | ADAPT | `.fontWeight`, `.fontWidth` (16), `.fontDesign` (16.1), `.monospacedDigit()`, `Font.smallCaps()`. San Francisco switches optical sizes on its own. Stylistic sets need a `UIFontDescriptor` with feature settings, wrapped in `UIFontMetrics` or Dynamic Type breaks | 16 |
| **Use a type scale with semantic names** | CONFLICT | Dynamic Type text styles are the scale: `.largeTitle` 34, `.title` 28, `.title2` 22, `.title3` 20, `.headline` 17 semibold, `.body` 17, `.callout` 16, `.subheadline` 15, `.footnote` 13, `.caption` 12, `.caption2` 11, at the default size. A custom `rem` scale bypasses Dynamic Type. Brand fonts map onto the styles with `Font.custom(_:size:relativeTo:)`, and roles live in `extension Font` | |
| **Heading sizes descend with level** | KEEP | `.title2`, then `.title3`, then `.headline`. The semantic level is `better-accessibility`'s `.accessibilityHeading` | |
| **Line-height by role** | CONFLICT | Text styles carry tuned leading; body is 17 on 22, about 1.29. Forcing `1.5` through `.lineSpacing` looks non-native in UI. Use `Font.leading(.loose)` or `.tight`, and `.lineSpacing` only for long-form reading. "Three or more lines never tight" KEEP | |
| **Letter-spacing by size** | CONFLICT | San Francisco applies size-specific tracking automatically, so `-0.01em` to `-0.02em` on headings double-tightens. `.tracking` stays for custom fonts and uppercase labels | 16 on views |
| Kerning is never a fix | KEEP | Never `.kerning(0)` | |
| **Cap the measure** | ADAPT | Irrelevant on iPhone in portrait. On iPad and landscape, `.frame(maxWidth:)` with a `@ScaledMetric` width so the cap grows with text size. Inset-grouped lists already use readable margins | |
| **Wrap deliberately** | DROP / ADAPT | `balance` and `pretty` have no SwiftUI equivalent and DROP. `nowrap` becomes `.lineLimit(1)` with `.fixedSize()`. `Text` breaks an unbreakable string on its own. Start alignment KEEP | |
| **Tabular numbers on changing values** | KEEP | `.monospacedDigit()` (15) on the view or `Font.monospacedDigit()`. Add `.contentTransition(.numericText())` (16) for animated counters | 15 |
| **Truncate with a way back** | ADAPT | `.lineLimit(n)` with `.truncationMode(.tail)`, or `.middle` for file names and IDs. `.minimumScaleFactor` is not a substitute and makes text unreadable at large sizes | |
| **Natural case, typographic punctuation** | KEEP / ADAPT | `.textCase(.uppercase)`. Curly quotes, en dashes and `…` in String Catalog values. `&nbsp;` becomes `\u{00A0}` | |
| **Underlines from the font** | DROP | No offset or thickness API. `.underline(pattern: .dot)` is the only remnant | |
| **Inputs at 16px on mobile** | DROP | Safari-only behaviour; native text fields never zoom. Its "exact" status in the calibration line must go with it | |
| **Size floors** | CONFLICT | `16px` body, `14px` inputs and `13px` captions with `rem` become text styles: 17pt body and an 11pt floor per the HIG. Non-text dimensions that track text use `@ScaledMetric` | |
| **Font smoothing on the root** | DROP | | |
| **Language and bidi behavior** | ADAPT | The app's localizations and `.environment(\.locale)`. `.typesettingLanguage(_:)` (17) keeps tall scripts such as Thai from clipping in mixed content. `<bdi>` becomes Unicode isolates, `\u{2068}` and `\u{2069}`, around interpolated user values | 17 |
| **Trim text boxes in tight containers** | DROP | Align by `.firstTextBaseline` or `.lastTextBaseline` instead; system buttons already center their labels | |
| **Decorative text in CSS, not images** | ADAPT | `.foregroundStyle` with a gradient, `.shadow` or `TextRenderer`, keeping the text a `Text` so it scales and reads in VoiceOver | |
| **Keep useful text selectable** | CONFLICT | iOS UI text is not selectable and should not be. Invert the rule: opt content in with `.textSelection(.enabled)` (15) for messages, codes, addresses and error IDs, or offer **Copy** in a `.contextMenu`. `user-select` DROP | 15 |
| `## Reporting` | ADAPT | "Clips at 320px or 200% zoom" becomes accessibility sizes. Verification uses Dynamic Type preview variants, Environment Overrides and Accessibility Inspector's text-size control | |

**Reference files**

| File | Class | Notes |
| --- | --- | --- |
| `choosing-fonts.md` | ADAPT | Category and anatomy tables KEEP. The `system-ui` stack becomes `.font(.body)`, with `.fontDesign(.serif)`, `.rounded` and `.monospaced` for New York, SF Rounded and SF Mono. The `woff2` table DROP for bundled `.otf` or `.ttf`. Display and Text cuts are automatic for San Francisco and KEEP only for custom families |
| `css-cheat-sheet.md` | DROP | Replace with a SwiftUI modifier cheat sheet |
| `details-and-accessibility.md` | DROP | Underlines, `::selection`, `::placeholder`, the input-zoom recipe and CSS decorative text. One remnant: `.tint` colors the caret and selection |
| `spacing-and-sizing.md` | Rewrite | Units become points and Dynamic Type. The scale becomes the text-style table above. `text-box` DROP |
| `variable-fonts-and-opentype.md` | DROP (mostly) | Keep a short note on static versus variable custom fonts and on reaching OpenType features through Core Text |
| `wrapping-and-punctuation.md` | ADAPT | Measure note moves to iPad. Punctuation table and internationalization KEEP. `&shy;` becomes `\u{00AD}` |

**`## Before you finish`.** All 19 rows are CSS and DROP. Proposed replacements:

| Detection pattern | Fix |
| --- | --- |
| `.font(.system(size:))` or `Font.custom(_, size:)` without `relativeTo:` | A text style, or add `relativeTo:` |
| `.fontWeight(.light)`, `.thin` or `.ultraLight` under about 17pt | `.regular` or heavier |
| `.lineSpacing` on UI labels to reach about 1.5 | Remove it, or `Font.leading(.loose)` for long-form text |
| `.tracking` or `.kerning` on San Francisco | Remove it |
| A timer, counter, price or numeric column without `.monospacedDigit()` | Add it |
| `.minimumScaleFactor` below about `0.8` on body text | Wrap or truncate with a way back |
| `.lineLimit(1)` on user or localized content | Allow wrapping, or add a way back |
| `.dynamicTypeSize` capped on body content | Remove it |
| `...` or `--` in String Catalog values | `…` or an en dash |
| `Font.custom` naming a face that is not in `UIAppFonts` | Register it |
| `.textSelection(.enabled)` across a screen of UI labels | Content only |

### `better-ui` · Rewrite · L

Under a third survives as written. The keepers are concentric radius, optical alignment, no motion on frequent interactions, bounce `0`, short exits, every state change leaving a static cue and the infrequent-icon table. Several rules duplicate feedback the system already gives.

| Rule | Class | SwiftUI equivalent or note | Min iOS |
| --- | --- | --- | --- |
| **Exact values, optional polish** | KEEP | Values re-expressed: `cubic-bezier(0.2, 0, 0, 1)` is `Animation.timingCurve(0.2, 0, 0, 1, duration:)` | |
| **Outer radius equals inner radius plus padding** | ADAPT | iOS 26 computes it: `ConcentricRectangle`, or `.rect(cornerRadius: .containerConcentric)` under `.containerShape`, including the device corner for edge-adjacent views. Below 26, the manual formula. `RoundedRectangle` already defaults to continuous corners | 26 |
| **Align optically where geometry looks off** | KEEP | `Label` aligns symbols to text; nudge custom assets with `.alignmentGuide` or `.offset`, mirroring where direction matters | |
| **Shadows for elevation, borders for structure** | CONFLICT | iOS signals elevation with system backgrounds, base and elevated in dark mode, grouped backgrounds, materials and, in iOS 26, Liquid Glass for the control layer. Three-layer shadow rings on cards read as web. Keep a subtle `.shadow` for genuinely floating custom elements. The forced-colors transparent border DROP | |
| **Outline images in pure black or white** | ADAPT | `.overlay { shape.strokeBorder(Color.primary.opacity(0.1), lineWidth: 1 / displayScale) }`. `Color.primary` flips by appearance, so one value covers both | |
| **Transitions, not keyframes, for interactive state** | KEEP | SwiftUI state animations and springs retarget and keep velocity by default. Reserve `keyframeAnimator` and `phaseAnimator` (17) for one-shot sequences | 17 |
| **Press scales to 0.96** | CONFLICT | `.bordered`, `.borderedProminent`, `.plain`, list-row highlighting and iOS 26 `.glass` buttons already respond to touch, so a scale on top doubles the feedback. Only a fully custom `ButtonStyle` gets it: `configuration.isPressed ? 0.96 : 1` with `.easeOut(duration: 0.15)`, and none when `isEnabled` is false. The `static` prop pattern becomes a style choice | 26 for `.glass` |
| **High-frequency interactions get no animation** | KEEP | HIG says the same | |
| **Gate motion behind the reduced-motion preference** | ADAPT | `accessibilityReduceMotion`, with `.transition(.opacity)` under it; HIG adds no blurs and tighter springs | |
| **Stagger infrequent entrances by 100ms** | ADAPT / CONFLICT | For onboarding, success and empty states: `.transition(.opacity.combined(with: .offset(y: 12)))` or `.blurReplace` (17) with `.delay(Double(index) * 0.1)`. Staging an entrance on a screen that arrives through a navigation push fights the system transition, and that is CONFLICT | 17 |
| **Exits are shorter and smaller than enters** | KEEP | `.transition(.asymmetric(insertion:removal:))` | |
| **Skip state animations on first render** | DROP | SwiftUI animates changes, not the initial state, so `initial={false}` has no counterpart. The real mistake is the inverse: `onAppear { withAnimation { … } }` | |
| **Cross-fade contextual icons with exact values** | ADAPT | SF Symbols have it built in: `.contentTransition(.symbolEffect(.replace))` (17). Keep the scale `0.25`, blur `4` recipe only for non-symbol images, with `.spring(duration: 0.3, bounce: 0)` | 17 |
| **Suppress transitions on theme switch** | DROP | SwiftUI does not animate an appearance change. If an in-app toggle sits inside an animation, `Transaction.disablesAnimations` | |
| **Transition only what changes** | ADAPT | Scope animation to a value with `.animation(_:value:)`, or to specific modifiers with `.animation(_:body:)` (17). `.animation(_:)` without a value has been deprecated since iOS 15 and is the `transition: all` of SwiftUI | 17 |
| **Name the animated property in will-change** | DROP | The nearest concern is `.drawingGroup()` and `.compositingGroup()`, added only after Instruments shows hitches | |
| **Hover effects only on hover-capable pointers** | ADAPT | `.onHover` fires only with a pointer, so the latching problem does not exist. iPad pointer uses `.hoverEffect(.highlight)` or `.lift` (13.4). Tap highlight DROP | 13.4 |
| **Contain scroll inside overlays** | ADAPT | Sheets contain scroll. In a detented sheet, `.presentationContentInteraction(.scrolls)` (16.4) prefers scrolling over resizing. `.scrollBounceBehavior(.basedOnSize)` (16.4) stops short content bouncing | 16.4 |
| **Match icon stroke to text weight** | CONFLICT | SF Symbols take the weight and scale of adjacent text from `.font` and `.fontWeight`, in nine weights and three scales. Hand-set stroke widths are non-native. Custom icons become custom symbols exported from the SF Symbols app. One library per surface KEEP, with SF Symbols first | |
| **One SVG, recolored per state** | ADAPT | Template rendering with `.foregroundStyle` and `.tint`, plus `.symbolRenderingMode(.hierarchical)` or `.palette` (15). Disabled system controls dim on their own | 15 |
| Outline default, fill active | CONFLICT (tab bars) | Matches the HIG for toolbars and selection states. In a `TabView` the system applies `.fill` to every tab icon and shows selection with tint, so switching variants by state fights it | |
| Icons in RTL | ADAPT | Use `chevron.forward` and `arrow.backward`, which mirror on their own. Custom assets set **Direction** to mirror in the asset catalog, or `.flipsForRightToLeftLayoutDirection(true)` | |
| `## Reporting` | ADAPT | "A keyframe toggle that cannot reverse" and "a hover stuck on touch" cannot happen in SwiftUI and DROP. Verification replays motion with Simulator **Slow Animations** | |

**Reference files**

| File | Class | Notes |
| --- | --- | --- |
| `surfaces.md` | ADAPT | Concentric and optical sections KEEP with SwiftUI code. Shadow recipes rewritten around materials and system backgrounds. Image outline ADAPT |
| `icons.md` | Rewrite | Around SF Symbols: weights, scales, variants, rendering modes, localized variants and custom symbols |
| `animations.md` | ADAPT | Interruptibility and high-frequency sections KEEP. Press scale becomes a custom `ButtonStyle` recipe. Page-load and theme-switch sections DROP. Reduced-motion fallback ADAPT |
| `enter-exit.md` | ADAPT | Values carry over as transitions. `@starting-style` DROP |
| `icon-transitions.md` | Rewrite | "Check `package.json` for Motion" DROP. Lead with symbol effects. The "which icons animate" table KEEP |
| `performance.md` | DROP | Replace with three lines on scoped animation and measuring before `.drawingGroup()` |

**`## Before you finish`.** All 15 rows are CSS or Tailwind and DROP. Proposed replacements:

| Detection pattern | Fix |
| --- | --- |
| `.scaleEffect` tied to press on a `Button` with a system style | Remove it |
| Stacked `.shadow` on cards inside a `List` or grouped background | System background or material |
| `.background(.ultraThinMaterial)` on a hand-built tab or navigation bar | System bar, which gets Liquid Glass on iOS 26 |
| `.glassEffect` in the content layer | Remove it; HIG reserves glass for controls and navigation |
| `.animation(.default)` with no `value:` | `.animation(_:value:)` |
| `.bouncy` or a spring with bounce above `0` in UI chrome | `bounce: 0` |
| A raster PNG used as a UI icon | An SF Symbol or a custom symbol |
| Nested `RoundedRectangle`s with the same radius | Concentric radius |
| `chevron.right` for navigation | `chevron.forward` |
| `.onTapGesture` with a hand-written press animation | `Button` with a `ButtonStyle` |
| `.drawingGroup()` with no measured hitch | Remove it |

**Missing.** Haptics, materials and Liquid Glass, symbol effects, zoom navigation transitions (`.navigationTransition(.zoom)`, 18), `.scrollTransition` (17), numeric text transitions, context menus with previews and system control sizes.

### `better-layout` · Adapt · M

The principles hold, and the HIG agrees with the clearance numbers word for word. About 45% survives. Logical properties shrink to a list of the few places SwiftUI does not mirror.

| Rule | Class | SwiftUI equivalent or note | Min iOS |
| --- | --- | --- | --- |
| **Group with space, not lines** | KEEP | `VStack(spacing:)`, `Section`, `Form`. Grouped lists use separators and grouped backgrounds by convention; never strip them with `.listRowSeparator(.hidden)` to satisfy the rule | |
| **Keep controls distinct from content** | ADAPT | Borderless iOS buttons rely on tint as their cue, which the platform accepts. Shapes come from `.buttonStyle(.bordered)` or `.borderedProminent` (15), and custom `ButtonStyle`s must honor the Button Shapes setting, which system styles do automatically | 15 |
| **Align to shared edges** | ADAPT | System margins rather than a hard-coded `16`: `.padding()`, `.scenePadding()` (15), `.safeAreaPadding` (17) and `.contentMargins` (17). Mixed rows align with `.firstTextBaseline` | 17 |
| **Logical properties for anything that mirrors** | ADAPT | SwiftUI is leading and trailing throughout, so the CSS table DROP. What does not mirror: `.offset(x:)`, `.position`, `GeometryReader` arithmetic, `Path`, `Canvas`, `.rotationEffect` and `.scaleEffect(x: -1)`. Progression mirroring KEEP | |
| **Order by importance**: visual order matches DOM order | ADAPT | VoiceOver reads the view hierarchy. `ZStack`s and overlays that reposition content visually reorder it; `.accessibilitySortPriority` is a last resort | |
| **One primary action per view** | KEEP | `ToolbarItem(placement: .confirmationAction)` or `.primaryAction`, one `.borderedProminent` and a `Menu` behind `ellipsis.circle` beyond three | |
| **Hint at hidden content** | ADAPT | Peek with `.contentMargins(.horizontal, 24, for: .scrollContent)`, `.scrollTargetBehavior(.viewAligned)` and `.containerRelativeFrame(.horizontal)` (all 17); the `calc()` recipe DROP. `DisclosureGroup`. `.scrollIndicatorsFlash(onAppear:)` (17). Hover tooltips do not exist on touch, so the way back is a detail view, an expand control or **Copy** | 17 |
| **Borderless controls need more clearance** | KEEP | 12pt and 24pt are the HIG's numbers. System toolbars space their own items | |
| **Inset buttons from the edges** | ADAPT | `.safeAreaInset(edge: .bottom)` (15) for an action bar, `.frame(maxWidth: .infinity)`, `.controlSize(.large)` (15). iOS 26 adds `.tabViewBottomAccessory` | 15 / 26 |
| **Content bleeds, controls float** | KEEP / ADAPT | This is iOS's safe-area model. `.ignoresSafeArea()` on backgrounds and media only. `viewport-fit`, `env()` and `scroll-padding` DROP. iOS 26 adds `.backgroundExtensionEffect()` for media under sidebars and glass | 26 |
| **Hold structure until it breaks** | ADAPT | Size classes are the coarse signal; content-driven switching is `ViewThatFits` (16) or `AnyLayout` (16), with `onGeometryChange` (16) in place of a screen-wide `GeometryReader`. `NavigationSplitView` collapses on its own. Test the narrowest width, the largest iPad window and AX5 | 16 |
| **Plan for growth and clipping** | KEEP | The Xcode scheme's Double-Length, Bounded String and Right-to-Left pseudolanguages replace manual pseudo-localization. No fixed `.frame(width:height:)` on text. `.lineLimit(2, reservesSpace: true)` (16). Keyboard: `.scrollDismissesKeyboard(.interactively)` (16) | 16 |

**Reference files**

| File | Class | Notes |
| --- | --- | --- |
| `grouping-and-alignment.md` | ADAPT | Principles and good-and-bad framing KEEP; every code block rewritten. The logical-properties table becomes the "where SwiftUI does not mirror" list |
| `spacing-and-adaptivity.md` | ADAPT | Clearance table KEEP. The peek `calc`, the physical safe-area FAB with an RTL override, `100dvh` and container queries DROP for the APIs above. Modal max-height becomes `.presentationDetents` (16) with actions outside the scroll |

**`## Before you finish`.** All 11 rows are CSS and DROP. Proposed replacements:

| Detection pattern | Fix |
| --- | --- |
| `UIScreen.main.bounds` used for sizing | Container size through `containerRelativeFrame` or `onGeometryChange`; screen bounds are wrong in Split View and Stage Manager |
| `GeometryReader` wrapping a whole screen | `onGeometryChange`, a `Layout` or stacks |
| `.frame(height:)` on a view holding text | `minHeight`, or let it grow |
| `.ignoresSafeArea()` on a container holding controls | Apply it to the background only |
| `.offset(x:)` or `.position` used for layout | Stacks and alignment, or mirror explicitly |
| `horizontalSizeClass` as a breakpoint inside a reusable component | `ViewThatFits` |
| An `HStack` of label and value with no accessibility-size fallback | `AnyLayout` switching to `VStack` at `isAccessibilitySize` |
| `.padding(.bottom, 34)` reserving the home indicator by hand | `.safeAreaInset(edge: .bottom)` |
| `.edgesIgnoringSafeArea` | `.ignoresSafeArea` |

**Missing.** Keyboard avoidance, orientation, Dynamic Island and the camera housing, multitasking and Stage Manager windows, `NavigationSplitView` column behavior and iOS 26 floating bars changing the effective safe area.

### `better-colors` · Adapt · M

The color science is the most portable content in the repository. Ramps, OKLCH lightness, roles, token tiers and contrast measurement survive, about 65% of the text. The change is where values live, plus one real stance shift: neutrals should usually be system semantic colors.

| Rule | Class | SwiftUI equivalent or note | Min iOS |
| --- | --- | --- | --- |
| Calibration: never report an unmeasured value; OKLCH `L` throughout | KEEP | OKLCH stays the design-time computation space; Swift has no OKLCH type | |
| **Match the project's color system** | ADAPT | iOS notation is asset-catalog color sets with sRGB or Display P3 components and appearance variants, `Color(.displayP3, red:green:blue:)` or `UIColor(dynamicProvider:)`. "`oklch()` for a new system" becomes "compute in OKLCH, store as P3 or sRGB components" | |
| **A system is ramps, not colors** | CONFLICT (partial) | Text, backgrounds, separators and fills should default to system semantic colors: `Color(.label)`, `.secondaryLabel`, `.systemBackground`, `.secondarySystemBackground`, `.systemGroupedBackground`, `.separator` and `.systemFill`, with `.primary`, `.secondary` and `.tertiary` styles. They adapt to dark mode, elevation, Increase Contrast and vibrancy. HIG: do not redefine their meaning. Custom ramps stay for accent and status | |
| **Every step has a job** | KEEP | Role table maps to semantic colors. Component hover DROP outside the iPad pointer | |
| **Name primitives by hue, semantics by role** | ADAPT | Asset-catalog folders with namespaces, generated `Color` symbols (Xcode 15) and `extension ShapeStyle where Self == Color`. Every color set gets a generated symbol, so the primitive tier is reachable from code and stays a convention | |
| `--color-primary` against `--color-text-primary` | ADAPT | Sharper on iOS: SwiftUI's `.primary` already means primary text. A brand color named `primary` collides in autocompletion. Name it `accent` or use `AccentColor` with `.tint` | |
| **Use a token only in its role** | KEEP | | |
| **Hold the hue across the ramp** | KEEP | | |
| **One color, one meaning** | KEEP | Tint means interactive on iOS, so non-interactive text in the tint color misleads | |
| **Fill exactly one action per view** | KEEP | One `.borderedProminent` | |
| **Measure the rendered pair, then report** | ADAPT | Measure in both appearances, with Increase Contrast and on materials. Read resolved values with `Color.resolve(in:)` (17). Tools: Accessibility Inspector and the contrast audit in `performAccessibilityAudit()` (17) | 17 |
| **Pick a gradient's interpolation space** | ADAPT | `Gradient.colorSpace(.perceptual)`, OKLab-like, is listed from iOS 16. There is no polar option; add a midpoint stop for the gray dead zone. `MeshGradient` (18) | 16 / 18 |

**Reference files**

| File | Class | Notes |
| --- | --- | --- |
| `color-formats.md` | ADAPT | Notation table rewritten for Swift and asset catalogs. "Do not bulk-convert" KEEP. Gamut moves to the asset catalog's Display P3 option. Every supported iPhone has a P3 display and the system color-matches on sRGB screens such as base iPads, so the CSS sRGB-first layering DROP while "do not let ramp steps clip" KEEP. `color-mix()` becomes `Color.mix(with:by:in:)` (18). `light-dark()` becomes appearance variants |
| `color-usage.md` | KEEP (mostly) | Meaning, roles, one colored action, gradients with SwiftUI syntax and cultural meaning KEEP. The light, dark and increased-contrast block becomes asset-catalog appearance plus High Contrast variants, which per appearance is exactly what its rule asks for. Add base and elevated backgrounds |
| `contrast.md` | KEEP | Thresholds add the HIG point table. "Translucent surfaces" grows into materials, vibrancy and Liquid Glass |
| `palette-generation.md` | KEEP | `culori` stays a design-time tool. The switching-mechanism section becomes asset catalog versus `.preferredColorScheme` |
| `palette-structure.md` | KEEP | Neutrals recommend `systemGray` through `systemGray6` first. The audit grep targets `.colorset/Contents.json`, `Color(red:`, `UIColor(red:`, `#colorLiteral(` and hex initializers |
| `token-naming.md` | ADAPT | Tiers, role inventory and grammar KEEP, in Swift's lower camel case. The Tailwind section DROP for an asset-catalog and generated-symbols section |

**`## Before you finish`.** Eleven of 17 rows are perceptual or naming rules and KEEP. The other six ADAPT: literals become `Color(red:green:blue:)` or hex initializers in views, `bg-blue-600` becomes `Color("Blue600")` in a view, two switching mechanisms becomes `colorScheme == .dark ?` ternaries beside asset variants, `prefers-contrast` becomes High Contrast variants, `text-white` on a `500` fill becomes white on `.blue` or the project accent and the out-of-gamut row becomes P3 components with no intent behind them.

**Missing.** Base and elevated backgrounds, vibrancy on materials, Reduce Transparency, Smart Invert on photos and `AccentColor` with `.tint`.

### `better-interface` · Adapt · M

About 85% survives. Orchestration, severity, consolidation, coverage, the cap and the verdict are platform-agnostic. Three parts change, and the trigger list ripples into `variant` and every domain skill.

| Rule | Class | SwiftUI equivalent or note | Min iOS |
| --- | --- | --- | --- |
| **Evidence, not taste** | KEEP | | |
| **Resolve the scope first** | ADAPT | "Narrow-width states" becomes the narrowest supported width, the largest accessibility text size and the dark appearance, plus compact multitasking widths on iPad | |
| **Send a change to `interface-review`** | KEEP | | |
| **Recon before judgment** | ADAPT | The deployment target first, since it decides which fix exists. Then the SwiftUI and UIKit mix, the design-system package, asset catalogs, device families and orientations in `Info.plist`, localizations and the preview, snapshot and UI-test setup. Storybook drops out | |
| **Use domain skills as the sources of truth** | KEEP | | |
| **Require evidence** | KEEP | Rendered evidence is a Simulator or preview screenshot | |
| **Rank by user impact** | KEEP | Triggers per **2.1** | |
| **Prefer the cheaper fix** | KEEP / ADAPT | The ladder holds and **Use the platform** matters more. Its examples become system controls and presentations, `NavigationStack`, `.toolbar`, system button styles, semantic colors, text styles, SF Symbols and materials. **Add** becomes an accessibility modifier the system cannot infer, `@ScaledMetric` or a custom `Layout` | |
| **Consolidate systemic findings** | KEEP | | |
| **Verify what can be verified** | ADAPT | `xcodebuild build` and `test`, `performAccessibilityAudit()`, Accessibility Inspector, preview variants and Environment Overrides. All need macOS | 17 |
| **Review without mutating by default** | KEEP | | |
| `## Before you finish` | KEEP | The last row becomes "a fix written in UIKit for a SwiftUI view, or for an API above the deployment target" | |
| `review-format.md` | KEEP | Swap the example row's JSX for `Image(systemName: "xmark")` in a `Button`, fixed with `Label("Close", systemImage: "xmark").labelStyle(.iconOnly)` | |

### `better-writing` · Adapt (light) · S

About 85% survives. Copy rules do not depend on the renderer. What changes is where strings live, the plural and format APIs, two Apple conventions and a set of iOS-only copy surfaces.

| Rule | Class | SwiftUI equivalent or note | Min iOS |
| --- | --- | --- | --- |
| **Inventory the existing strings first** | ADAPT | Search `Text("…")`, whose literal is a `LocalizedStringKey`, plus `String(localized:)` (15), `LocalizedStringResource` (16) and `NSLocalizedString`. Files: `Localizable.xcstrings`, `.strings`, `.stringsdict` and `InfoPlist.xcstrings` | 15 |
| **One voice, one vocabulary** | KEEP | Leave system-provided button titles alone, such as **Edit** from `EditButton` and **Cancel** from `role: .cancel` | |
| **Address the reader directly** | KEEP | | |
| **Plain words over clever ones** | KEEP | "Tap" on iOS | |
| **Build strings whole** | ADAPT | Interpolation inside one String Catalog entry; plural variants in the catalog; `^[\(count) item](inflect: true)` for automatic agreement in supported languages. Formatting through `FormatStyle` (15): `.formatted(.currency(code:))`, `Text(date, format:)`, `.formatted(.list(type: .and))` and `Measurement` | 15 |
| **Verb-first buttons** | KEEP (one exception) | HIG allows **OK** in purely informational alerts, never for confirming an action, and always uses **Cancel** to cancel | |
| **Links describe their destination** | KEEP | | |
| **One capitalization policy**, sentence case by default | CONFLICT (default only) | HIG: "As with all button titles, use title-style capitalization." Alert titles that are fragments are title-style too. One policy per element type KEEP; the default flips to title case for buttons, alert titles and navigation titles, with sentence case for body copy and footers | |
| **Settings describe the ON state** | KEEP | Link to the app's page in Settings with `openURL(URL(string: UIApplication.openSettingsURLString)!)` | |
| **Errors say how to fix, next to where it broke** | KEEP | | |
| **Undo beats confirmation** | KEEP / ADAPT | Shake to undo is undiscoverable, so frequent reversible actions need a visible undo. Confirmations use `.confirmationDialog` (15) with `Button(role: .destructive)` (15). Action sheets often hide their title, which makes verb-plus-object buttons more important | 15 |
| **Empty states point forward** | ADAPT | `ContentUnavailableView` (17), and `ContentUnavailableView.search(text:)` for the filtered case | 17 |
| **Placeholders show an example** | CONFLICT (partial) | In a `Form`, the `TextField` title is the placeholder, so an example placeholder would replace the field's name. Use an example only where a visible label exists, via `prompt:` (15) | 15 |

**Reference files.** `patterns.md` ADAPTs. Destructive flows and status copy KEEP. ICU MessageFormat becomes String Catalog plural variants, and the `Intl` table becomes a `FormatStyle` table.

**`## Before you finish`.** The string rows KEEP. Code rows ADAPT: `+` concatenation or `String(format:)` assembling a sentence, `count == 1 ? "" : "s"`, `DateFormatter` with a fixed `dateFormat`, `Button("OK")` in a confirming alert and `.accessibilityLabel("Trash")`.

**Missing.** Permission purpose strings, which are often the most-read copy in an app, notification text, VoiceOver label and hint style and App Shortcut phrases. Labels never include the control type because VoiceOver speaks the trait, and hints describe the result.

### `interface-review` · Adapt · S

About 80% survives, since git does not care about the platform. Three parts are web.

| Rule | Class | SwiftUI equivalent or note |
| --- | --- | --- |
| **The change, not the codebase** | KEEP | |
| **Resolve the change scope first** | KEEP | |
| **With no change, ask rather than invent one** | KEEP | |
| **A diff is not a surface** | ADAPT | Tokens are asset-catalog `.colorset/Contents.json` files, `Font` extensions, `ButtonStyle`s, `ViewModifier`s and environment values. Swift files in one module never import each other, so "import paths" finds nothing; search type and symbol names with `git grep -w` |
| **Read the removed lines** | ADAPT | New pattern table below |
| **Classify every finding** | KEEP | |
| **Hold the change to its stated intent** | ADAPT | States become pressed, disabled, selected, loading, empty and error, plus dark appearance and accessibility sizes. Hover is iPad-only. The missing-translation check reads `.xcstrings` entries whose state is not translated |
| **Hand the review to `better-interface`** | KEEP | |
| **Never mutate the working tree** | KEEP | Rendering a worktree means a full Xcode build, which is slow and macOS-only, so `Not verified` is the default |

**`scope-resolution.md`.** KEEP except two sections.

- **Excluded paths** ADAPT. Add `Package.resolved`, `Podfile.lock`, `Cartfile.resolved`, `Pods/`, `Carthage/`, `.build/`, `DerivedData/`, `xcuserdata/`, `*.xcuserstate`, `__Snapshots__/`, `*.xcresult` and SwiftGen or R.swift output. Keep in scope `.xcassets/**/Contents.json`, which hold the color tokens, `.xcstrings`, `.xcscheme` launch arguments and font files. Exclude `project.pbxproj` but read it for deployment-target changes.
- **Expanding to consumers** ADAPT. Entry points are the `@main` `App`, its `Scene`s, `TabView` tabs, `NavigationStack` roots and `.sheet` content. Previews are not surfaces.

**`removed-signals.md`.** ADAPT. Proposed table:

| Removed from the `-` side | Owner |
| --- | --- |
| `.accessibilityLabel`, `.accessibilityHint`, `.accessibilityValue`, `.accessibilityInputLabels`, `.accessibilityAction`, `.accessibilityAddTraits`, `.accessibilityElement(children:)` | `better-accessibility` |
| `Button` replaced by `.onTapGesture`, `Label` replaced by a bare `Image` | `better-accessibility` |
| `accessibilityReduceMotion` checks | `better-accessibility` |
| A text style replaced by `.font(.system(size:))`, `@ScaledMetric` removed, `.monospacedDigit()` removed | `better-typography` |
| A semantic or asset color replaced by a literal, or a High Contrast variant deleted from a `.colorset` | `better-colors` |
| `.safeAreaInset` replaced by an overlay, or a `.textContentType` or `.keyboardType` removed | `better-layout`, `better-accessibility` |
| A String Catalog entry deleted or shortened | `better-writing` |

Some regressions appear on the `+` side, such as an added `.dynamicTypeSize` cap, `.lineLimit(1)` or `.minimumScaleFactor`, so the search covers added lines for those three. Equivalent replacements: `Image(decorative:)` replacing `.accessibilityHidden(true)`, `Button` replacing `.onTapGesture` with an added button trait, `Label` with `.labelStyle(.iconOnly)` replacing `.accessibilityLabel` and a literal replaced by an asset color with the same value.

### `state-machine` · Rewrite · M

About half survives: scoping, finding states in the code, feeding data at the boundary without editing the component, real-shaped fixtures, held loading states and re-checking every state. The harness changes completely, and for the better.

| Rule | Class | SwiftUI equivalent or note | Min iOS |
| --- | --- | --- | --- |
| **Scope one component** | KEEP | | |
| **Find the states in the code** | KEEP | States are cases of a state enum, `@Observable` model properties, loading flags and feature flags | |
| **Build the throwaway page** | ADAPT | One `#Preview("Empty")`, `#Preview("Enterprise")` and so on per state, in one file beside the view, importing the real view. `"use client"` DROP. "No styles of its own" KEEP | 17 for traits |
| **Feed each state at the data boundary** | ADAPT | Initializer parameters, `.environment(model)` with an `@Observable` (17) fixture, the project's dependency container or a protocol-backed mock service, `PreviewModifier` (18) for shared context and an in-memory `ModelContainer` for SwiftData. "Ask before adding a seam" KEEP, and it matters more: many views build their own `@State` view model internally and have no seam | 17 / 18 |
| Loading and pending hold still | KEEP | Inject the loading state directly, or a mock that never resolves | |
| **Add the switcher** | DROP | The Xcode canvas already lists and switches named previews. The `switcher.md` overlay is needed only for an in-app DEBUG route, when the view needs real navigation or device testing | |
| **Confirm every state renders, then hand over** | ADAPT | The iOS failure is a preview that crashes or renders blank because an `@EnvironmentObject` or environment value is missing. Confirm in the canvas, or hand the file over when there is no Mac | |
| **Re-check every state after each change** | KEEP | | |
| **Remove it in one step, on the user's word** | CONFLICT (convention) | Swift teams usually keep state previews as living documentation. Default to keeping them, wrapped in `#if DEBUG` where fixtures are heavy | |

`switcher.md` DROPs if the canvas is the switcher. If an in-app DEBUG route is kept, it is rewritten in SwiftUI together with `variant`'s `picker.md`, which `AGENTS.md` says must stay the same text.

### `break` · Rewrite or merge · M

About 55% survives: scoping, inferring scenarios from the component, observing rather than judging, owner attribution and "everything survived" as a full report. On iOS it differs from `state-machine` only in what it feeds and whether the file outlives the run.

| Rule | Class | SwiftUI equivalent or note |
| --- | --- | --- |
| Isolates on purpose where `variant` uses the real page | KEEP | |
| Build, look once, report, in minutes | ADAPT | True with Xcode open. Without macOS there is no look; hand over the preview file |
| **Scope one component** | KEEP | |
| **Infer the scenarios from the component** | KEEP | Read the initializer, bindings and environment dependencies |
| **Build the harness page** | ADAPT | A `#Preview` with a `ScrollView` of labelled instances, one per scenario, or one named preview per scenario. `"use client"` DROP |
| No simulated themes or token swaps | CONFLICT (reversed) | Setting `colorScheme`, `dynamicTypeSize`, `layoutDirection`, `locale` or `legibilityWeight` in the environment is how the system applies them, so the preview observes the real component. These become rendered scenarios. Increase Contrast, Reduce Motion, Reduce Transparency and Differentiate Without Color are read-only and stay "name it for the user to toggle" |
| **Look once** | ADAPT | Xcode canvas, or snapshot PNGs the agent can read |
| Mark breaks on the page | ADAPT | Put the note in the scenario's label `Text` |
| **Report what broke and stop** | KEEP | |
| **Leave the page up, delete it on request** | ADAPT | Delete the preview file, or keep it as regression coverage |

**`scenarios.md`.** Content length, content shape, quantity and state KEEP. Content shape adds a tall-script case that `.typesettingLanguage` fixes. Container ADAPTs to fixed `.frame(width: 320)` containers, an `HStack` sibling squeeze and an iPad-wide container. Environment ADAPTs per the row above.

### `build-design` · Adapt · M

About 75% survives. "The design decides", building only what the frames show, the rounding rule, wiring and the fidelity report are agnostic. Three iOS problems are new.

| Rule | Class | SwiftUI equivalent or note |
| --- | --- | --- |
| The design decides | KEEP / ADAPT | Add: iOS UI-kit layers such as the status bar, navigation bar, tab bar, keyboard and home indicator stand for system components. Rebuilding them from layers is CONFLICT; report where the design departs from the system component |
| **Read the design at its source** | ADAPT | Figma's design context returns React and Tailwind by default; translate through the mapping and never paste. An iPhone screenshot's scale is knowable from its pixel size, so 1179×2556 at @3x is 393×852pt, which makes estimates firmer than on the web |
| **Map the design onto the project** | ADAPT | Variables become asset colors, `Font` extensions and spacing constants; component instances become project views; UI-kit instances become `NavigationStack` with `.toolbar`, `TabView`, `List`, `Toggle`, button styles and `.searchable`. Font sizes round to the nearest text style even at 1pt off, rather than `.font(.system(size: 15))`. The 2px rule becomes 2pt |
| **Build only what the design shows** | ADAPT | Dynamic Type and dark mode are requirements, not undrawn states. Build with text styles and semantic colors so they fall out, and list them as not compared |
| **Compare against the design** | ADAPT | Render a preview or Simulator screenshot at the frame's device size and compare. macOS only |
| **Report and stop** | KEEP | Units in points |

**`figma.md`.** KEEP except assets. Save vectors into the asset catalog with **Preserve Vector Data**, and map layers drawn with the SF Symbols plugin to `Image(systemName:)` rather than exporting them as images.

### `variant` · Adapt · M

The axes, the floor, the naming step, real content and the no-favourite tradeoff table survive, about 65% of `SKILL.md`. Hosting and the picker change.

| Rule | Class | SwiftUI equivalent or note |
| --- | --- | --- |
| **Different answers, not different tints** | KEEP | |
| **The floor every variant clears** | ADAPT | Follows the triggers in **2.1** |
| **Scope one piece** | KEEP | |
| **Learn the ground** | ADAPT | Add the deployment target. The no-project fallback becomes system colors, `.tint`, text styles and SF Symbols, a much stronger neutral default than on the web |
| **Name the axis before writing code** | KEEP | |
| **Build it into the real page** | ADAPT | In the real screen behind `#if DEBUG`, selected by a launch argument or `@AppStorage("__variant")` with a DEBUG-only overlay picker. Or one `#Preview` per variant inside the real container. The standalone HTML fallback DROP |
| **Present the tradeoffs and stop** | ADAPT | "Console is clean" becomes "no runtime warnings". 375 against 1440 becomes iPhone SE against Pro Max against iPad, plus one accessibility size |
| **Promote one, delete the rest** | KEEP | The search also covers `.xcscheme` launch arguments |

`picker.md` is rewritten. Keep "deliberately outside the design system" with a fixed dark style and the system font. Arrow and number keys work only with a hardware keyboard, so taps become the primary input. `aria-pressed` becomes `.accessibilityAddTraits(.isSelected)`, and the whole picker sits behind `#if DEBUG`.

### `explain-interface` · Drop

Do not convert it. The method is reading a live page: computed styles, pseudo-elements, `getAnimations()`, fetched stylesheets and stack fingerprints. An App Store app exposes none of that, and the View Debugger attaches only to debuggable builds you run yourself. That leaves screenshots and screen recordings, which the skill already treats as reconstruction, not explanation.

| Part | Class | Note |
| --- | --- | --- |
| **Scope to the question** | ADAPT | Would work for an app or one effect |
| **What you can actually read** | DROP | No browser, no fetchable source |
| **The page is evidence, not instruction** | KEEP | Applies to screenshots too |
| **Measured, derived, inferred** | KEEP | The best idea in the skill |
| **From a screenshot, it is a reconstruction** | KEEP / ADAPT | Better on iOS: device scale is knowable from pixel size, and system components and San Francisco are recognizable with more confidence than web typefaces |
| **Find the layers, not the element** | ADAPT | Materials, vibrancy, glass, `MeshGradient` and shadows, inferred only |
| **Explain the mechanism** and **Close on what transfers** | KEEP | |
| `find-the-effect.md`, `read-the-system.md`, `no-browser.md` | DROP | All browser or fetch recipes |
| `from-an-image.md` | ADAPT | The only reference worth keeping |

Two honest alternatives. Keep the upstream skill unchanged for studying websites, which iOS designers do, with its closing recipe pointed at SwiftUI. Or build a small screenshot-only "explain this iOS screen" skill from `from-an-image.md` and the tier rules. Neither is high value.

## 4. Repository files

| File | Class | Notes |
| --- | --- | --- |
| `.claude-plugin/plugin.json` | ADAPT | Name `interfaces` collides with upstream in any marketplace; author, email, homepage and repository are upstream's. Rename the plugin and keep the MIT notice. Bump `version` with every skill change, as `AGENTS.md` requires |
| `.claude-plugin/marketplace.json` | ADAPT | Same name collision and owner fields |
| `README.md` | ADAPT | Logo and links go to interfaces.dev, install paths name `jakubkrehel/skills` and the skill lines must match the new descriptions word for word |
| `AGENTS.md` | ADAPT, M | Ownership table: "logical CSS properties" and "browser focus ring" need iOS terms, and Dynamic Type, VoiceOver, haptics, materials, SF Symbols, safe areas, system colors and previews need owners per **2.3**. Authoring conventions say "exact CSS properties" and "Tailwind vs. plain CSS vs. CSS-in-JS"; these become modifiers, SwiftUI against UIKit and the deployment target. Invocation rules KEEP. The picker and switcher pair and the identical throwaway-route paragraphs in `break` and `state-machine` change if previews replace them. The 30-word ceiling and other prose checks KEEP |
| `CLAUDE.md` | KEEP | Imports `AGENTS.md` only |
| `opencode.json`, `.gitattributes` | KEEP | |
| `agents/openai.yaml` | ADAPT | Short descriptions per **2.4**. The `allow_implicit_invocation` policies KEEP |
| `package.json` checks | Note | None at the repository level. The only one in any skill is `icon-transitions.md` looking for Motion, which DROPs |

## 5. Recommended conversion order

Domain skills come first because they are model-invoked and currently give wrong advice in Swift projects without anyone asking. User-invoked skills only cause harm when someone runs them.

1. **Decide the open questions below.** Fork strategy, deployment target and the contrast table change every later step.
2. **`AGENTS.md` and `better-interface`.** The trigger list, the ownership table for new concerns and the verification commands. Everything else references them. M.
3. **`better-accessibility`.** Highest user impact. Owns most triggers, VoiceOver and the Dynamic Type requirement. L.
4. **`better-typography`.** Owns Dynamic Type mechanics and holds the conflicts that degrade apps most visibly: fixed sizes, leading and tracking. L.
5. **`better-ui`.** Fires on every polish request and holds the most conflicts. SF Symbols, haptics and materials land here. L.
6. **`better-layout`.** Principles survive; safe areas, size classes and the detection table are the work. M.
7. **`better-colors`.** Mostly a notation and storage swap, plus the system-colors stance. M.
8. **`better-writing`.** Small, and can be slotted in anywhere as a quick win. S.
9. **`interface-review`.** Small once `better-interface` is done. S.
10. **`state-machine`, with `break` merged in or rewritten beside it.** The highest-value user-invoked skill for SwiftUI work. M.
11. **`build-design`.** M.
12. **`variant`.** M.
13. **README, manifests and `openai.yaml`.** Change each skill's line in the same commit as the skill, then a final rename pass. S.
14. **`explain-interface`.** Do not convert.

## 6. Open questions

1. **Fork strategy.** A separate iOS-only skill set with a renamed plugin, or platform branches inside each skill with web and iOS references side by side? Separate is simpler and matches `AGENTS.md`'s "works installed alone" rule. Branching keeps upstream merges possible. If separate, keep the `better-*` names and disambiguate by description, or suffix them, as in `better-typography-ios`?
2. **Deployment target.** iOS 17 unlocks most of what this audit recommends: `ContentUnavailableView`, `.sensoryFeedback`, symbol effects, `contentMargins`, scroll targeting, `AccessibilityNotification` and the accessibility audit API. iOS 26 adds Liquid Glass and `ConcentricRectangle`. Should the skills assume a floor or read `IPHONEOS_DEPLOYMENT_TARGET` and branch?
3. **UIKit.** SwiftUI only, or also `UIViewRepresentable` and mixed codebases?
4. **Devices.** iPhone only, or iPad with pointer, keyboard and multitasking? Mac Catalyst or visionOS? This decides whether focus, keyboard and hover rules exist at all.
5. **Liquid Glass.** Write for the iOS 26 design language by default, or stay neutral for apps that still support iOS 17 and 18?
6. **Citation basis.** WCAG 2.2 through WCAG2ICT, which matters if you ship in the EU under EN 301 549, Apple's Nutrition Label criteria, or both?
7. **Contrast table.** WCAG's large-text definition, or the HIG's, which passes bold text at 3:1 at any size? The choice decides whether a white label on the default `systemBlue` is a finding.
8. **Hit targets.** Make the HIG's 28×28pt minimum the finding threshold with 44×44pt as the recommendation, mirroring the web skill's 24px and 44px split?
9. **Conventions to adopt.** Switch `better-writing`'s default to Apple's title-style buttons and accept the disabled toolbar **Done** pattern as an exception to "validate on submit"?
10. **Preview lifetime.** Keep state previews committed, the Swift norm, or delete them on request, the web skills' rule? Merge `break` into `state-machine`?
11. **`explain-interface`.** Drop, keep upstream's web version for studying websites, or build the screenshot-only variant?
12. **Where agents run.** Local Claude Code on a Mac with Xcode, or also Linux and cloud sessions that cannot build or render? This decides whether verification steps are runnable or always `Not verified`.
13. **Snapshot testing.** Is swift-snapshot-testing, or an `ImageRenderer`-based test, acceptable as the agent's "look once" path?
14. **Surfaces in scope.** Widgets, Live Activities, App Intents, notifications and watchOS: in or out?
15. **Upstream sync.** If you plan to pull upstream changes, keeping the file structure parallel will save merge pain.

## Sources

- HIG: [Accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility), [Alerts](https://developer.apple.com/design/human-interface-guidelines/alerts), [Buttons](https://developer.apple.com/design/human-interface-guidelines/buttons), [Tab bars](https://developer.apple.com/design/human-interface-guidelines/tab-bars), [SF Symbols](https://developer.apple.com/design/human-interface-guidelines/sf-symbols), [Materials](https://developer.apple.com/design/human-interface-guidelines/materials), [Motion](https://developer.apple.com/design/human-interface-guidelines/motion), [Color](https://developer.apple.com/design/human-interface-guidelines/color), [Dark Mode](https://developer.apple.com/design/human-interface-guidelines/dark-mode), [Writing](https://developer.apple.com/design/human-interface-guidelines/writing), [Playing haptics](https://developer.apple.com/design/human-interface-guidelines/playing-haptics)
- App Store Connect: [Larger Text evaluation criteria](https://developer.apple.com/help/app-store-connect/manage-app-accessibility/larger-text-evaluation-criteria), [Sufficient Contrast evaluation criteria](https://developer.apple.com/help/app-store-connect/manage-app-accessibility/sufficient-contrast-evaluation-criteria)
- API availability: [SwiftUI documentation](https://developer.apple.com/documentation/swiftui), read per symbol on the audit date
- [SF Symbols in SwiftUI: tab bars apply the fill variant automatically](https://sarunw.com/posts/what-is-variant-in-sf-symbols/), confirmed against the HIG SF Symbols page
