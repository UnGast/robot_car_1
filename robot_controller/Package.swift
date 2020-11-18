// swift-tools-version:5.3
import PackageDescription

var package = Package(
    name: "RobotController",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(
            name: "RobotControllerRun",
            targets: ["RobotControllerRun"]
        ),
        .library(
            name: "RobotController",
            targets: ["RobotControllerBase", "MockRobotController"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(name: "RemoteProtocol", path: "../remote_protocol"),
        .package(name: "BaseGPIO", path: "../base_gpio"),
        .package(name: "NvidiaJetsonGPIO", path: "../nvidia_jetson_gpio")
    ],
    targets: [
        .target(
            name: "RobotControllerBase",
            dependencies: ["BaseGPIO"]
        ),
        .target(
            name: "MockRobotController",
            dependencies: ["RobotControllerBase", "BaseGPIO"]
        ),
        .target(
            name: "RemoteServer",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                "RemoteProtocol",
                "RobotControllerBase",
                "BaseGPIO"
            ],
            swiftSettings: [
                // Enable better optimizations when building in Release configuration. Despite the use of
                // the `.unsafeFlags` construct required by SwiftPM, this flag is recommended for Release
                // builds. See <https://github.com/swift-server/guides#building-for-production> for details.
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
            ]
        ),
        .target(
            name: "RobotControllerRun",
            dependencies: ["MockRobotController", "RemoteServer"]
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