import Foundation
import SwiftSyntax

struct UIColorBuilder: SyntaxBuilder {
    var colorName: String
    var leadingTrivia: Trivia?
    var trailingTrivia: Trivia?

    func build() -> FunctionCallExprSyntax {
        FunctionCallExprSyntax(
            leadingTrivia: leadingTrivia,
            calledExpression: DeclReferenceExprSyntax(
                baseName: .identifier("UIColor")
            ),
            leftParen: .leftParenToken(),
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
            rightParen: .rightParenToken(),
            trailingClosure: nil,
            additionalTrailingClosures: [],
            trailingTrivia: trailingTrivia
        )
    }
}
