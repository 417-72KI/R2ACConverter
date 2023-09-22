import Foundation
import SwiftSyntax

final class SwiftUIColorRewriter: SyntaxRewriter {
    override func visit(_ node: FunctionCallExprSyntax) -> ExprSyntax {
        guard let decl = node.calledExpression.as(DeclReferenceExprSyntax.self),
              decl.baseName.text == "Color",
              let argument = node.arguments.first else {
            return super.visit(node)
        }
        print(argument)
        if argument.label?.text == "uiColor" {
            // Create `UIColorRewriter`
            print(argument)
        }
        return RswiftResourceRewriter(viewMode: .all)
            .visit(node)
    }
}
