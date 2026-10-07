# Mapping

How **Map the design onto the project** turns each design value into code. A value the project already has wins over the system's, and the system's wins over a number.

## Values

| In the design | In code |
| --- | --- |
| A variable or style bound to a token | The project's color set, text style or constant with that name or value |
| A raw value that equals a token | That token |
| A raw value with no token | The nearest step of the project's scale, listed as rounded. With no scale, the design's number |
| A margin that matches the system's, such as a screen's content inset or a list row's | `.padding()` with no argument, or the list's own insets |
| A color from Apple's iOS UI Kit named for a role, such as a label, a background, a fill or a separator | The system color for that role, which `color` lists |
| A container's corner inside another rounded container | A concentric shape, which `ui` covers |

## Text

Text maps to a text style by size and weight at the default text size. These are the sizes `typography` lists:

| Size | Regular | Semibold |
| --- | --- | --- |
| 34pt | `.largeTitle` | |
| 28pt | `.title` | |
| 22pt | `.title2` | |
| 20pt | `.title3` | |
| 17pt | `.body` | `.headline` |
| 16pt | `.callout` | |
| 15pt | `.subheadline` | |
| 13pt | `.footnote` | |
| 12pt | `.caption` | |
| 11pt | `.caption2` | |

A weight the table does not list takes the style for its size with `.fontWeight(_:)`, or `.bold()` for the style's emphasized weight. A size between two styles takes the nearer one and is listed as rounded. A custom typeface takes the project's type role for it, which scales relative to a text style.

## Layout

| In the design | In code |
| --- | --- |
| An auto layout frame | `HStack` or `VStack` in its direction |
| Its gap | The stack's `spacing` |
| Its padding | `.padding`, mapped as a value above |
| A child set to fill the container | `.frame(maxWidth: .infinity)` |
| A child set to hug its contents | No frame |
| A fixed size | A fixed frame only where the element is fixed, such as an icon or an avatar |
| Left or right alignment | `.leading` or `.trailing` |
| A layer placed at absolute coordinates | The stack, alignment or overlay that puts it there |

## Components

| In the design | In code |
| --- | --- |
| An instance with a Code Connect mapping | The mapped view, configured as the mapping says |
| An instance of a project component | The project's view, in the variant the design shows |
| An instance with no project equivalent | Plain views in place, listed as a deviation, and ask whether a component should exist |
| A one-off group of layers | Plain views in place, not a new component |

Instances from Apple's iOS UI Kit stand for system components:

| In the design | In code |
| --- | --- |
| Status bar, home indicator or keyboard | Nothing, since the system draws them |
| Navigation bar | `NavigationStack` with `.navigationTitle` and `.toolbar` |
| Tab bar | `TabView` with `Tab` |
| Toolbar | `.toolbar` |
| List, cell or grouped table | `List`, with `Section`, or a `Form` |
| Switch | `Toggle` |
| Segmented control | `Picker` with `.pickerStyle(.segmented)` |
| Slider or stepper | `Slider` or `Stepper` |
| Search field | `.searchable(text:placement:prompt:)` |
| Glass button | `.buttonStyle(.glass)`, or `.glassProminent` for the primary action |
| Filled, tinted or plain button | `.buttonStyle(.borderedProminent)`, `.bordered` or `.borderless` |
| Sheet | `.sheet` with `.presentationDetents` |
| Alert or action sheet | `.alert` or `.confirmationDialog` |
| Pull-down or context menu | `Menu` or `.contextMenu` |
| Page dots | `TabView` with `.tabViewStyle(.page)` |
| Progress bar or spinner | `ProgressView` |
| Date or time picker | `DatePicker` |
| Text field | `TextField` |
| A symbol from SF Symbols | `Image(systemName:)` with that name |

## A translated frame

The design context returns reference code in React and Tailwind:

```tsx
<div className="flex flex-col gap-1 p-4 bg-white rounded-2xl">
  <p className="text-[17px] font-semibold text-[#000000]">Morning Run</p>
  <p className="text-[15px] text-[#3C3C4399]">5.2 km · 28 min</p>
</div>
```

The same frame, mapped onto a grouped screen with no tokens of its own:

```swift
VStack(alignment: .leading, spacing: 4) {
    Text(run.title)
        .font(.headline)
    Text(run.summary)
        .font(.subheadline)
        .foregroundStyle(.secondary)
}
.padding()
.frame(maxWidth: .infinity, alignment: .leading)
.background(Color(.secondarySystemGroupedBackground), in: .rect(cornerRadius: 16))
```

The 17pt semibold line is `.headline`. The translucent gray is the light value of `.secondary`, and the white card on a grouped screen is the grouped background's second level. The sample strings become the model's values.
