import ArgumentParser
import Foundation
import R2ACConverterCore

@main
struct Runner: AsyncParsableCommand {
    @Argument(help: "Path of the project to convert.")
    var path: String?

    static var configuration: CommandConfiguration {
        .init(version: ApplicationInfo.version)
    }

    func run() async throws {
        try await Core(path: path ?? FileManager.default.currentDirectoryPath).run()
    }
}
