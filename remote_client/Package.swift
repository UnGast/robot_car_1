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
        .package(name: "SwiftGUI", url: "https://github.com/UnGast/swift-gui.git", .branch("master")),
        .package(url: "https://github.com/vapor/websocket-kit.git", from: "2.0.0"),
        .package(name: "RemoteProtocol", path: "../remote_protocol")
    ],
    targets: [
        .target(
            name: "RemoteClient",
            dependencies: ["SwiftGUI", "RemoteProtocol", .product(name: "WebSocketKit", package: "websocket-kit")]),
    ]
)
