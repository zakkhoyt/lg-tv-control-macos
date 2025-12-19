// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "LGTVController",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "LGTVWebOSController",
            targets: ["LGTVWebOSController"]
        ),
        .executable(
            name: "lgtv",
            targets: ["LGTVControllerCLI"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.32.0"),
        .package(url: "https://github.com/apple/swift-nio-ssl.git", from: "2.17.0"),
        .package(url: "https://github.com/vapor/websocket-kit.git", from: "2.6.0")
    ],
    targets: [
        .target(
            name: "LGTVWebOSController",
            dependencies: [
                .product(name: "NIO", package: "swift-nio"),
                .product(name: "NIOFoundationCompat", package: "swift-nio"),
                .product(name: "NIOSSL", package: "swift-nio-ssl"),
                .product(name: "WebSocketKit", package: "websocket-kit")
            ]
        ),
        .executableTarget(
            name: "LGTVControllerCLI",
            dependencies: [
                "LGTVWebOSController",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .testTarget(
            name: "LGTVWebOSControllerTests",
            dependencies: ["LGTVWebOSController"]
        )
    ]
)
