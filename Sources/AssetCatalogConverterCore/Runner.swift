import Foundation

public actor Runner {
    var workingDir: String
    
    let fm = FileManager.default

    public init(path: String) {
        workingDir = path
    }
}

public extension Runner {
    func run() throws {
        try convert(inDirectory: workingDir)
    }
}

extension Runner {
    func convert(inDirectory directoryPath: String) throws {
        logger.debug("Lookup: \(directoryPath)")
        let files = try fm.contentsOfDirectory(atPath: directoryPath)
        try files.lazy
            .map { "\(directoryPath)/\($0)" }
            .forEach { filePath in
                if fm.isDirectory(atPath: filePath) {
                    try convert(inDirectory: filePath)
                } else if filePath.hasSuffix(".swift") {
                    try convert(filePath)
                }
            }
    }

    func convert(_ filePath: String) throws {
        logger.debug("Convert: \(filePath)")
        let url = URL(filePath: filePath)
        let data = try Data(contentsOf: url)
        guard let content = String(data: data, encoding: .utf8) else {
            logger.error("Failed to open \(filePath)")
            return
        }
        let convertedContent = try FileConverter.convert(content)
        if convertedContent == content {
            logger.info("No changes at \(filePath)")
            return
        }
        try convertedContent.data(using: .utf8)?.write(to: url)
        logger.info("Convert complete: \(filePath)")
    }
}

extension FileManager {
    func isDirectory(atPath path: String) -> Bool {
        var flag: ObjCBool = false
        guard fileExists(atPath: path, isDirectory: &flag) else { return false }
        return flag.boolValue
    }
}
