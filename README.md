# skills

Agent skills for building native iOS interfaces with SwiftUI and UIKit, following Apple's Human Interface Guidelines. Skills are added one at a time as they are converted.

## Skills

- [**accessibility**](skills/accessibility/SKILL.md): Reviews and fixes VoiceOver, Voice Control, keyboard, Dynamic Type, touch target, form and Reduce Motion support in SwiftUI and UIKit apps, against Apple's accessibility criteria.
- [**motion**](skills/motion/SKILL.md): Decides whether something in a SwiftUI or UIKit app should animate, then builds it with system transitions, springs, symbol effects, gestures and haptics that feel native.
- [**ui**](skills/ui/SKILL.md): Builds the surfaces and icons of SwiftUI and UIKit apps, from Liquid Glass, materials and concentric corners to SF Symbols and iPad pointer hover.
- [**write-swift**](skills/write-swift/SKILL.md): Writes, reviews and migrates modern Swift, from value types and generics to Swift 6 concurrency, performance and Swift Testing.

## Install

```text
/plugin marketplace add byturna/skills
/plugin install anr@uix
```

Skills then run as `/anr:<skill>`, and the model-invoked ones load on their own when a task needs them.

## Credits

Built on [jakubkrehel/skills](https://github.com/jakubkrehel/skills) by Jakub Krehel and [emilkowalski/skills](https://github.com/emilkowalski/skills) by Emil Kowalski, both MIT. [NOTICE.md](NOTICE.md) carries their licenses and the commits the material was taken from.
