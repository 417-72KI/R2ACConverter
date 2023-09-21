import Foundation
import SwiftSyntax
import SwiftParser

enum FileConverter {}

extension FileConverter {
    static func convert(_ input: String) throws -> String {
        let source = Parser.parse(source: input)

        for codeBlock in source.statements {
            let item = codeBlock.item
            if let decl = item.as(VariableDeclSyntax.self) {
                try convertVariable(decl)
                continue
            }
            if let decl = item.as(ClassDeclSyntax.self) {
                try convertClass(decl)
                continue
            }
            if let decl = item.as(StructDeclSyntax.self) {
                try convertStruct(decl)
                continue
            }
            if let decl = item.as(EnumDeclSyntax.self) {
                try convertEnum(decl)
                continue
            }
            if let decl = item.as(ExtensionDeclSyntax.self) {
                try convertExtension(decl)
                continue
            }
        }
        // TODO: not implemented
        return input
    }
}

private extension FileConverter {
    static func convertVariable(_ decl: VariableDeclSyntax) throws {
        for binding in decl.bindings {
            print(binding)
            if let expr = binding.initializer?.value.as(FunctionCallExprSyntax.self) {
                try convertFunctionCall(expr)
                continue
            }
            if let expr = binding.initializer?.value.as(ForceUnwrapExprSyntax.self) {
                if let expr = expr.expression.as(FunctionCallExprSyntax.self) {
                    try convertFunctionCall(expr)
                }
                continue
            }
        }
    }

    static func convertFunctionCall(_ expr: FunctionCallExprSyntax) throws {
        guard let member = expr.calledExpression.as(MemberAccessExprSyntax.self),
              let base = member.base?.as(MemberAccessExprSyntax.self),
              base.base?.as(DeclReferenceExprSyntax.self)?.baseName.text == "R",
              base.declName.baseName.text == "image" else { return }
        let imageName = member.declName.baseName.text.camelized
        let newSyntax = FunctionCallExprSyntax(
            leadingTrivia: expr.leadingTrivia,
            calledExpression: DeclReferenceExprSyntax(
                baseName: .identifier("UIImage")
            ),
            leftParen: expr.leftParen,
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
            rightParen: expr.rightParen,
            trailingClosure: expr.trailingClosure,
            additionalTrailingClosures: expr.additionalTrailingClosures,
            trailingTrivia: expr.trailingTrivia
        )
        print(newSyntax.description)
        print(newSyntax)
    }
}

private extension FileConverter {
    static func convertClass(_ decl: ClassDeclSyntax) throws {
        print(decl.classKeyword)
    }

    static func convertStruct(_ decl: StructDeclSyntax) throws {
        print(decl.structKeyword)
    }

    static func convertEnum(_ decl: EnumDeclSyntax) throws {
        print(decl.enumKeyword)
    }

    static func convertExtension(_ decl: ExtensionDeclSyntax) throws {
        print(decl.extensionKeyword)
    }
}
