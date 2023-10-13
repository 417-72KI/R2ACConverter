import XCTest
import SwiftParser

@testable import R2ACConverterCore

final class RswiftResourceRewriterTests: XCTestCase {
    func testVisit() throws {
        let pattern: [(String, String)] = [
            ("R.image.foo", ".foo"),
            ("R.image.bar_baz", ".barBaz"),
            ("R.image.qux()!", "UIImage(resource: .qux)"),
            ("R.image.quux()!.resized()!", "UIImage(resource: .qux).resized()!"),
            ("R.image.corge()?.resized()!", "UIImage(resource: .corge).resized()!"),
            ("R.image.corge()?.resized()?.doSomething()", "UIImage(resource: .corge).resized()?.doSomething()"),
            ("flag ? R.image.foo : R.image.bar", "flag ? .foo : .bar"),
            ("R.color.foo", ".foo"),
            ("R.color.bar_baz", ".barBaz"),
            ("R.color.qux()!", "UIColor(resource: .qux)"),
            ("R.color.quux()!.alpha(0.5)!", "UIColor(resource: .qux).alpha(0.5)!"),
            ("R.color.corge()?.alpha(0.5)!", "UIColor(resource: .corge).alpha(0.5)!"),
            ("R.color.corge()?.alpha(0.5)?.doSomething()", "UIColor(resource: .corge).alpha(0.5)?.doSomething()"),
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
