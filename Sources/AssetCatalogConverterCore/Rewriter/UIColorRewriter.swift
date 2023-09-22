import Foundation
import SwiftSyntax

final class UIColorRewriter: SyntaxRewriter {
    private let typeName = "UIColor"

    override func visit(_ node: FunctionCallExprSyntax) -> ExprSyntax {
        if case typeName = node.calledExpression.as(DeclReferenceExprSyntax.self)?.baseName.text,
           let argument = node.arguments.first,
           argument.label?.text == "resource" {
            let newArgument = rswiftResourceRewriter.visit(argument)
            return ExprSyntax(node.with(\.arguments, [newArgument]))
        }
        if let member = node.calledExpression.as(MemberAccessExprSyntax.self),
           case "init" = member.declName.baseName.text,
           let argument = node.arguments.first,
           argument.label?.text == "resource" {
            let newArgument = rswiftResourceRewriter.visit(argument)
            return ExprSyntax(node.with(\.arguments, [newArgument]))
        }
        return super.visit(rswiftResourceRewriter.visit(node))
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

private extension UIColorRewriter {
    var rswiftResourceRewriter: RswiftResourceRewriter {
        RswiftResourceRewriter(viewMode: viewMode)
    }
}
