# Use the platform

Common custom builds and the system API that replaces each, for the **Use the platform** step of **Prefer the cheaper fix**. The system version brings VoiceOver, Dynamic Type, keyboard support and Liquid Glass with it. The domain column names the skill whose rule the finding cites. Values such as text styles, semantic colors and springs are in each domain's own skill.

| Custom build | System API | Domain |
| --- | --- | --- |
| `.onTapGesture` on a view that acts like a button | `Button` | `accessibility` |
| A checkbox or switch drawn by hand | `Toggle` | `accessibility` |
| A minus and plus pair around a number | `Stepper` | `accessibility` |
| A row of buttons where one is selected | `Picker` with `.pickerStyle(.segmented)` | `accessibility` |
| A date typed into a text field | `DatePicker` | `accessibility` |
| A spinner or bar drawn with shapes | `ProgressView` | `accessibility` |
| A level drawn with shapes | `Gauge` | `accessibility` |
| A chart drawn with `Path` | `Chart` from Swift Charts | `accessibility` |
| A tab bar built from a row of buttons | `TabView` with `Tab` | `navigation` |
| A hand-built push or back button | `NavigationStack` | `navigation` |
| An overlay posing as a sheet, alert or menu | `.sheet`, `.alert`, `.confirmationDialog` or `Menu` | `navigation` |
| A detail panel beside content on iPad | `.inspector(isPresented:content:)` | `navigation` |
| A search field placed by hand | `.searchable(text:placement:prompt:)` | `navigation` |
| A share sheet presented through UIKit | `ShareLink` | `navigation` |
| A document browser built by hand | `.fileImporter(isPresented:allowedContentTypes:allowsMultipleSelection:onCompletion:)` | `navigation` |
| A coach mark or tooltip overlay | TipKit's `TipView` or `.popoverTip(_:arrowEdge:action:)` | `navigation` |
| An Edit button that toggles a flag | `EditButton` | `navigation` |
| A label and value row built from an `HStack` and a `Spacer` | `LabeledContent` | `layout` |
| A settings screen built from custom rows in a `ScrollView` | `Form` | `layout` |
| A tap on the background to dismiss the keyboard | `.scrollDismissesKeyboard(_:)` | `layout` |
| An empty screen built from loose `Text` | `ContentUnavailableView` | `writing` |
| A photo grid that asks for library access | `PhotosPicker` | `writing` |
| A location prompt for a single use | `LocationButton` | `writing` |
| A paste control that reads the pasteboard | `PasteButton` | `writing` |
| A color well built by hand | `ColorPicker` | `color` |
| A Sign in with Apple button drawn by hand | `SignInWithAppleButton` | `ui` |
| Pull to refresh built from scroll offsets | `.refreshable(action:)` | `motion` |
| Swipe to delete built with a `DragGesture` | `.swipeActions(edge:allowsFullSwipe:content:)` | `motion` |
| A long-press menu built by hand | `.contextMenu(menuItems:)` | `motion` |
| Drag and drop built with a `DragGesture` | `.draggable(_:)` with `.dropDestination(for:action:isTargeted:)` | `motion` |

`PhotosPicker` and `PasteButton` need no permission prompt. `LocationButton` grants access one tap at a time, after a single system alert. Keep a custom build only where it does something the system API cannot, and name that case in the report.
