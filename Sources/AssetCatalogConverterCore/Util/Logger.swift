import Foundation

let logger: Logger = .init()

final class Logger {
    private var logLevel: LogLevel = .debug

    init() {
        #if DEBUG
        logLevel = .debug
        #else
        logLevel = .info
        #endif
    }
}

extension Logger {
    func debug(_ message: String, file: StaticString = #file, line: UInt8 = #line) {
        dump(logLevel: .debug, message: "\(message)", file: file, line: line)
    }

    func info(_ message: String, file: StaticString = #file, line: UInt8 = #line) {
        dump(logLevel: .info, message: "\(message)", file: file, line: line)
    }

    func error(_ message: String, file: StaticString = #file, line: UInt8 = #line) {
        dump(logLevel: .error, message: "\(message)", file: file, line: line)
    }
}

private extension Logger {
    func dump(logLevel: LogLevel, message: String, file: StaticString, line: UInt8) {
        guard logLevel >= self.logLevel else { return }
        print(logLevel.setColor("[\(logLevel.rawValue.uppercased())] \(message)"))
    }
}

// MARK: -
private extension Logger {
    enum LogLevel: String, CaseIterable {
        case debug
        case info
        case warn
        case error
    }
}

extension Logger.LogLevel {
    var ansiColor: ANSIColor {
        switch self {
        case .debug: .blue
        case .info: .green
        case .warn: .yellow
        case .error: .red
        }
    }
}

extension Logger.LogLevel {
    func setColor(_ string: String) -> String {
        "\(ansiColor.rawValue)\(string)\(ANSIColor.default.rawValue)"
    }
}

extension Logger.LogLevel: Comparable {
    static func < (lhs: Logger.LogLevel, rhs: Logger.LogLevel) -> Bool {
        allCases.firstIndex(of: lhs)! < allCases.firstIndex(of: rhs)!
    }
}
