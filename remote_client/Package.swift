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
        .package(name: "SwiftGUI", path: "/Users/UnGast/Nicht_Dropbox/swift-cross-platform-gui-example"),
        .package(url: "https://github.com/vapor/websocket-kit.git", from: "2.0.0"),
        .package(name: "RemoteProtocol", path: "../remote_protocol"),
        .package(name: "BaseGPIO", path: "../base_gpio")
    ],
    targets: [
        .target(
            name: "RemoteClient",
            dependencies: ["SwiftGUI", "RemoteProtocol", "BaseGPIO", .product(name: "WebSocketKit", package: "websocket-kit")]),
    ]
)
