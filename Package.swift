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
    name: "AssetCatalogConverter",
    platforms: [.macOS(.v13), .iOS("999999"), .watchOS("999999"), .tvOS("999999")],
    products: [
        .executable(name: "asset-catalog-converter", targets: ["AssetCatalogConverter"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.3"),
        .package(url: "https://github.com/apple/swift-syntax", from: "509.0.0"),
    ] + devDependencies,
    targets: [
        .executableTarget(
            name: "AssetCatalogConverter",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "AssetCatalogConverterCore"
            ]
        ),
        .target(
            name: "AssetCatalogConverterCore",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax"),
            ],
            plugins: [] + devPlugins
        ),
        .testTarget(name: "AssetCatalogConverterCoreTests",
                    dependencies: ["AssetCatalogConverterCore"]),
    ],
    swiftLanguageVersions: [.v5]
)
