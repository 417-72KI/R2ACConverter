import XCTest
import SwiftParser

@testable import AssetCatalogConverterCore

final class SwiftUIColorRewriterTests: XCTestCase {
    func testVisit() throws {
        let pattern: [(String, String)] = [
            ("Color(R.color.foo)", "Color(.foo)"),
            ("Color(R.color.bar_baz)", "Color(.barBaz)"),
        ]
        pattern.forEach { input, expected in
            let source = Parser.parse(source: input)
            let converted = SwiftUIColorRewriter(viewMode: .all)
                .visit(source)
            XCTAssertEqual(expected, converted.description)
        }
    }
}
