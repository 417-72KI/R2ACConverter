// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

var isDevelop = true
#if !os(macOS)
isDevelop = false
#endif

let devDependencies: [Package.Dependency] = isDevelop ? [
    // .package(url: "https://github.com/realm/SwiftLint", from: "0.52.4"),
    .package(url: "https://github.com/realm/SwiftLint", branch: "main"),
] : []

let devPlugins: [Target.PluginUsage] = isDevelop ? [
    .plugin(name: "SwiftLintPlugin", package: "SwiftLint"),
] : []

let package = Package(
    name: "R2ACConverter",
    platforms: [.macOS(.v13), .iOS("999999"), .watchOS("999999"), .tvOS("999999")],
    products: [
        .executable(name: "r2acconverter", targets: ["R2ACConverter"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.5.0"),
        .package(url: "https://github.com/apple/swift-syntax", from: "509.0.0"),
    ] + devDependencies,
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
            plugins: [] + devPlugins
        ),
        .testTarget(name: "R2ACConverterCoreTests",
                    dependencies: ["R2ACConverterCore"]),
    ],
    swiftLanguageVersions: [.v5]
)
