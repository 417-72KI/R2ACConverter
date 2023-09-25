import Foundation
import SwiftSyntax

final class RswiftResourceReader: SyntaxVisitor {
    private var detectedResource: ResourceType?

    override func visit(_ node: MemberAccessExprSyntax) -> SyntaxVisitorContinueKind {
        if case "R" = node.base?.as(DeclReferenceExprSyntax.self)?.baseName.text,
           let parent = node.parent?.as(MemberAccessExprSyntax.self) {
            let resourceName = parent.declName.baseName.text
            switch node.declName.baseName.text {
            case "image":
                detectedResource = .image(resourceName)
            case "color":
                detectedResource = .color(resourceName)
            default: break
            }
            return .skipChildren
        }
        return .visitChildren
    }
}

extension RswiftResourceReader {
    func detectResource(from node: some SyntaxProtocol) -> ResourceType? {
        walk(node)
        return detectedResource
    }
}

extension RswiftResourceReader {
    enum ResourceType: Equatable {
        case image(String)
        case color(String)
    }
}
