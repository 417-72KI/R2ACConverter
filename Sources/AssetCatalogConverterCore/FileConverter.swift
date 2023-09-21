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
           base.base?.as(DeclReferenceExprSyntax.self)?.baseName.text == "R",
           base.declName.baseName.text == "image" {
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
        }
        return super.visit(node)
    }
}
