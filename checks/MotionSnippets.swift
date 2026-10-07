// MotionSnippets.swift
//
// Every Swift snippet from skills/motion, copied as written and wrapped so
// it compiles on its own. Everything sits inside `MotionCheck`, so this file
// can share a project with other snippet files. Press Command-B; nothing here
// needs to run. One deprecation warning is expected: the "Bad" `.animation(_:)`.

import SwiftUI

func rubberBand(_ overshoot: CGFloat, dimension: CGFloat, constant: CGFloat = 0.55) -> CGFloat {
    (overshoot * dimension * constant) / (dimension + constant * abs(overshoot))
}

enum MotionCheck {

    // MARK: - Stand-ins for the made-up types the snippets use

    struct Photo: Identifiable, Hashable {
        let id = UUID()
    }

    struct Card: Identifiable {
        let id = UUID()
    }

    enum Filter: CaseIterable, Identifiable {
        case all, unread, flagged
        var id: Self { self }
        var title: String {
            switch self {
            case .all: "All"
            case .unread: "Unread"
            case .flagged: "Flagged"
            }
        }
    }

    enum SaveState { case idle, saving, saved }

    struct PhotoThumbnail: View {
        let photo: Photo
        var body: some View { Rectangle().frame(width: 100, height: 100) }
    }

    struct PhotoDetail: View {
        let photo: Photo
        var body: some View { Rectangle() }
    }

    struct Chevron: View {
        var body: some View { Image(systemName: "chevron.forward") }
    }

    struct Banner: View {
        var body: some View { Text("Saved") }
    }

    struct OptionsPanel: View {
        var body: some View { Text("Options") }
    }

    struct Toast: View {
        var body: some View { Text("Copied") }
    }

    struct CardContent: View {
        var body: some View { RoundedRectangle(cornerRadius: 24).frame(height: 300) }
    }

    struct CardView: View {
        let card: Card
        var body: some View { RoundedRectangle(cornerRadius: 16).frame(width: 240, height: 160) }
    }

    struct CustomDial: View {
        @Binding var value: Double
        var body: some View { Circle().frame(width: 120, height: 120) }
    }

    struct SaveButton: View {
        let state: SaveState
        var body: some View { Text("Save") }
    }

    struct ArticleBody: View {
        var body: some View { Text("Article") }
    }

    // MARK: - springs-and-timing.md

    struct Scoping: View {
        @State private var isExpanded = false
        @State private var selection: Filter = .all
        @State private var isOpen = false
        @State private var hasFinishedOpening = false

        var body: some View {
            VStack {
                // Good: this view animates when this value changes
                Chevron()
                    .rotationEffect(.degrees(isExpanded ? 90 : 0))
                    .animation(.snappy, value: isExpanded)

                // Bad: every change to this view animates, including ones nobody meant to
                Chevron()
                    .rotationEffect(.degrees(isExpanded ? 90 : 0))
                    .animation(.snappy)
            }
        }

        func expand() {
            withAnimation(.smooth) {
                isExpanded.toggle()
            }
        }

        func select(_ filter: Filter) {
            // Good: only this change animates
            withAnimation(.snappy) {
                selection = filter
            }
        }

        func selectInstantly(_ newValue: Filter) {
            var transaction = Transaction()
            transaction.disablesAnimations = true
            withTransaction(transaction) {
                selection = newValue
            }
        }

        func open() {
            withAnimation(.smooth) {
                isOpen = true
            } completion: {
                hasFinishedOpening = true
            }
        }
    }

    // MARK: - transitions.md

    struct PhotoGrid: View {
        @Namespace private var namespace
        let photos: [Photo]

