import Foundation
import SwiftParser
import SwiftSyntax

enum FileConverter {}

extension FileConverter {
    static func convert(_ input: String) throws -> String {
        let source = Parser.parse(source: input)
        let converted = ResourceRewriter(viewMode: .all)
            .visit(source)
        return converted.description
    }
}

private extension FileConverter {
    final class ResourceRewriter: SyntaxRewriter {
        override func visit(_ node: FunctionCallExprSyntax) -> ExprSyntax {
            if let member = node.calledExpression.as(MemberAccessExprSyntax.self),
               let base = member.base?.as(MemberAccessExprSyntax.self),
               base.base?.as(DeclReferenceExprSyntax.self)?.baseName.text == "R" {
                switch base.declName.baseName.text {
                case "image":
                    let builder = UIImageBuilder(
                        imageName: member.declName.baseName.text.camelized,
                        leadingTrivia: node.leadingTrivia,
                        trailingTrivia: node.trailingTrivia
                    )
                    return super.visit(builder.build())
                case "color":
                    let builder = UIColorBuilder(
                        colorName: member.declName.baseName.text.camelized,
                        leadingTrivia: node.leadingTrivia,
                        trailingTrivia: node.trailingTrivia
                    )
                    return super.visit(builder.build())
                default: break
                }
            }
            return super.visit(node)
        }

        override func visit(_ token: ForceUnwrapExprSyntax) -> ExprSyntax {
            if let expr = token.expression.as(FunctionCallExprSyntax.self),
               let converted = visit(expr).as(FunctionCallExprSyntax.self),
               expr != converted {
                return super.visit(converted)
            }
            return super.visit(token)
        }
    }
}
