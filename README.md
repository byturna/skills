# skills

Agent skills for building native iOS interfaces with SwiftUI and UIKit, following Apple's Human Interface Guidelines. Skills are added one at a time as they are converted.

## Skills

- [**accessibility**](skills/accessibility/SKILL.md): Reviews and fixes VoiceOver, Voice Control, keyboard, Dynamic Type, touch target, form and Reduce Motion support in SwiftUI and UIKit apps, against Apple's accessibility criteria.
- [**color**](skills/color/SKILL.md): Builds and checks the colors of SwiftUI and UIKit apps, from system semantic colors and the accent to custom palettes, dark and high-contrast variants and measured contrast.
- [**design-review**](skills/design-review/SKILL.md): Reviews a SwiftUI or UIKit screen, flow or app across accessibility, navigation, layout, writing, typography, color, surfaces and motion, and returns one ranked verdict.
- [**layout**](skills/layout/SKILL.md): Sets grouping, alignment, spacing, safe areas and adaptive structure in SwiftUI and UIKit apps, so a screen holds up across size classes, text sizes, languages and right-to-left.
- [**motion**](skills/motion/SKILL.md): Decides whether something in a SwiftUI or UIKit app should animate, then builds it with system transitions, springs, symbol effects, gestures and haptics that feel native.
- [**navigation**](skills/navigation/SKILL.md): Chooses how people move through SwiftUI and UIKit apps, from tabs, stacks and split views to sheets, popovers, alerts, toolbars and search.
- [**previews**](skills/previews/SKILL.md): Writes previews that show one SwiftUI or UIKit view in every state and worst case it can reach, then reports what visibly broke and which skill owns the fix. User-invoked.
- [**typography**](skills/typography/SKILL.md): Sets and reviews how text renders in SwiftUI and UIKit apps, from Dynamic Type text styles and custom fonts to weights, numerals, truncation and punctuation.
- [**ui**](skills/ui/SKILL.md): Builds the surfaces and icons of SwiftUI and UIKit apps, from Liquid Glass, materials and concentric corners to SF Symbols and iPad pointer hover.
- [**writing**](skills/writing/SKILL.md): Writes and checks the words in SwiftUI and UIKit apps, from buttons, alerts and errors to empty states, permission requests and notifications, in one voice and ready to translate.
- [**write-swift**](skills/write-swift/SKILL.md): Writes, reviews and migrates modern Swift, from value types and generics to Swift 6 concurrency, performance and Swift Testing.

## Install

```text
/plugin marketplace add byturna/skills
/plugin install anr@uix
```

Skills then run as `/anr:<skill>`, and the model-invoked ones load on their own when a task needs them.

## Credits

Built on [jakubkrehel/skills](https://github.com/jakubkrehel/skills) by Jakub Krehel and [emilkowalski/skills](https://github.com/emilkowalski/skills) by Emil Kowalski, both MIT. [NOTICE.md](NOTICE.md) carries their licenses and the commits the material was taken from.
