import Foundation
import SwiftSyntax

final class SwiftUIImageRewriter: SyntaxRewriter {
    override func visit(_ node: FunctionCallExprSyntax) -> ExprSyntax {
        guard let decl = node.calledExpression.as(DeclReferenceExprSyntax.self),
              decl.baseName.text == "Image" else {
            return super.visit(node)
        }
        let reader = RswiftResourceReader(viewMode: .all)
        reader.walk(node)
        guard case let .image(imageName) = reader.detectedResource else {
            return ExprSyntax(node)
        }
        return ExprSyntax(
            node.with(\.arguments, [
                LabeledExprSyntax(
                    expression: MemberAccessExprSyntax(
                        period: .periodToken(),
                        name: .identifier(imageName.camelized)
                    )
                )
            ])
        )
    }
}
