// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Spot",
    products: [
        .library(name: "Spot", targets: ["Spot"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "Spot", dependencies: []),
        .testTarget(name: "SpotTests", dependencies: ["Spot"]),
    ],
    swiftLanguageVersions: [.v5]
)
