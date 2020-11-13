// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RemoteClient",
    products: [
        .executable(
            name: "RemoteClient",
            targets: ["RemoteClient"]),
    ],
    dependencies: [
        .package(name: "SwiftGUI", url: "https://github.com/UnGast/swift-gui.git", .branch("master"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "RemoteClient",
            dependencies: ["SwiftGUI"]),
        /*.testTarget(
            name: "remote_clientTests",
            dependencies: ["remote_client"]),*/
    ]
)
