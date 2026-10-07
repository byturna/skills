# Checks

One Swift file per skill holding every snippet the skill shows, plus `DebugPicker.swift`, which `variant` and `previews` share. They exist so that a change to a skill can be compiled. Neither the plugin nor the skills CLI ships them.

To build them, create an iOS app project with an iOS 26 deployment target and add every file here to the app target only. Build the Debug configuration with Command-B. Nothing needs to run.

Each file wraps its made-up types in a namespace enum, so all the files build together in one target. A change to a snippet in a skill changes its file here in the same pull request.
