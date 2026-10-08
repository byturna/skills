# Widgets and Live Activities

Recipes for color in each widget rendering mode and in each Live Activity presentation.

## Rendering modes

The symbol joins the accent group, so the tinted appearance colors it apart from the text:

```swift
struct StepsWidgetView: View {
    let steps: Int

    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: "figure.walk")
                .foregroundStyle(.tint)
                .widgetAccentable()
            Text(steps, format: .number)
                .font(.title.bold())
            Text("steps")
                .foregroundStyle(.secondary)
        }
    }
}
```

Album art keeps its color in the tinted and clear appearances, and every other image desaturates:

```swift
Image(uiImage: entry.artwork)
    .resizable()
    .widgetAccentedRenderingMode(.fullColor)
    .scaledToFit()
```

## Live Activities

One brand color runs through the content and the key line, and the Lock Screen background is a color set:

```swift
ActivityConfiguration(for: DeliveryAttributes.self) { context in
    DeliveryDetail(context: context)
        .activityBackgroundTint(Color(.deliveryBackground))
        .activitySystemActionForegroundColor(Color(.deliveryAccent))
} dynamicIsland: { context in
    DynamicIsland {
        DynamicIslandExpandedRegion(.leading) {
            Image(systemName: "bag")
                .foregroundStyle(Color(.deliveryAccent))
        }
    } compactLeading: {
        Image(systemName: "bag")
            .foregroundStyle(Color(.deliveryAccent))
    } compactTrailing: {
        Text(timerInterval: context.state.arrival, countsDown: true)
            .monospacedDigit()
            .foregroundStyle(Color(.deliveryAccent))
    } minimal: {
        Text(timerInterval: context.state.arrival, countsDown: true)
            .monospacedDigit()
            .foregroundStyle(Color(.deliveryAccent))
    }
    .keylineTint(Color(.deliveryAccent))
}
```
