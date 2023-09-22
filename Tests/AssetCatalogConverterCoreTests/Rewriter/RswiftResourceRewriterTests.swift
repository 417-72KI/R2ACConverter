import XCTest
import SwiftParser

@testable import AssetCatalogConverterCore

final class RswiftResourceRewriterTests: XCTestCase {
    func testVisit() throws {
        let pattern: [(String, String)] = [
            ("R.image.foo", ".foo"),
            ("R.image.bar_baz", ".barBaz"),
            ("R.image.qux()!", "UIImage(resource: .qux)"),
            ("flag ? R.image.foo : R.image.bar", "flag ? .foo : .bar"),
            ("R.color.foo", ".foo"),
            ("R.color.bar_baz", ".barBaz"),
            ("R.color.qux()!", "UIColor(resource: .qux)"),
            ("flag ? R.color.foo : R.color.bar", "flag ? .foo : .bar"),
        ]
        pattern.forEach { input, expected in
            let source = Parser.parse(source: input)
            let converted = RswiftResourceRewriter()
                .visit(source)
            XCTAssertEqual(expected, converted.description)
        }
    }
}
