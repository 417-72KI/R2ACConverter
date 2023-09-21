#if canImport(FoundationNetworking)
import Foundation
import FoundationNetworking

extension URL {
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public init(filePath path: String, 
                directoryHint: URL.DirectoryHint = .inferFromPath,
                relativeTo base: URL? = nil) {
        self.init(fileURLWithPath: path,
                  isDirectory: directoryHint == .isDirectory,
                  relativeTo: base)
    }
}

extension URL {
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public enum DirectoryHint: Sendable {
        case isDirectory
        case notDirectory
        case checkFileSystem
        case inferFromPath
    }
}
#endif