        var body: some View {
            NavigationStack {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                        ForEach(photos) { photo in
                            NavigationLink(value: photo) {
                                PhotoThumbnail(photo: photo)
                                    .matchedTransitionSource(id: photo.id, in: namespace)
                            }
                        }
                    }
                }
                .navigationDestination(for: Photo.self) { photo in
                    PhotoDetail(photo: photo)
                        .navigationTransition(.zoom(sourceID: photo.id, in: namespace))
                }
            }
        }
    }

    struct InsertionAndRemoval: View {
        @State private var isShowingBanner = false
        @State private var isShowingOptions = false
        @State private var isShowingToast = false

        var body: some View {
            VStack {
                if isShowingBanner {
                    Banner()
                        .transition(.move(edge: .top).combined(with: .opacity))
                }

                if isShowingOptions {
                    OptionsPanel()
                        .transition(.scale(0.9, anchor: .topTrailing).combined(with: .opacity))
                }

                if isShowingToast {
                    Toast()
                        .transition(.asymmetric(
                            insertion: AnyTransition.move(edge: .bottom).combined(with: .opacity),
                            removal: AnyTransition.opacity.animation(.easeOut(duration: 0.15))
                        ))
                }

                Button("Show banner") {
                    // Elsewhere
                    withAnimation(.smooth) {
                        isShowingBanner = true
                    }
                }
            }
        }
    }

    struct FilterBar: View {
        @Namespace private var namespace
        @State private var selection: Filter = .all

        var body: some View {
            HStack {
                ForEach(Filter.allCases) { filter in
                    Button(filter.title) {
                        withAnimation(.snappy) { selection = filter }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background {
                        if selection == filter {
                            Capsule()
                                .fill(Color.secondary.opacity(0.2))
                                .matchedGeometryEffect(id: "selection", in: namespace)
                        }
                    }
                }
            }
        }
    }

    struct ContinuityAndSymbols: View {
        @State private var score = 0
        @State private var notificationCount = 0
        @State private var isConnecting = false
        @State private var isPlaying = false

        var body: some View {
            VStack {
                Text(score, format: .number)
                    .monospacedDigit()
                    .contentTransition(.numericText(value: Double(score)))
                    .animation(.snappy, value: score)

                Image(systemName: "bell")
                    .symbolEffect(.bounce, value: notificationCount)

                Image(systemName: "wifi")
                    .symbolEffect(.variableColor.iterative, isActive: isConnecting)

                Button {
                    withAnimation { isPlaying.toggle() }
                } label: {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .contentTransition(.symbolEffect(.replace))
                }
                .accessibilityLabel(isPlaying ? "Pause" : "Play")
            }
        }
    }

    struct PressableStyle: ButtonStyle {
        @Environment(\.isEnabled) private var isEnabled

        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .scaleEffect(configuration.isPressed && isEnabled ? 0.97 : 1)
                .animation(.snappy(duration: 0.15), value: configuration.isPressed)
        }
    }

    struct OnboardingPage: View {
        @Environment(\.accessibilityReduceMotion) private var reduceMotion
        @State private var isVisible = false
        let lines: [String]

        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(Array(lines.enumerated()), id: \.offset) { index, line in
                    Text(line)
                        .opacity(isVisible ? 1 : 0)
                        .offset(y: isVisible || reduceMotion ? 0 : 12)
                        .animation(.smooth.delay(Double(index) * 0.05), value: isVisible)
                }
            }
            .onAppear { isVisible = true }
        }
    }

    // MARK: - gestures.md

    struct DraggableCard: View {
        let restingPoints: [CGFloat] = [0, 400]
        @State private var offset: CGFloat = 0
        @State private var offsetAtGrab: CGFloat?

        var body: some View {
            CardContent()
                .offset(y: offset)
                .gesture(
                    DragGesture(minimumDistance: 10)
                        .onChanged { value in
                            let start = offsetAtGrab ?? offset
                            offsetAtGrab = start
                            offset = start + value.translation.height
                        }
                        .onEnded { value in
                            let start = offsetAtGrab ?? offset
                            offsetAtGrab = nil
                            let projected = start + value.predictedEndTranslation.height
                            let target = restingPoints.min {
                                abs($0 - projected) < abs($1 - projected)
                            } ?? 0
                            let remaining = target - offset
                            let relativeVelocity = remaining == 0 ? 0 : value.velocity.height / remaining
                            withAnimation(.interpolatingSpring(
                                duration: 0.4, bounce: 0.2, initialVelocity: relativeVelocity
                            )) {
                                offset = target
                            }
                        }
                )
        }
    }

    struct HoldToDelete: View {
        let onDelete: () -> Void
        @State private var isHolding = false

        var body: some View {
            Label("Hold to Delete", systemImage: "trash")
                .padding()
                .background {
                    GeometryReader { proxy in
                        Rectangle()
                            .fill(Color.red.opacity(0.25))
                            .frame(width: isHolding ? proxy.size.width : 0)
                            .animation(isHolding ? .linear(duration: 1.5) : .easeOut(duration: 0.2), value: isHolding)
                    }
                }
                .onLongPressGesture(minimumDuration: 1.5) {
                    onDelete()
                } onPressingChanged: { pressing in
                    isHolding = pressing
                }
                .accessibilityAddTraits(.isButton)
                .accessibilityAction(named: "Delete", onDelete)
        }
    }

    // MARK: - haptics.md

    struct Haptics: View {
        @State private var temperature = 20.0
        @State private var saveState: SaveState = .idle

        var body: some View {
            VStack {
                CustomDial(value: $temperature)
                    .sensoryFeedback(.selection, trigger: temperature)

                SaveButton(state: saveState)
                    .sensoryFeedback(.success, trigger: saveState) { _, newState in
                        newState == .saved
                    }
            }
        }
    }

    // MARK: - performance.md

    struct ScrollEffects: View {
        let cards: [Card]
        @State private var isPastHeader = false

        var body: some View {
            VStack {
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(cards) { card in
                            CardView(card: card)
                                .scrollTransition { content, phase in
                                    content
                                        .opacity(phase.isIdentity ? 1 : 0.6)
                                        .scaleEffect(phase.isIdentity ? 1 : 0.92)
                                }
                        }
                    }
                }

                ScrollView {
                    ArticleBody()
                }
                .onScrollGeometryChange(for: Bool.self) { geometry in
                    geometry.contentOffset.y > 120
                } action: { _, isPast in
                    isPastHeader = isPast
                }
            }
        }
    }
}
