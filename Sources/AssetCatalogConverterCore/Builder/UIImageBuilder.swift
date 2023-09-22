import Foundation
import SwiftSyntax

struct UIImageBuilder: SyntaxBuilder {
    var imageName: String
    var leadingTrivia: Trivia?
    var trailingTrivia: Trivia?

    func build() -> FunctionCallExprSyntax {
        FunctionCallExprSyntax(
            leadingTrivia: leadingTrivia,
            calledExpression: DeclReferenceExprSyntax(
                baseName: .identifier("UIImage")
            ),
            leftParen: .leftParenToken(),
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
            rightParen: .rightParenToken(),
            trailingClosure: nil,
            additionalTrailingClosures: [],
            trailingTrivia: trailingTrivia
        )
    }
}
