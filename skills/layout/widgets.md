# Widgets and Live Activities

Recipes for laying out widgets by family and Live Activities by presentation.

## A layout per family

Each family gets the layout its space suits. Families the widget does not list never appear in the gallery:

```swift
struct StepsWidgetView: View {
    let entry: StepsEntry
    @Environment(\.widgetFamily) private var family

    var body: some View {
        switch family {
        case .accessoryInline:
            Text("\(entry.steps) steps")
        case .systemMedium:
            HStack {
                StepsSummary(entry: entry)
                Spacer()
                WeekChart(days: entry.week)
            }
        default:
            StepsSummary(entry: entry)
        }
    }
}

struct StepsWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Steps", provider: StepsProvider()) { entry in
            StepsWidgetView(entry: entry)
        }
        .supportedFamilies([.systemSmall, .systemMedium, .accessoryInline])
    }
}
```

## Content that reaches the edge

A background belongs in the container background, which `ui` covers, and never needs the margins turned off. Turn them off only for content that runs to the edge, such as a chart, and inset the text yourself:

```swift
struct ElevationWidgetView: View {
    let entry: TrailEntry
    @Environment(\.widgetContentMargins) private var margins

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(entry.trailName)
                .padding(margins)
            ElevationChart(points: entry.elevation)
        }
    }
}

struct ElevationWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Elevation", provider: TrailProvider()) { entry in
            ElevationWidgetView(entry: entry)
        }
        .contentMarginsDisabled()
    }
}
```

## The four presentations

The compact views carry the same fact on both sides of the camera, and the minimal view keeps it live:

```swift
struct DeliveryLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DeliveryAttributes.self) { context in
            DeliveryLockScreenView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Label(context.attributes.restaurant, systemImage: "bag")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(timerInterval: context.state.arrival, countsDown: true)
                        .monospacedDigit()
                }
                DynamicIslandExpandedRegion(.bottom) {
                    ProgressView(timerInterval: context.state.arrival, countsDown: false)
                }
            } compactLeading: {
                Image(systemName: "bag")
            } compactTrailing: {
                Text(timerInterval: context.state.arrival, countsDown: true)
                    .monospacedDigit()
            } minimal: {
                Text(timerInterval: context.state.arrival, countsDown: true)
                    .monospacedDigit()
            }
        }
        .supplementalActivityFamilies([.small])
    }
}
```

## The Lock Screen view

The Lock Screen view takes the 14pt margin and the height of its content. Apple Watch and CarPlay get the `.small` layout, and StandBy gets the full-screen one:

```swift
struct DeliveryLockScreenView: View {
    let context: ActivityViewContext<DeliveryAttributes>
    @Environment(\.activityFamily) private var family
    @Environment(\.isActivityFullscreen) private var isFullscreen

    var body: some View {
        if family == .small {
            DeliveryGlance(context: context)
        } else if isFullscreen {
            DeliveryStandBy(context: context)
        } else {
            DeliveryDetail(context: context)
                .padding(14)
        }
    }
}
```
