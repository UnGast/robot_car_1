// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "RemoteClient",
    platforms: [.macOS(.v10_15)],
    products: [
        .executable(
            name: "RemoteClient",
            targets: ["RemoteClient"]),
    ],
    dependencies: [
        .package(name: "SwiftGUI", path: "../swift-gui"),
        .package(url: "https://github.com/vapor/websocket-kit.git", from: "2.0.0"),
        .package(name: "RemoteProtocol", path: "../remote_protocol"),
        .package(name: "BaseGPIO", path: "../base_gpio"),
        .package(name: "GStreamer", path: "../swift-gstreamer")
    ],
    targets: [
        .target(
            name: "RemoteClient",
            dependencies: ["SwiftGUI", "RemoteProtocol", "GStreamer", "BaseGPIO", .product(name: "WebSocketKit", package: "websocket-kit")]),
    ]
)
