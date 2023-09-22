import Foundation
import SwiftSyntax

struct UIColorBuilder: ResourceBuilder {
    var colorName: String
    var leadingTrivia: Trivia?
    var trailingTrivia: Trivia?
}

extension UIColorBuilder {
    var typeName: String { "UIColor" }
    var value: String { colorName }
}
