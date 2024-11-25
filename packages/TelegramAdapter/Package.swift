// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TelegramAdapter",
    platforms: [
        .macOS(.v15),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "TelegramAdapter",
            targets: ["TelegramAdapter"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/rxtech-lab/mock-telegram-server", from: "1.3.4"),
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.7.6"),
        .package(path: "../Common"),
        .package(path: "../TestKit"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "TelegramAdapter",
            dependencies: [
                .product(name: "MockTelegramKit", package: "mock-telegram-server"),
                .product(name: "TestKit", package: "TestKit"),
                .product(name: "Common", package: "Common"),
                .product(name: "SwiftSoup", package: "swiftsoup"),
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(
            name: "TelegramAdapterTests",
            dependencies: ["TelegramAdapter"]
        ),
    ]
)
