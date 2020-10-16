// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Steps",
    platforms: [
        .macOS(.v10_15), .iOS(.v14), .tvOS(.v14),
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "Steps",
            targets: ["Steps"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/stevensiht/SwifterSwiftUI.git", .revision("bb740b48a299f9b5d4c0e2e6e4b614771fd013fc")),
        .package(url: "https://github.com/nalexn/ViewInspector", .upToNextMajor(from: "0.3.12")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Steps",
            dependencies: ["SwifterSwiftUI"]),
        .testTarget(
            name: "StepsTests",
            dependencies: ["Steps", "ViewInspector"]),
    ]
)
