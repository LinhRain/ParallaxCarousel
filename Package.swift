// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ParallaxCarousel",
    platforms: [.iOS(.v16)], // Hỗ trợ từ iOS 16 trở lên
    products: [
        .library(
            name: "ParallaxCarousel",
            targets: ["ParallaxCarousel"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/SDWebImage/SDWebImageSwiftUI.git", from: "2.0.0")
    ],
    targets: [
        .target(
            name: "ParallaxCarousel",
            dependencies: [
                .product(name: "SDWebImageSwiftUI", package: "SDWebImageSwiftUI")
            ],
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
