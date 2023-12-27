// swift-tools-version: 5.7.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NVMKit",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v4)
    ],
    products: [
        .library(
            name: "NVMKit",
            targets: ["NVMKit"]),
    ],
    targets: [
        .target(
            name: "NVMKit",
            dependencies: []),
        .testTarget(
            name: "NVMKitTests",
            dependencies: ["NVMKit"]),
    ]
)
