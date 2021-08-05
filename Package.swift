// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Swifties",
    products: [
        .library(
            name: "Swifties",
            targets: ["Swifties"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Swifties",
            dependencies: []),
        .testTarget(
            name: "SwiftiesTests",
            dependencies: ["Swifties"]),
    ]
)
