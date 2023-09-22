import Foundation
import SwiftSyntax

final class SwiftUIImageRewriter: SyntaxRewriter {
    override func visit(_ node: FunctionCallExprSyntax) -> ExprSyntax {
        guard let decl = node.calledExpression.as(DeclReferenceExprSyntax.self),
              decl.baseName.text == "Image",
              let argument = node.arguments.first else {
            return super.visit(node)
        }
        if argument.label?.text == "uiImage" {
            // Create `UIImageRewriter`
            print(argument)
        }
        return RswiftResourceRewriter(viewMode: .all)
            .visit(node)
    }
}
