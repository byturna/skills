# Forms

Field labels, AutoFill content types, keyboards, errors and focus. Error wording belongs to `writing`.

## Labels

A `TextField`'s title is its VoiceOver label and its Voice Control name. In a `Form`, the title also shows as the placeholder:

```swift
Form {
    TextField("Name", text: $name)
    TextField("Email", text: $email)
}
```

That is the native pattern, as in Contacts and Settings. Once a field is filled, its title disappears from view, so use `LabeledContent` where people must tell filled fields apart, such as an edit screen:

```swift
LabeledContent("Email") {
    TextField("Email", text: $email, prompt: Text("name@example.com"))
}
```

Toggles, pickers and steppers take their label from their title. Never put a `Text` beside a control whose own title is empty, because VoiceOver then reads two elements and an unnamed control.

## Content and keyboard types

Every field about the user takes a `.textContentType`, so AutoFill, password managers and one-time codes work:

| Field | `.textContentType` | `.keyboardType` |
| --- | --- | --- |
| Name | `.name`, or `.givenName` and `.familyName` | Default |
| Email | `.emailAddress` | `.emailAddress` |
| Phone | `.telephoneNumber` | `.phonePad` |
| Street address | `.fullStreetAddress` | Default |
| Postal code | `.postalCode` | Default, since many codes contain letters |
| Sign-in username | `.username` | `.emailAddress` when it is an email |
| Existing password | `.password` in a `SecureField` | Default |
| New password | `.newPassword` in a `SecureField` | Default |
| One-time code | `.oneTimeCode` | `.numberPad` |
| Card number | `.creditCardNumber` | `.numberPad` |
| Amount | None | `.decimalPad` |

Usernames, emails and codes also take `.textInputAutocapitalization(.never)` and `.autocorrectionDisabled()`. Set `.submitLabel` so the return key says what it does, `.next` between fields and `.done`, `.go` or `.send` on the last.

Password AutoFill for your own domain also needs the `webcredentials:` associated domain.

## Input

- Never block paste. People paste passwords and codes.
- Never reject or strip characters as the user types. Accept the input and validate it after.
- Trim surrounding spaces before validating, since AutoFill and text replacement add them.
- A sheet holding unsaved input takes `.interactiveDismissDisabled(hasChanges)`, and its Cancel asks before discarding.

## Errors

Show each error as text directly after its field, where VoiceOver reads it next. In a `Form`, the section footer is that place:

```swift
Section {
    TextField("Email", text: $email)
        .textContentType(.emailAddress)
        .keyboardType(.emailAddress)
        .focused($focusedField, equals: .email)
} footer: {
    if let emailError {
        Text(emailError)
    }
}
```

On a failed submit, move focus to the first invalid field and announce what failed:

```swift
enum Field { case name, email }
@FocusState private var focusedField: Field?

func submit() {
    guard emailError == nil else {
        focusedField = .email
        AccessibilityNotification.Announcement("Check your email address").post()
        return
    }
    save()
}
```

Never mark an error with red alone; the text is the signal and the color adds to it.

## When the Done button may stay disabled

A toolbar Done, Add or Join may stay disabled while a required field is visibly empty. That is the pattern in Contacts, Calendar and the Wi-Fi join sheet:

```swift
.toolbar {
    ToolbarItem(placement: .confirmationAction) {
        Button("Add", action: save)
            .disabled(name.isEmpty)
    }
}
```

The condition must be one the user can see from the empty field. A rule they cannot see, such as a password length or an email format, keeps the button enabled and reports an inline error on submit.

## While the request runs

Keep the button's label and add a progress view beside it, so VoiceOver still names the busy button. Disable it or ignore repeat taps while the request runs; VoiceOver reads a disabled button as dimmed. Announce the result through the ladder in [voiceover.md](voiceover.md#announcements).
