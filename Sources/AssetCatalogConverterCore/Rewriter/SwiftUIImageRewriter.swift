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
            if let expr = uiImageRewriter.visit(argument.expression).as(FunctionCallExprSyntax.self),
               let colorName = expr.arguments.first?.expression {
                return ExprSyntax(
                    node.with(\.arguments, [.init(expression: colorName)])
                )
            }
            if let expr = rswiftResourceRewriter.visit(argument.expression).as(FunctionCallExprSyntax.self),
               let argument = expr.arguments.first,
               argument.label?.text == "resource" {
                return ExprSyntax(
                    node.with(\.arguments, [
                        argument.with(\.label, nil)
                            .with(\.colon, nil)
                    ])
                )
            }
        }
        return rswiftResourceRewriter.visit(node)
    }
}

private extension SwiftUIImageRewriter {
    var uiImageRewriter: UIImageRewriter {
        UIImageRewriter(viewMode: viewMode)
    }

    var rswiftResourceRewriter: RswiftResourceRewriter {
        RswiftResourceRewriter(viewMode: viewMode)
    }
}
