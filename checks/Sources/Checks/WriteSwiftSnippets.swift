// WriteSwiftSnippets.swift
//
// Every Swift snippet from skills/write-swift, copied as written and wrapped so
// it compiles on its own, plus one use of each API the prose names where a use
// fits in a few lines. Everything sits inside `WriteSwiftCheck`, so this file
// can share a target with the other snippet files. Press Command-B; nothing
// here needs to run.
//
// The package defaults to main-actor isolation, so the stand-in types that the
// PhotoProcessor snippet and the concurrency APIs use are marked nonisolated.
// The two extract functions inside PhotoProcessor are stand-ins too.
//
// Swift Testing lives in a module only a test target can import, so @Test,
// #expect, #require, the traits, withKnownIssue and confirmation are not here.
// Their spellings were checked against Apple's documentation instead. The raw
// identifier compiles here on a plain function. assertMacroExpansion needs the
// swift-syntax package, and the Subprocess and Binary Parsing packages are
// separate dependencies, so those were checked against their sources.

import SwiftUI
import Observation
import Synchronization
import RegexBuilder
import os

enum WriteSwiftCheck {

    // MARK: Value types by default

    final class Texture {
        var color: Color

        init(color: Color) {
            self.color = color
        }

        init(copying other: Texture) {
            color = other.color
        }
    }

    struct Material {
        var roughness: Double
        private var _texture: Texture  // a class

        var color: Color {
            get { _texture.color }
            set {
                if !isKnownUniquelyReferenced(&_texture) { _texture = Texture(copying: _texture) }
                _texture.color = newValue
            }
        }
    }

    nonisolated struct FileDescriptor: ~Copyable {
        let rawValue: Int32

        consuming func close() {}

        deinit {}
    }

    static func read(_ file: borrowing FileDescriptor) -> Int32 {
        file.rawValue
    }

    static func finish(_ file: consuming FileDescriptor) {
        file.close()
    }

    static func reopen(_ file: inout FileDescriptor) {
        file = FileDescriptor(rawValue: 0)
    }

    // MARK: Make the failure paths visible

    enum FriendError: Error {
        case duplicateFriend(String)
    }

    static func add(_ friend: String, to friends: inout [String]) throws(FriendError) {
        guard !friends.contains(friend) else { throw .duplicateFriend(friend) }
        friends.append(friend)
    }

    static func element(at index: Int, in values: [Int]) -> Int {
        precondition(values.indices.contains(index), "Index \(index) is out of range")
        return values[index]
    }

    // MARK: Stay on the main actor until a profile says otherwise

    nonisolated struct Sticker {}

    nonisolated struct ProcessedPhoto {
        let sticker: Sticker
        let colors: [String]
    }

    nonisolated struct PhotoProcessor {
        @concurrent
        func process(_ data: Data) async -> ProcessedPhoto {
            async let sticker = extractSticker(data)
            async let colors = extractColors(data)
            return await ProcessedPhoto(sticker: sticker, colors: colors)
        }

        func extractSticker(_ data: Data) -> Sticker { Sticker() }
        func extractColors(_ data: Data) -> [String] { [] }
    }

    // MARK: Send values, not shared objects

    nonisolated final class HitCounter: Sendable {
        private let count = Mutex(0)
        private let total = Atomic<Int>(0)

        func record() {
            count.withLock { $0 += 1 }
            total.add(1, ordering: .relaxed)
        }
    }

    nonisolated final class LockedLog: @unchecked Sendable {
        private let lock = NSLock()
        private var lines: [String] = []

        func append(_ line: String) {
            lock.withLock { lines.append(line) }
        }
    }

    nonisolated(unsafe) static var legacyCounter = 0
    static var finishedCount = 0

    nonisolated static func delegateDidFinish() {
        MainActor.assumeIsolated {
            finishedCount += 1
        }
    }

    // MARK: Structured tasks first, and concurrency.md

    nonisolated enum Tasks {
        @TaskLocal static var requestID: UUID?

        static func structured(_ urls: [URL]) async throws -> Int {
            try Task.checkCancellation()
            guard !Task.isCancelled else { return 0 }

            let total = await withTaskGroup(of: Int.self) { group in
                for url in urls.prefix(4) {
                    group.addTask { url.absoluteString.count }
                }
                var sum = 0
                for await count in group { sum += count }
                return sum
            }

            await withDiscardingTaskGroup { group in
                group.addTask {}
            }

            try await withThrowingDiscardingTaskGroup { group in
                group.addTask { try Task.checkCancellation() }
            }

            return total
        }

        static func bridged() async {
            let value: Int = await withCheckedContinuation { continuation in
                continuation.resume(returning: 1)
            }

            let stream = AsyncStream<Int> { continuation in
                continuation.yield(value)
                continuation.onTermination = { _ in }
                continuation.finish()
            }
            for await _ in stream {}

            await withTaskCancellationHandler {
                await Task.yield()
            } onCancel: {}

            await $requestID.withValue(UUID()) {
                _ = requestID
            }
        }

        static func detachedRoot() {
            Task.detached {
                await withDiscardingTaskGroup { group in
                    group.addTask {}
                }
            }
        }
    }

    // MARK: SwiftUI isolation

    struct PulsingBadge: View {
        @State private var pulse = false
        @State private var width: CGFloat = 0

        var body: some View {
            Text(verbatim: "3")
                .visualEffect { [pulse] effect, proxy in
                    effect.blur(radius: pulse ? 2 : 0)
                }
                .onGeometryChange(for: CGFloat.self) { proxy in
                    proxy.size.width
                } action: { newWidth in
                    width = newWidth
                }
                .onTapGesture {
                    withAnimation { pulse.toggle() }
                }
        }
    }

    // MARK: Logger, not print

    static let logger = Logger(subsystem: "com.example.app", category: "sync")

    static func log(_ requestID: UUID, count: Int) {
        logger.debug("Started \(requestID, privacy: .public)")
        logger.notice("Synced \(count, format: .decimal, align: .right(columns: 6)) items")
        logger.error("Failed for \(requestID, privacy: .private(mask: .hash))")
    }

    // MARK: modern-syntax.md

    @Observable
    final class Player {
        var position = 0.0
    }

    // The closure inherits the main actor from this function. Spelling it
    // `{ @MainActor in ... }` crashes the Swift 6.2.4 compiler in IRGen.
    static func follow(_ player: Player) async {
        let positions = Observations { player.position }
        for await position in positions {
            _ = position
            break
        }
    }

    static func messageTypes<M: NotificationCenter.MainActorMessage, A: NotificationCenter.AsyncMessage>(
        _ mainActorMessage: M.Type,
        _ asyncMessage: A.Type
    ) {}

    static func contiguous(_ numbers: [Int]) -> Int {
        var buffer: InlineArray<4, Int> = [1, 2, 3, 4]
        buffer[0] = numbers.count
        let span = numbers.span
        return span.count + span.bytes.byteCount + buffer[0]
    }

    static func overwriteFirst(_ numbers: inout [Int]) {
        var span = numbers.mutableSpan
        if !span.isEmpty { span[0] = 0 }
    }

    static func parsers() -> some RegexComponent {
        Regex {
            Capture(.date(.numeric, locale: Locale(identifier: "en_US"), timeZone: .gmt))
            " "
            Capture(.localizedCurrency(code: Locale.Currency("USD"), locale: Locale(identifier: "en_US")))
            NegativeLookahead { "x" }
            Local { OneOrMore(.digit) }
        }
    }

    static func `fruits have a tropical climate`() {}
}
