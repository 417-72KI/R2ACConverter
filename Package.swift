// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AssetCatalogConverter",
    platforms: [.macOS(.v13), .iOS("999999"), .watchOS("999999"), .tvOS("999999")],
    products: [
        .executable(name: "asset-catalog-converter", targets: ["AssetCatalogConverter"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.3"),
        .package(url: "https://github.com/apple/swift-syntax", from: "509.0.0"),
    ],
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
            ]
        ),
        .testTarget(name: "AssetCatalogConverterCoreTests",
                    dependencies: ["AssetCatalogConverterCore"]),
    ],
    swiftLanguageVersions: [.v5]
)
