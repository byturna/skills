// TypographySnippets.swift
//
// Every Swift snippet from skills/typography, copied as written and wrapped
// so it compiles on its own, plus one line for each API the prose names.
// Everything sits inside `TypographyCheck`, so this file can share a target
// with the other snippet files. Press Command-B; nothing here needs to run.
//
// The BrandSans font names refer to files that are not in the project. That
// is fine: they compile, and at run time SwiftUI falls back to the system font.
//
// The skill's `extension View { func brandFont }` sits at the bottom, outside the
// namespace, because an extension cannot be declared inside an enum.

import SwiftUI

enum TypographyCheck {

    // MARK: - Stand-ins for the made-up types the snippets use

    struct Article {
        let title = "Title"
        let byline = "By someone"
        let summary = "Summary"
        let pullQuote = "Quote"
    }
    struct Stats { let headline = "42 runs" }
    struct Chapter { let text = "Once upon a time" }
    struct Order {
        let title = "Order"
        let number = "A-1042"
    }
    struct Attachment { let name = "Receipt.pdf" }
    struct AttachmentThumbnail: View {
        let attachment: Attachment
        var body: some View { Rectangle() }
    }
    struct LineItem {
        let price: Decimal = 12.5
        let currencyCode = "EUR"
    }
    struct File { let name = "Quarterly report final.pdf" }
    struct Album { let title = "Blue" }
    struct Product { let name = "Wireless Mouse" }
    struct Item { let details = "Details" }
    struct Review {
        let body = "Great"
        let isRightToLeft = false
    }
    struct Post {
        let text = "แอปเปิล"
        let language = Locale.Language(languageCode: .thai)
    }

    // MARK: - text-styles.md

    struct TextStyles: View {
        let article = Article()
        let stats = Stats()
        let chapter = Chapter()

        var body: some View {
            VStack {
                // Good: text styles carry size, weight and leading at every Dynamic Type size
                VStack(alignment: .leading, spacing: 4) {
                    Text(article.title)
                        .font(.title2)
                    Text(article.byline)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(article.summary)
                        .font(.body)
                }

                // Bad: fixed sizes that never scale
                Text(article.title)
                    .font(.system(size: 22, weight: .bold))

                Text(article.title)
                    .font(.title2.bold())

                Text(article.pullQuote)
                    .font(.title3)
                    .fontDesign(.serif)

                Text(stats.headline)
                    .font(.headline)
                    .fontWidth(.condensed)

                Text(chapter.text)
                    .font(.body.leading(.loose))

                Text(chapter.text)
                    .font(.footnote.leading(.tight))
                    .lineSpacing(10)

                Group {
                    Text("Styles")
                        .font(.largeTitle)
                    Text("Styles")
                        .font(.title)
                    Text("Styles")
                        .font(.callout)
                    Text("Styles")
                        .font(.caption)
                    Text("Styles")
                        .font(.caption2)
                        .fontDesign(.rounded)
                    Text("Styles")
                        .fontDesign(.monospaced)
                        .fontWeight(.semibold)
                        .bold()
                }
            }
        }
    }

    // MARK: - custom-fonts.md

    enum BrandTextStyle {
        case title, headline, body, caption

        var size: CGFloat {
            switch self {
            case .title: 28
            case .headline: 17
            case .body: 17
            case .caption: 12
            }
        }

        var relativeStyle: Font.TextStyle {
            switch self {
            case .title: .title
            case .headline: .headline
            case .body: .body
            case .caption: .caption
            }
        }

        func faceName(isBold: Bool) -> String {
            switch self {
            case .title, .headline: isBold ? "BrandSans-Bold" : "BrandSans-Semibold"
            case .body, .caption: isBold ? "BrandSans-Semibold" : "BrandSans-Regular"
            }
        }
    }

    struct BrandFont: ViewModifier {
        @Environment(\.legibilityWeight) private var legibilityWeight
        let style: BrandTextStyle

