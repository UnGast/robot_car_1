// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "NvidiaJetsonGPIO",
    products: [
        .library(
            name: "NvidiaJetsonGPIO",
            targets: ["NvidiaJetsonGPIO"]),
        .executable(
            name: "Run",
            targets: ["Run"]
        )
    ],
    dependencies: [
        .package(name: "BaseGPIO", path: "../base_gpio"),
        .package(url: "https://github.com/mxcl/Path.swift.git", from: "1.2.0")
    ],
    targets: [
        .target(
            name: "NvidiaJetsonGPIO",
            dependencies: ["BaseGPIO", .product(name: "Path", package: "Path.swift")]),
        .target(
            name: "Run",
            dependencies: ["NvidiaJetsonGPIO"]
        ),
        .testTarget(
            name: "NvidiaJetsonGPIOTests",
            dependencies: ["NvidiaJetsonGPIO"]),
    ]
)
