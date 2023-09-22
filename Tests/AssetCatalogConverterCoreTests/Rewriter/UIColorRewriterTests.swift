import XCTest
import SwiftParser

@testable import AssetCatalogConverterCore

final class UIColorRewriterTests: XCTestCase {
    func testVisit() throws {
        let pattern: [(String, String)] = [
            ("R.color.foo()", "UIColor(resource: .foo)"),
            ("R.color.bar_baz()!", "UIColor(resource: .barBaz)"),
            ("UIColor(resource: R.color.blue_1_2)", "UIColor(resource: .blue12)"),
            ("UIColor(resource: R.color.blue1_2)!", "UIColor(resource: .blue12)"),
            ("UIColor.init(resource: R.color.blue)", "UIColor.init(resource: .blue)"),
            (".init(resource: R.color.blue)", ".init(resource: .blue)"),
        ]
        pattern.forEach { input, expected in
            let source = Parser.parse(source: input)
            let converted = UIColorRewriter(viewMode: .all)
                .visit(source)
            XCTAssertEqual(expected, converted.description)
        }
    }
}
