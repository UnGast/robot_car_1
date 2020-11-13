// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "RemoteServer",
    products: [
        .executable(
            name: "RemoteServer",
            targets: ["RemoteServer"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0")
    ],
    targets: [
        .target(
            name: "RemoteServer",
            dependencies: [.product(name: "Vapor", package: "vapor")])
    ]
)
