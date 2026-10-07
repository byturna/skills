// BuildDesignSnippets.swift
//
// The Swift snippet from skills/build-design, copied as written, plus one use
// of every API the mapping tables and the cheat sheet name. Everything sits
// inside `BuildDesignCheck`, so this file can share a project with the other
// snippet files. Press Command-B; nothing here needs to run.

import SwiftUI
import UIKit

enum BuildDesignCheck {

    // MARK: - Stand-ins for the made-up types the snippets use

    struct Run {
        let title = "Morning Run"
        let summary = "5.2 km · 28 min"
    }

    // MARK: - mapping.md: a translated frame

    struct RunCard: View {
        let run = Run()

        var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                Text(run.title)
                    .font(.headline)
                Text(run.summary)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.secondarySystemGroupedBackground), in: .rect(cornerRadius: 16))
        }
    }

    // MARK: - mapping.md: text and layout

    struct TextAndLayout: View {
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text("Large Title").font(.largeTitle)
                Text("Large Title, emphasized").font(.largeTitle).bold()
                Text("Title").font(.title)
                Text("Title 2").font(.title2)
                Text("Title 3").font(.title3)
                Text("Headline").font(.headline)
                Text("Body").font(.body)
                Text("Body, medium").font(.body).fontWeight(.medium)
                Text("Callout").font(.callout)
                Text("Subheadline").font(.subheadline)
                Text("Footnote").font(.footnote)
                Text("Caption").font(.caption)
                Text("Caption 2").font(.caption2)
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "figure.run")
                        .frame(width: 28, height: 28)
                    Text("Fills the container")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .overlay(alignment: .topTrailing) {
                    Image(systemName: "star.fill")
                }
            }
            .padding()
        }
    }

    // MARK: - mapping.md: system components

    struct SystemComponents: View {
        @State private var isOn = true
        @State private var segment = 0
        @State private var volume = 0.5
        @State private var count = 1
        @State private var query = ""
        @State private var date = Date.now
        @State private var name = ""
        @State private var isShowingSheet = false
        @State private var isShowingAlert = false
        @State private var isShowingDialog = false

        var body: some View {
            TabView {
                Tab("Activity", systemImage: "figure.run") {
                    NavigationStack {
                        List {
                            Section("Settings") {
                                Toggle("Auto-Pause", isOn: $isOn)
                                Picker("Units", selection: $segment) {
                                    Text("Kilometers").tag(0)
                                    Text("Miles").tag(1)
                                }
                                .pickerStyle(.segmented)
                                Slider(value: $volume)
                                Stepper("Laps: \(count)", value: $count)
                                DatePicker("Start", selection: $date)
                                TextField("Name", text: $name)
                                ProgressView(value: 0.4)
                                ProgressView()
                            }
                            Section {
                                Button("Start") {}.buttonStyle(.glass)
                                Button("Save") {}.buttonStyle(.glassProminent)
                                Button("Share") {}.buttonStyle(.borderedProminent)
                                Button("Edit") {}.buttonStyle(.bordered)
                                Button("Details") {}.buttonStyle(.borderless)
                                Menu("Sort") { Button("Date") {} }
                                Text("Run")
                                    .contextMenu { Button("Delete", role: .destructive) {} }
                            }
                        }
                        .navigationTitle("Activity")
                        .toolbar {
                            Button("Add", systemImage: "plus") { isShowingSheet = true }
                        }
                        .searchable(text: $query, placement: .automatic, prompt: Text("Search runs"))
                        .sheet(isPresented: $isShowingSheet) {
                            Form { Text("New Run") }
                                .presentationDetents([.medium, .large])
                        }
                        .alert("Couldn't Save Run", isPresented: $isShowingAlert) {
                            Button("OK") {}
                        }
                        .confirmationDialog("Delete this run?", isPresented: $isShowingDialog) {
                            Button("Delete Run", role: .destructive) {}
                        }
                    }
                }
                Tab("Onboarding", systemImage: "sparkles") {
                    TabView {
                        Text("Page 1")
                        Text("Page 2")
                    }
                    .tabViewStyle(.page)
                }
            }
        }
    }

    // MARK: - cheat-sheet.md: UIKit

    @MainActor
    static func uikit() {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .secondaryLabel

        let card = UIView()
        card.backgroundColor = .secondarySystemGroupedBackground
        card.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        _ = card.layoutMarginsGuide

        let stack = UIStackView(arrangedSubviews: [label])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 4

        _ = UIImage(systemName: "figure.run")

        let tabs = UITabBarController()
        tabs.tabs = [UITab(title: "Activity", image: UIImage(systemName: "figure.run"), identifier: "activity")]
        _ = UINavigationController(rootViewController: UIViewController())

        let listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        _ = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout.list(using: listConfiguration))

        _ = UISwitch()
        _ = UISegmentedControl(items: ["Kilometers", "Miles"])
        _ = UISlider()
        _ = UIStepper()
        _ = UISearchController()
        _ = UIPageControl()
        _ = UIProgressView()
        _ = UIActivityIndicatorView()
        _ = UIDatePicker()
        _ = UITextField()

        _ = UIButton(configuration: .glass())
        _ = UIButton(configuration: .prominentGlass())
        _ = UIButton(configuration: .filled())
        _ = UIButton(configuration: .tinted())
        _ = UIButton(configuration: .plain())

        let menuButton = UIButton(configuration: .plain())
        menuButton.menu = UIMenu(children: [UIAction(title: "Date") { _ in }])
        menuButton.showsMenuAsPrimaryAction = true

        let sheet = UIViewController()
        sheet.sheetPresentationController?.detents = [.medium(), .large()]

        _ = UIAlertController(title: "Couldn't Save Run", message: nil, preferredStyle: .alert)
        _ = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    }
}
