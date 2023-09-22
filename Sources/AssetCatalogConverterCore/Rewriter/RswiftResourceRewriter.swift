import Foundation
import SwiftSyntax

final class RswiftResourceRewriter: SyntaxRewriter {
    override func visit(_ node: MemberAccessExprSyntax) -> ExprSyntax {
        if let base = node.base?.as(MemberAccessExprSyntax.self),
           base.base?.as(DeclReferenceExprSyntax.self)?.baseName.text == "R" {
            let resourceName = node.declName.baseName.text
            switch base.declName.baseName.text {
            case "image":
                return ExprSyntax(
                    MemberAccessExprSyntax(
                        leadingTrivia: node.leadingTrivia,
                        period: .periodToken(),
                        name: .identifier(resourceName.camelized),
                        trailingTrivia: node.trailingTrivia
                    )
                )
            case "color":
                return ExprSyntax(
                    MemberAccessExprSyntax(
                        leadingTrivia: node.leadingTrivia,
                        period: .periodToken(),
                        name: .identifier(resourceName.camelized),
                        trailingTrivia: node.trailingTrivia
                    )
                )
            default: break
            }
        }
        return super.visit(node)
    }
}
