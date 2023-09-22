import XCTest
import SwiftParser

@testable import AssetCatalogConverterCore

final class SwiftUIImageRewriterTests: XCTestCase {
    func testVisit() throws {
        let pattern: [(String, String)] = [
            ("Image(R.image.foo)", "Image(.foo)"),
            ("Image(R.image.bar_baz)", "Image(.barBaz)"),
            ("Image(flag ? R.image.foo : R.image.bar)", "Image(flag ? .foo : .bar)"),
            ("Image(uiImage: R.image.qux()!)", "Image(.qux)"),
            ("Image(uiImage: UIImage(resource: R.image.quux)!)", "Image(.quux)"),
            ("Image(uiImage: .init(resource: R.image.corge)!)", "Image(.corge)"),
        ]
        pattern.forEach { input, expected in
            let source = Parser.parse(source: input)
            let converted = SwiftUIImageRewriter(viewMode: .all)
                .visit(source)
            XCTAssertEqual(expected, converted.description)
        }
    }
}
