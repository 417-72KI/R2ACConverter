import Foundation
import SwiftSyntax

final class SwiftUIColorRewriter: SyntaxRewriter {
    override func visit(_ node: FunctionCallExprSyntax) -> ExprSyntax {
        guard let decl = node.calledExpression.as(DeclReferenceExprSyntax.self),
              decl.baseName.text == "Color" else {
            return super.visit(node)
        }
        let reader = RswiftResourceReader(viewMode: .all)
        reader.walk(node)
        guard case let .color(colorName) = reader.detectedResource else {
            return ExprSyntax(node)
        }
        return ExprSyntax(
            node.with(\.arguments, [
                LabeledExprSyntax(
                    expression: MemberAccessExprSyntax(
                        period: .periodToken(),
                        name: .identifier(colorName.camelized)
                    )
                )
            ])
        )
    }
}
