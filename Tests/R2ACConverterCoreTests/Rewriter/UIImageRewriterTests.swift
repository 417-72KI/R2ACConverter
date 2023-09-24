import XCTest
import SwiftParser

@testable import R2ACConverterCore

final class UIImageRewriterTests: XCTestCase {
    func testVisit() throws {
        let pattern: [(String, String)] = [
            ("UIImage(resource: R.image.foo_bar_1_2)", "UIImage(resource: .fooBar12)"),
            ("UIImage(resource: R.image.foo_bar1_2)!", "UIImage(resource: .fooBar12)"),
            ("UIImage.init(resource: R.image.foo_bar)!", "UIImage.init(resource: .fooBar)"),
            (".init(resource: R.image.foo_bar)!", ".init(resource: .fooBar)"),
            ("R.image.foo()", "R.image.foo()"),
            ("R.image.bar_baz()!", "R.image.bar_baz()!"),
        ]
        pattern.forEach { input, expected in
            let source = Parser.parse(source: input)
            let converted = UIImageRewriter(viewMode: .all)
                .visit(source)
            XCTAssertEqual(expected, converted.description)
        }
    }
}
