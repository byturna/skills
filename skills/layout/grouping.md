# Grouping

Recipes for grouping, telling controls from content, alignment, order and the prominent action.

## Space, shape, lines

```swift
// Good: space alone carries the grouping
VStack(alignment: .leading, spacing: 24) {
    VStack(alignment: .leading, spacing: 8) {
        Text("Shipping")
            .font(.headline)
        Text(order.address)
    }
    VStack(alignment: .leading, spacing: 8) {
        Text("Payment")
            .font(.headline)
        Text(order.paymentSummary)
    }
}
.padding()

// Bad: even spacing, with dividers making up the difference
VStack(alignment: .leading, spacing: 12) {
    Text("Shipping")
        .font(.headline)
    Text(order.address)
    Divider()
    Text("Payment")
        .font(.headline)
    Text(order.paymentSummary)
}
```

The 24 and 8 are starting points for a project with no spacing scale. A form of settings or details is a `Form`, whose sections group on their own:

```swift
Form {
    Section("Shipping") {
        LabeledContent("Address", value: order.address)
    }
    Section("Payment") {
        LabeledContent("Card", value: order.paymentSummary)
    }
}
```

## Controls and content

```swift
// Good: the action reads as a control
VStack(alignment: .leading, spacing: 8) {
    Text(trial.statusMessage)
    Button("Upgrade", action: upgrade)
        .buttonStyle(.bordered)
}

// Bad: an action that looks like the sentence it sits in
Text(trial.statusMessage + " Upgrade now")
    .onTapGesture(perform: upgrade)
```

The reverse misleads too. A static badge drawn like the buttons beside it collects taps that do nothing.

## Alignment

```swift
// Mixed sizes share a baseline
HStack(alignment: .firstTextBaseline) {
    Text(item.name)
        .font(.headline)
    Spacer()
    Text(item.price, format: .currency(code: item.currencyCode))
        .font(.subheadline)
}

// Label and value columns line up across rows
Grid(alignment: .leading, verticalSpacing: 8) {
    GridRow {
        Text("Distance")
        Text(run.distance)
            .gridColumnAlignment(.trailing)
    }
    GridRow {
        Text("Pace")
        Text(run.pace)
    }
}
```

Typical stray edges are an icon a point off the text edge, a card padded unlike its neighbor and a header with its own leading inset.

## Order

```swift
// Good: the balance first, its label after
VStack(alignment: .leading, spacing: 4) {
    Text(account.balance, format: .currency(code: account.currencyCode))
        .font(.largeTitle.bold())
    Text("Available Balance")
        .font(.subheadline)
        .foregroundStyle(.secondary)
}
```

Secondary detail moves into a collapsed section or a detail view rather than sitting above the number people came for.

## Actions

```swift
VStack(spacing: 12) {
    Button(action: placeOrder) {
        Text("Place Order")
            .frame(maxWidth: .infinity)
    }
    .buttonStyle(.borderedProminent)
    .controlSize(.large)

    Button("Save for Later", action: saveForLater)
}

Menu("More", systemImage: "ellipsis") {
    Button("Duplicate", systemImage: "plus.square.on.square", action: duplicate)
    Button("Move to", systemImage: "folder", action: move)
    Button("Export", systemImage: "square.and.arrow.up", action: export)
}
```
