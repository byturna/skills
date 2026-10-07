# Cheat sheet

Every API this skill names, with its UIKit form. A UIKit screen hosts the same SwiftUI picker through a hosting controller.

| Need | SwiftUI | UIKit |
| --- | --- | --- |
| Store the choice | `@AppStorage("__variant")` | The same, in a SwiftUI wrapper around the picker |
| Show the picker | `.overlay(alignment: .bottom)` | A `UIHostingController` child, pinned to `safeAreaLayoutGuide.bottomAnchor` |
| Size the picker to its content | Automatic | `sizingOptions = .intrinsicContentSize` |
| Switch variants | A `switch` on the stored choice in `body` | Replace the piece's view when the choice changes |
| Keep it out of release builds | `#if DEBUG` | `#if DEBUG` |

A small wrapper owns the stored choice, so the picker redraws when it changes. It also tells the screen which variant to show:

```swift
#if DEBUG
struct HostedVariantPicker: View {
    @AppStorage("__variant") private var variant = ActivityCardVariant.quiet
    let onChange: (ActivityCardVariant) -> Void

    var body: some View {
        DebugPicker("Variants", selection: $variant)
            .onChange(of: variant, initial: true) { _, newValue in
                onChange(newValue)
            }
    }
}

extension ActivityViewController {
    func addVariantPicker() {
        let picker = UIHostingController(rootView: HostedVariantPicker { [weak self] variant in
            self?.showVariant(variant)
        })
        picker.sizingOptions = .intrinsicContentSize
        picker.view.backgroundColor = .clear
        picker.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(picker)
        view.addSubview(picker.view)
        NSLayoutConstraint.activate([
            picker.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            picker.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            picker.view.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor),
        ])
        picker.didMove(toParent: self)
    }
}
#endif
```
