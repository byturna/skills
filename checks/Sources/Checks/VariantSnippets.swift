// VariantSnippets.swift
//
// Every Swift snippet from skills/variant, copied as written. Everything sits
// inside `VariantCheck`, so this file can share a target with the other
// snippet files, and `#Preview` stays at file scope. Most of it is inside
// `#if DEBUG`, as the skill requires, so build with the Debug configuration.
// Press Command-B; nothing here needs to run.

import SwiftUI
import UIKit

enum VariantCheck {

    // MARK: - Stand-ins for the made-up types the snippets use

    struct Activity {
        let title = "Morning Run"
        let summary = "5.2 km · 28 min"
    }

    struct ActivityCard: View {
        let activity: Activity
        var body: some View { Text(activity.title) }
    }

    // MARK: - picker.md: the picker lives in DebugPicker.swift

    // MARK: - picker.md: hosting the variants

    #if DEBUG
    enum ActivityCardVariant: String, CaseIterable {
        case quiet, editorial, dense
    }

    struct QuietActivityCard: View {
        let activity: Activity
        var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                Text(activity.title).font(.headline)
                Text(activity.summary).font(.subheadline).foregroundStyle(.secondary)
            }
            .padding()
        }
    }

    struct EditorialActivityCard: View {
        let activity: Activity
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(activity.title).font(.largeTitle.bold())
                Text(activity.summary).font(.title3)
            }
            .padding()
        }
    }

    struct DenseActivityCard: View {
        let activity: Activity
        var body: some View {
            HStack {
                Text(activity.title).font(.subheadline.weight(.semibold))
                Spacer()
                Text(activity.summary).font(.footnote).foregroundStyle(.secondary)
            }
            .padding(.horizontal)
        }
    }
    #endif

    struct ActivityScreen: View {
        let activity: Activity

        #if DEBUG
        @AppStorage("__variant") private var variant = ActivityCardVariant.quiet
        #endif

        var body: some View {
            ScrollView {
                #if DEBUG
                switch variant {
                case .quiet:
                    QuietActivityCard(activity: activity)
                case .editorial:
                    EditorialActivityCard(activity: activity)
                case .dense:
                    DenseActivityCard(activity: activity)
                }
                #else
                ActivityCard(activity: activity)
                #endif
            }
            .navigationTitle("Activity")
            #if DEBUG
            .overlay(alignment: .bottom) {
                DebugPicker("Variants", selection: $variant)
            }
            #endif
        }
    }

    // MARK: - cheat-sheet.md: UIKit

    final class ActivityViewController: UIViewController {
        #if DEBUG
        func showVariant(_ variant: ActivityCardVariant) {}
        #endif
    }

    #if DEBUG
    struct HostedVariantPicker: View {
        @AppStorage("__variant") private var variant = ActivityCardVariant.quiet
        let onChange: (ActivityCardVariant) -> Void

        var body: some View {
            DebugPicker("Variants", selection: $variant)
                .onChange(of: variant, initial: true) { _, newValue in
                    onChange(newValue)
                }
        }
    }
    #endif
}

#if DEBUG
extension VariantCheck.ActivityViewController {
    func addVariantPicker() {
        let picker = UIHostingController(rootView: VariantCheck.HostedVariantPicker { [weak self] variant in
            self?.showVariant(variant)
        })
        picker.sizingOptions = .intrinsicContentSize
        picker.view.backgroundColor = .clear
        picker.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(picker)
        view.addSubview(picker.view)
        NSLayoutConstraint.activate([
            picker.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            picker.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            picker.view.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor),
        ])
        picker.didMove(toParent: self)
    }
}

// MARK: - SKILL.md: one preview per variant, in its real container

#Preview("Quiet") {
    NavigationStack {
        VariantCheck.QuietActivityCard(activity: VariantCheck.Activity())
    }
}

#Preview("Editorial") {
    NavigationStack {
        VariantCheck.EditorialActivityCard(activity: VariantCheck.Activity())
    }
}

#Preview("Picker over the screen") {
    NavigationStack {
        VariantCheck.ActivityScreen(activity: VariantCheck.Activity())
    }
}
#endif
