// DebugPicker.swift
//
// The picker from the `## The picker` sections of skills/variant/picker.md and
// skills/previews/picker.md, which carry identical copies. VariantSnippets and
// PreviewsSnippets both use it. Build with the Debug configuration.

import SwiftUI

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
