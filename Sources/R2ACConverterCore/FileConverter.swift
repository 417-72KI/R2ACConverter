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
            if let expr = RswiftResourceRewriter(viewMode: viewMode).visit(node)
                .as(FunctionCallExprSyntax.self),
               expr != node {
                return visit(expr)
            }
            if let decl = node.calledExpression.as(DeclReferenceExprSyntax.self) {
                switch decl.baseName.text {
                case "UIImage":
                    return ExprSyntax(
                        UIImageRewriter(viewMode: viewMode)
                            .visit(node)
                    )
                case "UIColor":
                    return ExprSyntax(
                        UIColorRewriter(viewMode: viewMode)
                            .visit(node)
                    )
                case "Image":
                    return ExprSyntax(
                        SwiftUIImageRewriter(viewMode: viewMode)
                            .visit(node)
                    )
                case "Color":
                    return ExprSyntax(
                        SwiftUIColorRewriter(viewMode: viewMode)
                            .visit(node)
                    )
                default: break
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
}
