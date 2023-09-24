import ArgumentParser
import R2ACConverterCore

@main
struct R2ACConverter: AsyncParsableCommand {
    @Argument(help: "Path of the project to convert.")
    var path: String

    static var configuration: CommandConfiguration {
        .init(version: ApplicationInfo.version)
    }

    func run() async throws {
        try await Runner(path: path).run()
    }
}
