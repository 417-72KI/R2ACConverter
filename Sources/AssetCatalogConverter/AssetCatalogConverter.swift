import ArgumentParser
import AssetCatalogConverterCore

@main
struct AssetCatalogConverter: AsyncParsableCommand {
    @Argument(help: "Path of the project to convert.")
    var path: String

    static var configuration: CommandConfiguration {
        .init(version: ApplicationInfo.version)
    }

    func run() async throws {
        try await Runner(path: path).run()
    }
}