        func body(content: Content) -> some View {
            content.font(.custom(
                style.faceName(isBold: legibilityWeight == .bold),
                size: style.size,
                relativeTo: style.relativeStyle
            ))
        }
    }

    struct CustomFonts: View {
        let order = Order()
        let chapter = Chapter()
        @Environment(\.dynamicTypeSize) private var dynamicTypeSize

        var body: some View {
            VStack {
                // Good: one role, scaled like the style it stands in for
                Text(order.title)
                    .brandFont(.title)

                // Bad: scales with body, so the title grows at body's rate and outgrows .title at accessibility sizes
                Text(order.title)
                    .font(.custom("BrandSans-Semibold", size: 28))

                Text("Logotype")
                    .font(.custom("BrandSans-Bold", fixedSize: 20))

                Text(chapter.text)
                    .brandFont(.body)
                    .lineHeight(.loose)

                Text(chapter.text)
                    .lineHeight(.multiple(factor: 1.4))

                Text("TRACKED")
                    .brandFont(.caption)
                    .tracking(1)

                Text(dynamicTypeSize.isAccessibilitySize ? "Large" : "Standard")
            }
        }
    }

    struct AttachmentRow: View {
        @ScaledMetric(relativeTo: .body) private var thumbnailSize: CGFloat = 28
        let attachment: Attachment

        var body: some View {
            HStack {
                AttachmentThumbnail(attachment: attachment)
                    .frame(width: thumbnailSize, height: thumbnailSize)
                Text(attachment.name)
            }
        }
    }

    // MARK: - details.md

    struct Details: View {
        let line = LineItem()
        let elapsed = Duration.seconds(75)
        let file = File()
        let album = Album()
        let product = Product()
        let order = Order()

        var body: some View {
            VStack {
                // Good: every digit keeps one width, so the column stays aligned
                Text(line.price, format: .currency(code: line.currencyCode))
                    .monospacedDigit()

                // Good: a running timer does not jitter as its digits change
                Text(elapsed, format: .time(pattern: .minuteSecond))
                    .font(.title.monospacedDigit())

                // The end of a file name carries its extension, so truncate the middle
                Text(file.name)
                    .lineLimit(1)
                    .truncationMode(.middle)

                // Every card in the grid keeps two lines of height, whatever the title's length
                Text(album.title)
                    .lineLimit(2, reservesSpace: true)

                // Bad: shrinks text a person enlarged
                Text(product.name)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)

                // Stored in natural case, displayed in capitals
                Text("New")
                    .textCase(.uppercase)

                Text("Year in Review")
                    .font(.largeTitle.bold())
                    .foregroundStyle(Color.accentColor.gradient)

                Text(order.number)
                    .textSelection(.enabled)

                Text("\u{201C}Quoted\u{201D} it\u{2019}s 9\u{2013}5\u{2026} 10\u{00A0}km")
            }
        }
    }

    // MARK: - direction.md

    struct Direction: View {
        let item = Item()
        let review = Review()
        let file = File()
        let post = Post()

        var body: some View {
            VStack {
                // Good: leading follows the reading direction
                Text(item.details)
                    .multilineTextAlignment(.leading)

                // Bad: a centered paragraph is hard to scan in either direction
                Text(item.details)
                    .multilineTextAlignment(.center)

                Text(review.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .environment(\.layoutDirection, review.isRightToLeft ? .rightToLeft : .leftToRight)

                Text(verbatim: post.text)
                    .typesettingLanguage(post.language)

                isolated
            }
        }

        var isolated: some View {
            let isolatedName = "\u{2068}\(file.name)\u{2069}"
            return Text("Shared \(isolatedName) with you")
        }
    }
}

extension View {
    func brandFont(_ style: TypographyCheck.BrandTextStyle) -> some View {
        modifier(TypographyCheck.BrandFont(style: style))
    }
}
