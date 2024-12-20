// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TestKit",
    platforms: [
        .macOS(.v15),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "TestKit",
            targets: ["TestKit"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/nalexn/ViewInspector.git", from: "0.10.0"),
        .package(url: "https://github.com/SwiftGen/StencilSwiftKit.git", from: "2.10.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "TestKit",
            dependencies: [.product(name: "StencilSwiftKit", package: "stencilswiftkit")]
        ),
        .testTarget(
            name: "TestKitTests",
            dependencies: ["TestKit",
                           .product(name: "ViewInspector", package: "viewinspector")],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
    ]
)
