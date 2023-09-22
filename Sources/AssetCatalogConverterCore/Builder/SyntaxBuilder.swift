import Foundation
import SwiftSyntax

protocol SyntaxBuilder {
    associatedtype SyntaxType: SyntaxProtocol

    func build() -> SyntaxType
}
