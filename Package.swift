// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Utils",
    platforms: [.iOS(.v16), .macCatalyst(.v15), .watchOS(.v8), .macOS(.v12)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Utils",
            targets: ["Utils"]
        ),
        .library(
            name: "DeepLink",
            targets: ["DeepLink"]
        ),
        .library(
            name: "FileSystem",
            targets: ["FileSystem"]
        ),
        .library(
            name: "Audio",
            targets: ["Audio"]
        ),
        .library(
            name: "HapticFeedback",
            targets: ["HapticFeedback"]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Utils"
        ),
        .target(
            name: "DeepLink"
        ),
        .target(
            name: "FileSystem"
        ),
        .target(
            name: "Audio",
            dependencies: ["FileSystem"]
        ),
        .target(
            name: "HapticFeedback"
        ),
        .testTarget(
            name: "UtilsTests",
            dependencies: ["Utils"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
