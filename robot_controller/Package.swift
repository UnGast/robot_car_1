// swift-tools-version:5.3
import PackageDescription

var package = Package(
    name: "RobotController",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(
            name: "NvidiaJetsonNanoRobotController",
            targets: ["NvidiaJetsonNanoRobotController"]
        ),
        .executable(
            name: "MockRobotController",
            targets: ["MockRobotController"]
        ),
        .library(
            name: "RobotController",
            targets: ["RobotControllerBase", "MockRobotController"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.3.0"),
        .package(name: "RemoteProtocol", path: "../remote_protocol"),
        .package(name: "BaseGPIO", path: "../base_gpio"),
        .package(name: "NvidiaJetsonGPIO", path: "../nvidia_jetson_gpio"),
        .package(name: "GStreamer", path: "../swift-gstreamer")
    ],
    targets: [
        .target(
            name: "RobotControllerBase",
            dependencies: ["BaseGPIO"]
        ),
        .target(
            name: "RemoteServer",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                "RemoteProtocol",
                "RobotControllerBase",
                "BaseGPIO",
                "GStreamer"
            ],
            swiftSettings: [
                // Enable better optimizations when building in Release configuration. Despite the use of
                // the `.unsafeFlags` construct required by SwiftPM, this flag is recommended for Release
                // builds. See <https://github.com/swift-server/guides#building-for-production> for details.
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
            ]
        ),
        .target(
            name: "RobotControllerApplication",
            dependencies: ["RobotControllerBase", "RemoteServer", "GStreamer", .product(name: "ArgumentParser", package: "swift-argument-parser")]
        ),
        .target(
            name: "MockRobotController",
            dependencies: ["RobotControllerBase", "BaseGPIO", "RobotControllerApplication"]
        ),
        .target(
            name: "NvidiaJetsonNanoRobotController",
            dependencies: ["RobotControllerBase", "NvidiaJetsonGPIO", "RobotControllerApplication"]
        ),
        .testTarget(
            name: "RobotControllerTests",
            dependencies: ["RobotControllerBase"]),
    ]
)
/*
var supportedImpls: [Target.Dependency] = ["MockImpl"]

package.targets.append(.target(
    name: "MockImpl",
    dependencies: ["RobotControllerBase", "BaseGPIO"]
))

package.targets.append(.target(
    name: "RobotController",
    dependencies: ["RobotControllerBase"] + supportedImpls)
)*/