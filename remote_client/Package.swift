// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "RemoteClient",
    products: [
        .executable(
            name: "RemoteClient",
            targets: ["RemoteClient"]),
    ],
    dependencies: [
        .package(name: "SwiftGUI", path: "/home/adrian/ProjekteLokal/swift-experiments/swift-gui-demo-app")
    ],
    targets: [
        .target(
            name: "RemoteClient",
            dependencies: ["SwiftGUI"]),
    ]
)
