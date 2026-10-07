# System colors

The system colors by role and the accent.

## Roles

| Role | SwiftUI |
| --- | --- |
| Primary text | `.primary` |
| Secondary, tertiary and quaternary text | `.secondary`, `.tertiary`, `.quaternary` |
| Placeholder text | `.placeholder` |
| A link | `.link` |
| A separator | `.separator` |
| A screen's background | `Color(.systemBackground)` |
| Content grouped on it, then grouped within that | `Color(.secondarySystemBackground)`, `Color(.tertiarySystemBackground)` |
| The background behind grouped lists and their rows | `Color(.systemGroupedBackground)`, `Color(.secondarySystemGroupedBackground)` |
| A fill behind a small shape, then larger ones | `Color(.systemFill)` through `Color(.quaternarySystemFill)` |
| A neutral gray | `Color(.systemGray)` through `Color(.systemGray6)` |
| A status | `.red`, `.orange`, `.yellow`, `.green`, `.mint`, `.teal`, `.cyan`, `.blue`, `.indigo`, `.purple`, `.pink`, `.brown` |

The hierarchical styles, `.primary` through `.quaternary`, follow the current foreground style. They keep their vibrancy on a material, where a fixed color does not.

```swift
// Good: system colors carry dark, elevated and high-contrast variants
VStack(alignment: .leading, spacing: 4) {
    Text(order.title)
        .foregroundStyle(.primary)
    Text(order.status)
        .foregroundStyle(.secondary)
}
.padding()
.background(Color(.secondarySystemGroupedBackground), in: .rect(cornerRadius: 16))

// Bad: fixed values that never adapt
VStack(alignment: .leading, spacing: 4) {
    Text(order.title)
        .foregroundStyle(Color.black)
    Text(order.status)
        .foregroundStyle(Color.gray)
}
.padding()
.background(Color.white, in: .rect(cornerRadius: 16))
```

## The accent

New projects carry an `AccentColor` color set. Give it the brand's interactive color with all four variants, and the system applies it to buttons, toggles, selection and links. A part of the app with its own accent, such as a section with a different brand, takes `.tint(_:)`:

```swift
SettingsSection()
    .tint(Color(.partnerAccent))
```

Over colorful content, the HIG suggests a monochrome bar or an accent that stays clearly distinct from the content beneath it.
