// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Checks",
    platforms: [.iOS(.v26)],
    products: [
        .library(name: "Checks", targets: ["Checks"]),
    ],
    targets: [
        .target(
            name: "Checks",
            swiftSettings: [
                .defaultIsolation(MainActor.self),
                .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
                .enableUpcomingFeature("InferIsolatedConformances"),
            ]
        ),
    ]
)
