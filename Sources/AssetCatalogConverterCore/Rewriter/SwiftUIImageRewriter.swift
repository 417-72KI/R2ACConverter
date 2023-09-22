import Foundation
import SwiftSyntax

final class SwiftUIImageRewriter: SyntaxRewriter {
    override func visit(_ node: FunctionCallExprSyntax) -> ExprSyntax {
        guard let decl = node.calledExpression.as(DeclReferenceExprSyntax.self),
              decl.baseName.text == "Image" else {
            return super.visit(node)
        }
        return RswiftResourceRewriter(viewMode: .all)
            .visit(node)
    }
}
