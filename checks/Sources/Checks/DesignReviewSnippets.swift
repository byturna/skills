// DesignReviewSnippets.swift
//
// The example row from skills/design-review/review-format.md and one use of
// every system API that platform.md and SKILL.md name. Everything sits inside
// `DesignReviewCheck`, so this file can share a target with the other snippet
// files. Press Command-B; nothing here needs to run.
//
// performAccessibilityAudit(for:_:) lives in XCTest, which only a test target
// can import, so it is not in this file. Its signature was checked against
// Apple's documentation instead.

import SwiftUI
import UIKit
import Charts
import PhotosUI
import TipKit
import CoreLocationUI
import AuthenticationServices
import UniformTypeIdentifiers

enum DesignReviewCheck {

    // MARK: - review-format.md

    struct PlayerControls: View {
        var body: some View {
            VStack {
                // Before
                Button(action: close) { Image(systemName: "xmark") }

                // After
                Button("Close", systemImage: "xmark", action: close).labelStyle(.iconOnly)
            }
        }

        func close() {}
    }

    // MARK: - platform.md

    struct SampleTip: Tip {
        var title: Text { Text("Save Searches") }
    }

    struct Point: Identifiable {
        let id = UUID()
        let day: String
        let value: Double
    }

    struct Controls: View {
        @State private var isOn = false
        @State private var count = 1
        @State private var segment = 0
        @State private var date = Date.now
        @State private var color = Color.blue
        @State private var query = ""
        @State private var isShowingSheet = false
        @State private var isShowingInspector = false
        @State private var isImporting = false
        @State private var photo: PhotosPickerItem?
        let points = [Point(day: "Mon", value: 3), Point(day: "Tue", value: 5)]
        let tip = SampleTip()

        var body: some View {
            NavigationStack {
                Form {
                    Section { inputs }
                    Section { content }
                    Section { gestures }
                }
                .scrollDismissesKeyboard(.interactively)
                .refreshable {}
                .searchable(text: $query, placement: .automatic, prompt: Text("Search projects"))
                .toolbar {
                    EditButton()
                }
                .sheet(isPresented: $isShowingSheet) { Text("Sheet") }
                .inspector(isPresented: $isShowingInspector) { Text("Details") }
                .fileImporter(isPresented: $isImporting, allowedContentTypes: [.pdf], allowsMultipleSelection: false) { _ in }
            }
        }

        var inputs: some View {
            Group {
                Toggle("Wi-Fi", isOn: $isOn)
                Stepper("Copies: \(count)", value: $count, in: 1...10)
                Picker("View", selection: $segment) {
                    Text("Day").tag(0)
                    Text("Week").tag(1)
                }
                .pickerStyle(.segmented)
                DatePicker("Due", selection: $date)
                ProgressView(value: 0.4)
                Gauge(value: 0.7) { Text("Battery") }
                LabeledContent("Version", value: "2.1")
                ColorPicker("Tint", selection: $color)
            }
        }

        var content: some View {
            Group {
                Chart(points) { point in
                    BarMark(x: .value("Day", point.day), y: .value("Value", point.value))
                }
                ContentUnavailableView("No Projects", systemImage: "folder", description: Text("Projects keep your tasks and files together."))
                PhotosPicker("Choose Photo", selection: $photo, matching: .images)
                LocationButton(.currentLocation) {}
                PasteButton(payloadType: String.self) { _ in }
                SignInWithAppleButton(.signIn) { _ in } onCompletion: { _ in }
                ShareLink(item: URL(string: "https://example.com")!)
                TipView(tip)
            }
        }

        var gestures: some View {
            Group {
                Text("Filters")
                    .popoverTip(tip, arrowEdge: .top) { _ in }
                Text("Row")
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button("Delete", role: .destructive) {}
                    }
                    .contextMenu {
                        Button("Copy") {}
                    }
                    .draggable("Row")
                    .dropDestination(for: String.self) { items, _ in
                        !items.isEmpty
                    } isTargeted: { _ in }
                Menu("Sort") {
                    Button("Name") {}
                }
            }
        }
    }

    struct Tabs: View {
        var body: some View {
            TabView {
                Tab("Library", systemImage: "books.vertical") {
                    Controls()
                }
            }
        }
    }
}
