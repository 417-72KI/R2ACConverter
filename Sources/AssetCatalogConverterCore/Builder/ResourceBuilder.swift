import Foundation
import SwiftSyntax

protocol ResourceBuilder: SyntaxBuilder where SyntaxType == FunctionCallExprSyntax {
    var typeName: String { get }
    var value: String { get }
    var leadingTrivia: Trivia? { get }
    var trailingTrivia: Trivia? { get }
}

extension ResourceBuilder {
    func build() -> SyntaxType {
        FunctionCallExprSyntax(
            leadingTrivia: leadingTrivia,
            calledExpression: DeclReferenceExprSyntax(
                baseName: .identifier(typeName)
            ),
            leftParen: .leftParenToken(),
            arguments: [
                LabeledExprSyntax(
                    label: .identifier("resource"),
                    colon: .colonToken(trailingTrivia: .space),
                    expression: MemberAccessExprSyntax(
                        period: .periodToken(),
                        name: .identifier(value)
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
