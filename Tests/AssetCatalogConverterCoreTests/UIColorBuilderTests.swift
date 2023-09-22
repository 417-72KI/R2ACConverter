import XCTest

@testable import AssetCatalogConverterCore

final class UIColorBuilderTests: XCTestCase {
    func testBuild() throws {
        let actual = UIColorBuilder(colorName: "foobar")
            .build()
        XCTAssertEqual("UIColor(resource: .foobar)", actual.description)
    }

    func testBuildWithLeadingTrivia() throws {
        let actual = UIColorBuilder(
            colorName: "foobar",
            leadingTrivia: .spaces(4)
        ).build()
        XCTAssertEqual("    UIColor(resource: .foobar)", actual.description)
    }

    func testBuildWithTrailingTrivia() throws {
        let actual = UIColorBuilder(
            colorName: "foobar",
            trailingTrivia: .newline
        ).build()
        XCTAssertEqual("UIColor(resource: .foobar)\n", actual.description)
    }
}
