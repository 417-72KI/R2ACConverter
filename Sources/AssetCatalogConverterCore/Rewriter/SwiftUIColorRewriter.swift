import Foundation
import SwiftSyntax

final class SwiftUIColorRewriter: SyntaxRewriter {
    override func visit(_ node: FunctionCallExprSyntax) -> ExprSyntax {
        guard let decl = node.calledExpression.as(DeclReferenceExprSyntax.self),
              decl.baseName.text == "Color" else {
            return super.visit(node)
        }
        return RswiftResourceRewriter(viewMode: .all)
            .visit(node)
    }
}
