// ColorSnippets.swift
//
// Every Swift snippet from skills/color, copied as written and wrapped so it
// compiles on its own, plus one line for each API the prose names. Everything
// sits inside `ColorCheck`, so this file can share a project with the other
// snippet files. Press Command-B; nothing here needs to run.
//
// The skill reads color sets through Xcode's generated symbols, such as
// `Color(.categoryTravel)`. This project has no such color sets, so the
// `ColorResource` extension at the bottom stands in for what Xcode would
// generate. At run time those colors are missing, which does not matter here.

import SwiftUI
import DeveloperToolsSupport

enum ColorCheck {

    // MARK: - Stand-ins for the made-up types the snippets use

    struct Order {
        let title = "Order 1042"
        let status = "Shipped"
    }
    struct Category {}
    struct CategoryBadge: View {
        let category: Category
        var body: some View { Text("Travel").padding(.horizontal, 8) }
    }
    struct SettingsSection: View {
        var body: some View { Text("Settings") }
    }

    // MARK: - system-colors.md

    struct SystemColors: View {
        let order = Order()

        var body: some View {
            VStack {
                // Good: system colors carry dark, elevated and high-contrast variants
                VStack(alignment: .leading, spacing: 4) {
                    Text(order.title)
                        .foregroundStyle(.primary)
                    Text(order.status)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground), in: .rect(cornerRadius: 16))

                // Bad: fixed values that never adapt
                VStack(alignment: .leading, spacing: 4) {
                    Text(order.title)
                        .foregroundStyle(Color.black)
                    Text(order.status)
                        .foregroundStyle(Color.gray)
                }
                .padding()
                .background(Color.white, in: .rect(cornerRadius: 16))

                SettingsSection()
                    .tint(Color(.partnerAccent))

                roles
            }
        }

        var roles: some View {
            VStack {
                Text("Tertiary").foregroundStyle(.tertiary)
                Text("Quaternary").foregroundStyle(.quaternary)
                Text("Placeholder").foregroundStyle(.placeholder)
                Text("Link").foregroundStyle(.link)
                Rectangle().fill(.separator).frame(height: 1)
                Color(.systemBackground)
                Color(.tertiarySystemBackground)
                Color(.systemGroupedBackground)
                Color(.systemFill)
                Color(.quaternarySystemFill)
                Color(.systemGray)
                Color(.systemGray6)
                HStack {
                    Color.red
                    Color.orange
                    Color.yellow
                    Color.green
                    Color.mint
                    Color.teal
                    Color.cyan
                    Color.blue
                    Color.indigo
                    Color.purple
                    Color.pink
                    Color.brown
                }
            }
        }
    }

    // MARK: - palettes.md

    struct Palettes: View {
        let category = Category()

        var body: some View {
            VStack {
                // Good: a role color from the asset catalog, with every variant
                CategoryBadge(category: category)
                    .background(Color(.categoryTravel), in: .capsule)

                CategoryBadgeBackground()

                Rectangle()
                    .fill(Gradient(colors: [.blue, .pink]).colorSpace(.perceptual))

                Rectangle()
                    .fill(Color(.displayP3, red: 0.1, green: 0.8, blue: 0.4, opacity: 1))
            }
        }

        func derived() -> Color {
            let hover = Color(.accentFill).mix(with: .black, by: 0.1)
            return hover
        }
    }

    // Bad: one color branched by hand, with no high-contrast value
    struct CategoryBadgeBackground: View {
        @Environment(\.colorScheme) private var colorScheme

        var body: some View {
            Capsule()
                .fill(colorScheme == .dark
                    ? Color(red: 0.243, green: 0.784, blue: 0.784)
                    : Color(red: 0, green: 0.478, blue: 0.478))
        }
    }

    struct Settings: View {
        @Environment(\.colorSchemeContrast) private var colorSchemeContrast
        @State private var favorite = Color.blue

        var body: some View {
            VStack {
                Text(colorSchemeContrast == .increased ? "Increased" : "Standard")
                ColorPicker("Favorite Color", selection: $favorite)
                Button("Save") {}
                    .buttonStyle(.glassProminent)
                Text("Glass")
                    .padding()
                    .glassEffect(.regular.tint(Color(.brandAccent)))
                Text("Material")
                    .padding()
                    .background(.thinMaterial)
                    .foregroundStyle(.secondary)
            }
            .preferredColorScheme(nil)
        }
    }

    // MARK: - contrast.md

    static func darkContrast() -> Double {
        var environment = EnvironmentValues()
        environment.colorScheme = .dark
        return secondaryTextContrast(in: environment)
    }
}

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

// Stand-ins for the symbols Xcode generates from color sets.
extension ColorResource {
    static let categoryTravel = ColorResource(name: "CategoryTravel", bundle: .main)
    static let partnerAccent = ColorResource(name: "PartnerAccent", bundle: .main)
    static let accentFill = ColorResource(name: "AccentFill", bundle: .main)
    static let brandAccent = ColorResource(name: "BrandAccent", bundle: .main)
}
