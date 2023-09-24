import XCTest
import SwiftSyntax
import SwiftParser

@testable import R2ACConverterCore

final class RswiftResourceReaderTests: XCTestCase {
    func testImage() throws {
        let pattern: [(String, String)] = [
            ("Image(R.image.foo)", "foo"),
            ("Image(uiImage: R.image.bar()!)", "bar"),
            ("R.image.baz()", "baz"),
            ("R.image.qux", "qux"),
        ]
        pattern.forEach { source, expected in
            let syntax = Parser.parse(source: source)
            let reader = RswiftResourceReader(viewMode: .all)
            reader.walk(syntax)
            XCTAssertEqual(.image(expected), reader.detectedResource)
        }
    }

    func testColor() throws {
        let pattern: [(String, String)] = [
            ("Color(R.color.foo)", "foo"),
            ("Color(uiColor: R.color.bar()!)", "bar"),
            ("R.color.baz()", "baz"),
            ("R.color.qux", "qux"),
        ]
        pattern.forEach { source, expected in
            let syntax = Parser.parse(source: source)
            let reader = RswiftResourceReader(viewMode: .all)
            reader.walk(syntax)
            XCTAssertEqual(.color(expected), reader.detectedResource)
        }
    }
}
