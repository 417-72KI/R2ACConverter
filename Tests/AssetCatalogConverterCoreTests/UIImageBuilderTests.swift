import XCTest

@testable import AssetCatalogConverterCore

final class UIImageBuilderTests: XCTestCase {
    func testBuild() throws {
        let actual = UIImageBuilder(imageName: "foobar")
            .build()
        XCTAssertEqual("UIImage(resource: .foobar)", actual.description)
    }

    func testBuildWithLeadingTrivia() throws {
        let actual = UIImageBuilder(
            imageName: "foobar",
            leadingTrivia: .spaces(4)
        ).build()
        XCTAssertEqual("    UIImage(resource: .foobar)", actual.description)
    }

    func testBuildWithTrailingTrivia() throws {
        let actual = UIImageBuilder(
            imageName: "foobar",
            trailingTrivia: .newline
        ).build()
        XCTAssertEqual("UIImage(resource: .foobar)\n", actual.description)
    }
}
