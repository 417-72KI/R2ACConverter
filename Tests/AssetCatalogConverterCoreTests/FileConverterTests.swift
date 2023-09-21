import XCTest
@testable import AssetCatalogConverterCore

final class FileConverterTests: XCTestCase {
    func testConvert() throws {
        let source = """
            import UIKit

            final class ViewController: UIViewController {
                @IBOutlet private weak var imageView: UIImageView!

                let image = R.image.foo_bar_1()
                let image2 = R.image.foo_bar_1_2()!

                override func viewDidLoad() {
                    super.viewDidLoad()

                    imageView.image = R.image.foo_bar_1()
                    imageView.image = R.image.foo_bar_2()!

                    view.backgroundColor = R.color.blue()
                    view.backgroundColor = R.color.blue()!
                }

                override func viewWillAppear(_ animated: Bool) {
                    super.viewWillAppear(animated)

                    let images = [
                        R.image.foo_bar_1(),
                        R.image.foo_bar_1_2(),
                        R.image.foo_bar_2(),
                        R.image.foo_bar_baz(),
                        R.image.fooBarBaz(),
                    ]

                    imageView.image = images.shuffled().first!

                    let colors = [
                        R.color.blue(),
                        R.color.blue1(),
                        R.color.blue_1_2(),
                        R.color.blue1_2(),
                    ]

                    view.backgroundColor = colors.shuffled().first!
                }
            }
            """

        let converted = """
            import UIKit

            final class ViewController: UIViewController {
                @IBOutlet private weak var imageView: UIImageView!

                let image = UIImage(resource: .fooBar1)
                let image2 = UIImage(resource: .fooBar12)

                override func viewDidLoad() {
                    super.viewDidLoad()

                    imageView.image = UIImage(resource: .fooBar1)
                    imageView.image = UIImage(resource: .fooBar2)

                    view.backgroundColor = UIColor(resource: .blue)
                    view.backgroundColor = UIColor(resource: .blue)
                }

                override func viewWillAppear(_ animated: Bool) {
                    super.viewWillAppear(animated)

                    let images = [
                        UIImage(resource: .fooBar1),
                        UIImage(resource: .fooBar12),
                        UIImage(resource: .fooBar2),
                        UIImage(resource: .fooBarBaz),
                        UIImage(resource: .fooBarBaz),
                    ]

                    imageView.image = images.shuffled().first!

                    let colors = [
                        UIColor(resource: .blue),
                        UIColor(resource: .blue1),
                        UIColor(resource: .blue12),
                        UIColor(resource: .blue12)
                    ]

                    view.backgroundColor = colors.shuffled().first!
                }
            }
            """

        let actual = try FileConverter.convert(source)
        XCTAssertEqual(converted, actual)
    }
}
