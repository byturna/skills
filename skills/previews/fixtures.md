# Fixtures

How each kind of view takes its fixture, the previews file and the catalog of worst-case values.

## Through the initializer

A view that takes its data as parameters takes the fixture the same way. Fixtures live in an extension on the model, and the previews render the view in the `NavigationStack` it gets in production:

```swift
#if DEBUG
extension Member {
    static let typical: [Member] = [
        Member(name: "Maya Chen", email: "maya.chen@example.com", role: "Designer"),
        Member(name: "Luis Ortega", email: "luis@example.com", role: "Engineer"),
        Member(name: "Priya Raman", email: "priya.raman@example.com", role: "Product Manager"),
    ]

    // Each row breaks something different, as real data does
    static let worstCase: [Member] = [
        Member(name: "Aleksandra Wiśniewska-Kowalczyk", email: "aleksandra.wisniewska@northwind-industries-holdings.example.com", role: "Senior Product Design Engineer, Platform Infrastructure"),
        Member(name: "Jo", email: "jo@example.com", role: nil),
        Member(name: "Đặng Thị Ngọc Hân", email: "hann@example.com", role: "Engineer"),
        Member(name: "نور الهدى عبد الرحمن", email: "nour@example.com", role: "Support"),
    ]
}

#Preview("Typical") {
    NavigationStack {
        MemberList(members: Member.typical)
    }
}

#Preview("Empty") {
    NavigationStack {
        MemberList(members: [])
    }
}

#Preview("Worst case") {
    NavigationStack {
        MemberList(members: Member.worstCase)
    }
}

#Preview("Worst case, AX5") {
    NavigationStack {
        MemberList(members: Member.worstCase)
    }
    .dynamicTypeSize(.accessibility5)
}

#Preview("Worst case, right to left") {
    NavigationStack {
        MemberList(members: Member.worstCase)
    }
    .environment(\.layoutDirection, .rightToLeft)
    .environment(\.locale, Locale(identifier: "ar"))
}
#endif
```

## Through an observable model

A view that reads an `@Observable` model from the environment takes a model built in the state the preview names:

```swift
#Preview("Loading") {
    InboxView()
        .environment(InboxModel(state: .loading))
}

#Preview("Error") {
    InboxView()
        .environment(InboxModel(state: .failed(.offline)))
}
```

The loading model never finishes, so the state holds still.

## Through a shared context

Where setup is expensive or shared across previews, such as a SwiftData store, build it once in a `PreviewModifier`:

```swift
struct SampleTrips: PreviewModifier {
    static func makeSharedContext() throws -> ModelContainer {
        let container = try ModelContainer(
            for: Trip.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        for trip in Trip.worstCase {
            container.mainContext.insert(trip)
        }
        return container
    }

    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
}

#Preview("Worst case", traits: .modifier(SampleTrips())) {
    TripList()
}
```

## Through a binding

A view that edits a binding takes one from `@Previewable`, so the preview stays interactive:

```swift
#Preview("Long name, editing") {
    @Previewable @State var name = "Aleksandra Wiśniewska-Kowalczyk"
    NameField(name: $name)
}
```

## Worst-case values

Each value is one a real person could produce. Where the model, the server or a field sets a limit, use the limit. Where nothing does, use a long but believable value and say in the list that the field is unbounded. Emails and links use `example.com`, so a fixture never points at a real inbox.

**Names**

| Value | Catches |
| --- | --- |
| `Aleksandra Wiśniewska-Kowalczyk` | Long, hyphenated, accented; wraps to two lines |
| `Christopher Alexander Montgomery III` | A suffix that breaks naive initials |
| `Jo`, `J` | A name column left mostly empty |
| `Đặng Thị Ngọc Hân` | Stacked diacritics clipped by a tight row |
| `王秀英` | No spaces, so initials from words find one word |
| `نور الهدى عبد الرحمن` | Right-to-left text and its punctuation |
| `María José de la Cruz y Fernández` | Lowercase particles in initials and sorting |
| `👩🏽‍💻 Priya` | An emoji sequence first |
| No name, only an email | The fallback when a name is missing |

**Emails, links and identifiers**

| Value | Catches |
| --- | --- |
| `bartholomew.fitzgerald@northwind-industries-holdings.example.com` | A string with nowhere to wrap pushing its neighbors off the row |
| `a@b.co` | A layout that assumed a long value looks empty |
| `first.last+billing-notifications@example.com` | Plus addressing, and truncation hiding the meaningful part |
| `https://example.com/workspaces/acme/projects/q3-launch/docs/9f8e7d6c5b4a?tab=comments` | A long link where the end is what differs |
| `9f8e7d6c-5b4a-4c3d-8e2f-1a0b9c8d7e6f` | An identifier wider than its column |
| `Q3 Board Deck FINAL (revised) v12.pdf` | A file name where end truncation hides the version |
| `IMG_20250914_183022_HDR_portrait_edited.HEIC` | A camera file name with no spaces |

**Text from data**

| Value | Catches |
| --- | --- |
| `Senior Product Design Engineer, Platform Infrastructure` | A secondary line that wraps to three |
| `Invitation expired 12 days ago` | A status badge that squeezes the name |
| `Benachrichtigungseinstellungen` | A German compound with nowhere to wrap |
| Twelve tags on one item | A tag row that wraps into a wall |
| An empty title, or one of only spaces | A collapsed heading or row |
| A newline inside a one-line field | A row that doubles in height |
| A 2,000-character pasted description | Clamping and a way to read the rest |

**Numbers and money**

| Value | Catches |
| --- | --- |
| `0` and `1` | Zero states and plurals |
| `1284` and `1000000` | Grouping separators and badge width |
| `12345678.9` as a currency amount | Totals that overflow their column |
| `-42.5` | The negative sign and the color logic around it |
| `142%` and `-3%` | Meters and progress past their bounds |
| A missing value | A literal "nil", or a gap where the value was |
| A value that updates, `99` to `100` | Width jumps as the digits change |

**Collections**

| Value | Catches |
| --- | --- |
| Exactly one page, and one page plus one | Off-by-one counts and an empty next page |
| 1,000 items with no paging | Scrolling, memory and the count's wording |
| One item ten times the size of the rest | Rows and cells stretched to the tallest |
| Items with identical names | Lists where the name is the only difference |

**Time**

| Value | Catches |
| --- | --- |
| Now | "0 seconds ago" in place of "Now" |
| 12 days, 11 months and 3 years ago | Relative dates that should switch to absolute |
| A date in the future | Wording built only for the past |
| 11:30 PM in another time zone | A different day than the person's own |
| A duration of 1,284 hours | A duration that never rolls up into days |

**States**

| Value | Catches |
| --- | --- |
| Partly filled optional fields in one list | Misaligned rows |
| Every status at once | Badges of different widths side by side |
| No permission | Disabled actions, and whether the row keeps its layout |
| The current person in the list | "You" labels and actions that should not apply to yourself |
