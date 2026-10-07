# Contrast

Finding the background a color renders on, measuring the pair, fixing it on request and surfaces that change what sits behind them.

## Find the background

The background is whatever the foreground actually renders on, usually the nearest view that paints one. Text on a card measures against the card. Text in a sheet measures against the sheet, which uses the elevated colors in dark mode. Text on glass or a material measures against what shows through it.

## Measure

Measure each pair in four states: light and dark, each with Increase Contrast off and on. Which state must pass is `accessibility`'s rule.

With Xcode, Accessibility Inspector's Color Contrast Calculator measures two colors picked from the Simulator. In a test, resolve both colors in the environment the view renders in and compute the ratio:

```swift
extension Color.Resolved {
    var relativeLuminance: Double {
        0.2126 * Double(linearRed) + 0.7152 * Double(linearGreen) + 0.0722 * Double(linearBlue)
    }
}

func contrastRatio(_ first: Color.Resolved, _ second: Color.Resolved) -> Double {
    let lighter = max(first.relativeLuminance, second.relativeLuminance)
    let darker = min(first.relativeLuminance, second.relativeLuminance)
    return (lighter + 0.05) / (darker + 0.05)
}

func secondaryTextContrast(in environment: EnvironmentValues) -> Double {
    contrastRatio(
        Color(.secondaryLabel).resolve(in: environment),
        Color(.systemBackground).resolve(in: environment)
    )
}
```

Set `colorScheme` on the environment to measure each appearance. A foreground with opacity composites over its background before it is measured, so measure the color that shows. The HIG asks custom pairs to strive for 7:1, especially for small text. A pair between the threshold and 7:1 is a recommendation, never a finding.

## Fix on request

Report a failing pair and leave its colors alone, since they are a design decision. When asked to fix it:

1. Move the foreground's lightness away from the background, holding its hue and vividness.
2. Reduce vividness only where the lighter or darker value leaves the color space.
3. Remeasure in all four states.

A background near the middle of the lightness range caps what any text can reach on it, so the background is what changes there.

## Translucent surfaces

A material or Liquid Glass shows whatever scrolls beneath it, so one measurement does not describe it. Measure against the lightest and the darkest content it can sit over. Measure the resting state too, such as the top of a scrolled list, where colorful content must not sit behind a control.

Text over a photo has no single background. Measure its worst region, or add a scrim and measure against that.
