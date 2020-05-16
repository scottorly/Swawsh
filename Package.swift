// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Swawsh",
    products: [
        .library(
            name: "Swawsh",
            targets: ["Swawsh"]),
    ],
    dependencies: [
        .package(name: "Cryptor", url: "https://github.com/IBM-Swift/BlueCryptor.git", from: "1.0.32"),
    ],
    targets: [
        .target(
            name: "Swawsh",
            dependencies: [
                "Cryptor"
            ],
            path: "Sources"),
        .testTarget(
            name: "SwawshTests",
            dependencies: ["Swawsh"]
        )
    ]
)
