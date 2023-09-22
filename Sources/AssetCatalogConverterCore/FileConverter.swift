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
            // for UIKit
            if let member = node.calledExpression.as(MemberAccessExprSyntax.self),
               let base = member.base?.as(MemberAccessExprSyntax.self),
               base.base?.as(DeclReferenceExprSyntax.self)?.baseName.text == "R" {
                let reader = RswiftResourceReader(viewMode: .all)
                reader.walk(base)
                switch reader.detectedResource {
                case let .image(imageName):
                    let builder = UIImageBuilder(
                        imageName: imageName.camelized,
                        leadingTrivia: node.leadingTrivia,
                        trailingTrivia: node.trailingTrivia
                    )
                    return super.visit(builder.build())
                case let .color(colorName):
                    let builder = UIColorBuilder(
                        colorName: colorName.camelized,
                        leadingTrivia: node.leadingTrivia,
                        trailingTrivia: node.trailingTrivia
                    )
                    return super.visit(builder.build())
                default: break
                }
            }
            // for SwiftUI
            if let decl = node.calledExpression.as(DeclReferenceExprSyntax.self) {
                switch decl.baseName.text {
                case "Image":
                    return ExprSyntax(
                        SwiftUIImageRewriter(viewMode: .all)
                            .visit(node)
                    )
                case "Color":
                    return ExprSyntax(
                        SwiftUIColorRewriter(viewMode: .all)
                            .visit(node)
                    )
                default: break
                }
                print()
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
