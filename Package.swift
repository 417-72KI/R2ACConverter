// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

var isDevelop = true
#if !os(macOS)
isDevelop = false
#endif

let package = Package(
    name: "R2ACConverter",
    platforms: [.macOS(.v13), .iOS("999999"), .watchOS("999999"), .tvOS("999999")],
    products: [
        .executable(name: "r2acconverter", targets: ["R2ACConverter"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.6.2"),
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.1"),
    ],
    targets: [
        .executableTarget(
            name: "R2ACConverter",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "R2ACConverterCore"
            ]
        ),
        .target(
            name: "R2ACConverterCore",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax"),
            ],
            plugins: []
        ),
        .testTarget(name: "R2ACConverterCoreTests",
                    dependencies: ["R2ACConverterCore"]),
    ],
    swiftLanguageVersions: [.v5]
)

if isDevelop {
    package.dependencies.append(contentsOf: [
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.58.2"),
    ])
    package.targets.forEach {
        $0.plugins?.append(.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins"))
    }
}