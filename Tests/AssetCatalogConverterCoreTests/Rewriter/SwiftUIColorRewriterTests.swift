import XCTest
import SwiftParser

@testable import AssetCatalogConverterCore

final class SwiftUIColorRewriterTests: XCTestCase {
    func testVisit() throws {
        let pattern: [(String, String)] = [
            ("Color(R.color.foo)", "Color(.foo)"),
            ("Color(R.color.bar_baz)", "Color(.barBaz)"),
            ("Color(flag ? R.color.foo : R.color.bar)", "Color(flag ? .foo : .bar)"),
            ("Color(uiColor: R.color.qux()!)", "Color(.qux)"),
            ("Color(uiColor: UIColor(resource: R.color.quux)!)", "Color(.quux)"),
            ("Color(uiColor: .init(resource: R.color.corge)!)", "Color(.corge)"),
            ("Color(uiColor: UIColor(resource: .grault)!)", "Color(.grault)"),
            ("Color(uiColor: UIColor(named: \"foo\")!)", "Color(uiColor: UIColor(named: \"foo\")!)"),
        ]
        pattern.forEach { input, expected in
            let source = Parser.parse(source: input)
            let converted = SwiftUIColorRewriter(viewMode: .all)
                .visit(source)
            XCTAssertEqual(expected, converted.description)
        }
    }
}
