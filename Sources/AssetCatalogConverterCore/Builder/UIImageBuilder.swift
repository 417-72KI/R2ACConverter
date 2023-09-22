import Foundation
import SwiftSyntax

struct UIImageBuilder: ResourceBuilder {
    var imageName: String
    var leadingTrivia: Trivia?
    var trailingTrivia: Trivia?
}

extension UIImageBuilder {
    var typeName: String { "UIImage" }
    var value: String { imageName }
}
