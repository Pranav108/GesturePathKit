
// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "GesturePathKit",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "GesturePathKit",
            targets: ["GesturePathKit"]
        )
    ],
    targets: [
        .target(
            name: "GesturePathKit",
            path: "GesturePathKit",
            exclude: ["GesturePathKit.docc"]
        )
    ]
)
