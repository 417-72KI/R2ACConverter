import Foundation

private let badChars = CharacterSet.alphanumerics.inverted

extension String {
    var uppercasingFirst: String {
        prefix(1).uppercased() + dropFirst()
    }

    var lowercasingFirst: String {
        prefix(1).lowercased() + dropFirst()
    }

    var camelized: String {
        guard !isEmpty else { return "" }

        let parts = components(separatedBy: badChars)

        let first = String(describing: parts.first!).lowercasingFirst
        let rest = parts.dropFirst().map { String($0).uppercasingFirst }

        return ([first] + rest).joined(separator: "")
    }
}
