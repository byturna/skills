# Checks

A Swift package with one file per skill holding every snippet the skill shows, plus `DebugPicker.swift`, which `variant` and `previews` share. It exists so that a change to a skill can be compiled. Neither the plugin nor the skills CLI ships it.

## Build

From this folder, with Xcode 26.3 selected through `xcode-select`:

```bash
xcodebuild build -scheme Checks -destination 'generic/platform=iOS Simulator' -quiet
```

Or open `Package.swift` in Xcode, pick any iOS Simulator and press Command-B. Nothing needs to run. `swift build` does not work, because it builds for the Mac.

## Settings

The target builds in the Swift 6 language mode, with main-actor default isolation and Approachable Concurrency. Those are the settings `write-swift` gives app modules, so a snippet that compiles here compiles in an Xcode 26 app project on Swift 6.

## Adding a snippet

Each file wraps its made-up types in a namespace enum, so every file builds in one target. A change to a snippet in a skill changes its file here in the same pull request. A new skill with snippets adds a file named for it under `Sources/Checks/`.
