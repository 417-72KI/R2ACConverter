import Foundation
import SwiftSyntax
import SwiftParser

enum FileConverter {}

extension FileConverter {
    static func convert(_ input: String) throws -> String {
        let source = Parser.parse(source: input)
        let converted = ResourceRewriter(viewMode: .all)
            .visit(source)
        return converted.description
    }
}

private class ResourceRewriter: SyntaxRewriter {
    override func visit(_ node: FunctionCallExprSyntax) -> ExprSyntax {
        if let member = node.calledExpression.as(MemberAccessExprSyntax.self),
           let base = member.base?.as(MemberAccessExprSyntax.self),
           base.base?.as(DeclReferenceExprSyntax.self)?.baseName.text == "R" {
            switch base.declName.baseName.text {
            case "image":
                let imageName = member.declName.baseName.text.camelized
                return super.visit(
                    FunctionCallExprSyntax(
                        leadingTrivia: node.leadingTrivia,
                        calledExpression: DeclReferenceExprSyntax(
                            baseName: .identifier("UIImage")
                        ),
                        leftParen: node.leftParen,
                        arguments: [
                            LabeledExprSyntax(
                                label: .identifier("resource"),
                                colon: .colonToken(trailingTrivia: .space),
                                expression: MemberAccessExprSyntax(
                                    period: .periodToken(),
                                    name: .identifier(imageName)
                                )
                            )
                        ],
                        rightParen: node.rightParen,
                        trailingClosure: node.trailingClosure,
                        additionalTrailingClosures: node.additionalTrailingClosures,
                        trailingTrivia: node.trailingTrivia
                    )
                )
            case "color":
                let colorName = member.declName.baseName.text.camelized
                return super.visit(
                    FunctionCallExprSyntax(
                        leadingTrivia: node.leadingTrivia,
                        calledExpression: DeclReferenceExprSyntax(
                            baseName: .identifier("UIColor")
                        ),
                        leftParen: node.leftParen,
                        arguments: [
                            LabeledExprSyntax(
                                label: .identifier("resource"),
                                colon: .colonToken(trailingTrivia: .space),
                                expression: MemberAccessExprSyntax(
                                    period: .periodToken(),
                                    name: .identifier(colorName)
                                )
                            )
                        ],
                        rightParen: node.rightParen,
                        trailingClosure: node.trailingClosure,
                        additionalTrailingClosures: node.additionalTrailingClosures,
                        trailingTrivia: node.trailingTrivia
                    )
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
            return super.visit(converted)
        }
        return super.visit(token)
    }
}
