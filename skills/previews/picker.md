# The picker

The All states preview, which flips through every state in one place, and the picker over it. The picker is debug chrome, so build it as specified and leave it alone.

## Behavior

- It is one dark capsule with white text in the system font, outside the project's colors, fonts, tint and glass.
- Tapping a name shows that state. Switching is instant, with no animation.
- The chevron collapses the picker to the current name, for screenshots and recordings.
- The selected name carries the selected trait for VoiceOver, and its strings never reach the String Catalog.

## The picker

```swift
#if DEBUG
struct DebugPicker<Option>: View
where Option: CaseIterable & Hashable & RawRepresentable, Option.RawValue == String {
    let title: String
    @Binding var selection: Option
    @State private var isCollapsed = false

    init(_ title: String, selection: Binding<Option>) {
        self.title = title
        self._selection = selection
    }

    var body: some View {
        Group {
            if isCollapsed {
                Button(selection.rawValue.capitalized, systemImage: "chevron.up") {
                    isCollapsed = false
                }
                .buttonStyle(DebugPickerButtonStyle(isSelected: true))
            } else {
                HStack(spacing: 2) {
                    ViewThatFits(in: .horizontal) {
                        options
                        ScrollView(.horizontal) { options }
                            .scrollIndicators(.hidden)
                    }
                    Button("Hide " + title, systemImage: "chevron.down") {
                        isCollapsed = true
                    }
                    .labelStyle(.iconOnly)
                    .buttonStyle(DebugPickerButtonStyle(isSelected: false))
                }
            }
        }
        .padding(4)
        .background(Color.black.opacity(0.88), in: .capsule)
        .font(.footnote.weight(.medium))
        .environment(\.colorScheme, .dark)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(Text(verbatim: title))
        .padding(.horizontal)
    }

    private var options: some View {
        HStack(spacing: 2) {
            ForEach(Array(Option.allCases), id: \.self) { option in
                Button(option.rawValue.capitalized) {
                    selection = option
                }
                .buttonStyle(DebugPickerButtonStyle(isSelected: option == selection))
                .accessibilityAddTraits(option == selection ? .isSelected : [])
            }
        }
    }
}

private struct DebugPickerButtonStyle: ButtonStyle {
    let isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .foregroundStyle(.white.opacity(isSelected || configuration.isPressed ? 1 : 0.6))
            .background(.white.opacity(isSelected ? 0.14 : 0), in: .capsule)
            .contentShape(.capsule)
    }
}
#endif
```

## All states

One enum lists the states, each feeding the fixture its named preview uses:

```swift
#if DEBUG
enum MemberListState: String, CaseIterable {
    case typical, empty, crowded

    var members: [Member] {
        switch self {
        case .typical: Member.typical
        case .empty: []
        case .crowded: Member.worstCase
        }
    }
}

#Preview("All states") {
    @Previewable @State var state = MemberListState.typical
    NavigationStack {
        MemberList(members: state.members)
    }
    .overlay(alignment: .bottom) {
        DebugPicker("States", selection: $state)
    }
}
#endif
```

Run it in the canvas's live mode, or on a connected device where Xcode offers one in the Preview Device menu.
