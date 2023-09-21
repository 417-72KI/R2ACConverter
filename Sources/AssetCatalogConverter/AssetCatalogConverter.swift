import ArgumentParser
import AssetCatalogConverterCore

@main
struct AssetCatalogConverter: AsyncParsableCommand {
    @Argument(help: "Path")
    var path: String

    func run() async throws {
        try await Runner(path: path).run()
    }
}
