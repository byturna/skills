# Cheat sheet

The UIKit form of every mapping in [mapping.md](mapping.md). Match whichever the project's views are written in.

## Values and layout

| Need | SwiftUI | UIKit |
| --- | --- | --- |
| Text style | `.font(.headline)` | `UIFont.preferredFont(forTextStyle: .headline)` with `adjustsFontForContentSizeCategory = true` |
| System color | `.secondary`, `Color(.secondarySystemGroupedBackground)` | `.secondaryLabel`, `.secondarySystemGroupedBackground` |
| Color set | `Color(.brandAccent)` | `UIColor(resource: .brandAccent)` |
| Stack | `VStack(alignment:spacing:)`, `HStack` | `UIStackView` with `axis`, `alignment` and `spacing` |
| System margin | `.padding()` with no argument | `directionalLayoutMargins`, `layoutMarginsGuide` |
| Symbol | `Image(systemName:)` | `UIImage(systemName:)` |

## System components

| Need | SwiftUI | UIKit |
| --- | --- | --- |
| Navigation bar | `NavigationStack` with `.navigationTitle` and `.toolbar` | `UINavigationController` with `navigationItem` |
| Tab bar | `TabView` with `Tab` | `UITabBarController` with `UITab` |
| List | `List`, `Section`, `Form` | `UICollectionView` with `UICollectionLayoutListConfiguration` |
| Switch | `Toggle` | `UISwitch` |
| Segmented control | `Picker` with `.pickerStyle(.segmented)` | `UISegmentedControl` |
| Slider and stepper | `Slider`, `Stepper` | `UISlider`, `UIStepper` |
| Search field | `.searchable(text:placement:prompt:)` | `UISearchController` |
| Glass button | `.buttonStyle(.glass)`, `.glassProminent` | `UIButton.Configuration.glass()`, `.prominentGlass()` |
| Filled, tinted or plain button | `.buttonStyle(.borderedProminent)`, `.bordered`, `.borderless` | `UIButton.Configuration.filled()`, `.tinted()`, `.plain()` |
| Sheet | `.sheet` with `.presentationDetents` | `sheetPresentationController` with `detents` |
| Alert and action sheet | `.alert`, `.confirmationDialog` | `UIAlertController` with `.alert` or `.actionSheet` |
| Menu | `Menu`, `.contextMenu` | `UIMenu` on a button, `UIContextMenuInteraction` |
| Page dots | `TabView` with `.tabViewStyle(.page)` | `UIPageControl` |
| Progress | `ProgressView` | `UIProgressView`, `UIActivityIndicatorView` |
| Date picker | `DatePicker` | `UIDatePicker` |
| Text field | `TextField` | `UITextField` |
