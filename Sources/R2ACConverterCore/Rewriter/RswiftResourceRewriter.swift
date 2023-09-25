import Foundation
import SwiftSyntax

final class RswiftResourceRewriter: SyntaxRewriter {
    private let rewritableAssets = [
        "image": "UIImage",
        "color": "UIColor"
    ]

    override func visit(_ node: FunctionCallExprSyntax) -> ExprSyntax {
        if let base = node.calledExpression.as(MemberAccessExprSyntax.self),
           let expr = visit(base).as(MemberAccessExprSyntax.self),
           base != expr,
           let assetType = base.base?.as(MemberAccessExprSyntax.self)?.declName.baseName.text,
           let convertedType = rewritableAssets[assetType] {
            return ExprSyntax(
                FunctionCallExprSyntax(
                    leadingTrivia: node.leadingTrivia,
                    calledExpression: ExprSyntax(
                        DeclReferenceExprSyntax(
                            baseName: .identifier(convertedType)
                        )
                    ),
                    leftParen: .leftParenToken(),
                    arguments: [
                        .init(
                            label: .identifier("resource"),
                            colon: .colonToken(trailingTrivia: .space),
                            expression: expr.with(\.leadingTrivia, [])
                        )
                    ],
                    rightParen: .rightParenToken(),
                    trailingTrivia: node.trailingTrivia
                )
            )
        }
        return super.visit(node)
    }

    override func visit(_ node: MemberAccessExprSyntax) -> ExprSyntax {
        if let base = node.base?.as(MemberAccessExprSyntax.self),
           base.base?.as(DeclReferenceExprSyntax.self)?.baseName.text == "R" {
            let resourceName = node.declName.baseName.text
            if rewritableAssets.keys.contains(base.declName.baseName.text) {
                return ExprSyntax(
                    MemberAccessExprSyntax(
                        leadingTrivia: node.leadingTrivia,
                        period: .periodToken(),
                        name: .identifier(resourceName.camelized),
                        trailingTrivia: node.trailingTrivia
                    )
                )
            }
        }
        return super.visit(node)
    }

    override func visit(_ token: ForceUnwrapExprSyntax) -> ExprSyntax {
        if let expr = token.expression.as(FunctionCallExprSyntax.self),
           let converted = visit(expr).as(FunctionCallExprSyntax.self),
           expr != converted {
            return ExprSyntax(converted)
        }
        return super.visit(token)
    }
}
