// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Swifties",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Swifties",
            targets: ["Swifties"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(
          url: "https://github.com/apple/swift-atomics.git",
          from: "0.0.1"
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Swifties",
            dependencies: [.product(name: "Atomics", package: "swift-atomics")]),
        .testTarget(
            name: "SwiftiesTests",
            dependencies: ["Swifties"]),
    ]
)
