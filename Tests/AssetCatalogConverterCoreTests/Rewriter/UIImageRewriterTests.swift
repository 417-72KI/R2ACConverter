import XCTest
import SwiftParser

@testable import AssetCatalogConverterCore

final class UIImageRewriterTests: XCTestCase {
    func testVisit() throws {
        let pattern: [(String, String)] = [
            ("R.image.foo()", "UIImage(resource: .foo)"),
            ("R.image.bar_baz()!", "UIImage(resource: .barBaz)"),
            ("UIImage(resource: R.image.foo_bar_1_2)", "UIImage(resource: .fooBar12)"),
            ("UIImage(resource: R.image.foo_bar1_2)!", "UIImage(resource: .fooBar12)"),
            ("UIImage.init(resource: R.image.foo_bar)!", "UIImage.init(resource: .fooBar)"),
            (".init(resource: R.image.foo_bar)!", ".init(resource: .fooBar)"),
        ]
        pattern.forEach { input, expected in
            let source = Parser.parse(source: input)
            let converted = UIImageRewriter(viewMode: .all)
                .visit(source)
            XCTAssertEqual(expected, converted.description)
        }
    }
}
