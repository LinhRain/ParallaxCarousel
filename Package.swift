// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ParallaxCarousel",
    platforms: [.iOS(.v16)], // Hỗ trợ từ iOS 13 trở lên
    products: [
        .library(
            name: "ParallaxCarousel",
            targets: ["ParallaxCarousel"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ParallaxCarousel",
            dependencies: [],
            path: "Sources/ParallaxCarousel",
            resources: [.process("Resources")] // 👈 Đặt vào đây!
        ),
        .testTarget(
            name: "ParallaxCarouselTests",
            dependencies: ["ParallaxCarousel"],
            path: "Tests/ParallaxCarouselTests"
        ),
    ]
)
