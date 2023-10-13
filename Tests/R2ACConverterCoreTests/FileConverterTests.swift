import XCTest

@testable import R2ACConverterCore

final class FileConverterTests: XCTestCase {
    func testConvert_UIKit_simple() throws {
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
                        .resized()!

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
                        .resized()!

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
                        UIColor(resource: .blue12),
                    ]

                    view.backgroundColor = colors.shuffled().first!
                }
            }
            """

        let actual = try FileConverter.convert(source)
        XCTAssertEqual(converted, actual)
    }

    func testConvert_UIKit_multipleBlocks() throws {
        let source = """
            import UIKit

            let globalImage = R.image.foo_bar_1()
            let globalImage2 = R.image.foo_bar_2()!

            let globalImages = (R.image.foo_bar_baz()!, R.image.fooBarBaz()!)

            final class Foo {
                enum Bar {
                    case hoge
                    case fuga

                    var image: UIImage {
                        switch self {
                        case .hoge:
                            return R.image.foo_bar_1()!
                        case .fuga:
                            return R.image.foo_bar_2()!
                        }
                    }
                }
            }
            extension Foo.Bar {
                var image2: UIImage {
                    switch self {
                    case .hoge:
                        return R.image.foo_bar_1()!
                    case .fuga:
                        return R.image.foo_bar_2()!
                    }
                }
            }
            extension Foo.Bar {
                struct Baz {
                    var image = R.image.foo_bar_baz()
                }
            }
            """

        let converted = """
            import UIKit

            let globalImage = UIImage(resource: .fooBar1)
            let globalImage2 = UIImage(resource: .fooBar2)

            let globalImages = (UIImage(resource: .fooBarBaz), UIImage(resource: .fooBarBaz))

            final class Foo {
                enum Bar {
                    case hoge
                    case fuga

                    var image: UIImage {
                        switch self {
                        case .hoge:
                            return UIImage(resource: .fooBar1)
                        case .fuga:
                            return UIImage(resource: .fooBar2)
                        }
                    }
                }
            }
            extension Foo.Bar {
                var image2: UIImage {
                    switch self {
                    case .hoge:
                        return UIImage(resource: .fooBar1)
                    case .fuga:
                        return UIImage(resource: .fooBar2)
                    }
                }
            }
            extension Foo.Bar {
                struct Baz {
                    var image = UIImage(resource: .fooBarBaz)
                }
            }
            """

        let actual = try FileConverter.convert(source)
        XCTAssertEqual(converted, actual)
    }

    func testConvert_SwiftUI() throws {
        let source = """
            import SwiftUI

            struct SwiftUIView: View {
                var body: some View {
                    ScrollView {
                        VStack {
                            Image(R.image.foo_bar_1)
                                .background(Color(uiColor: R.color.blue()!))
                            Image(R.image.foo_bar_1_2)
                                .background(Color(R.color.blue_1_2))
                            Image(R.image.foo_bar_2)
                                .background { Color(uiColor: R.color.blue()!) }
                            Image(uiImage: R.image.foo_bar_baz()!)
                                .background {
                                    Color(R.color.blue1_2)
                                }
                        }.padding(8)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            """

        let converted = """
            import SwiftUI

            struct SwiftUIView: View {
                var body: some View {
                    ScrollView {
                        VStack {
                            Image(.fooBar1)
                                .background(Color(.blue))
                            Image(.fooBar12)
                                .background(Color(.blue12))
                            Image(.fooBar2)
                                .background { Color(.blue) }
                            Image(.fooBarBaz)
                                .background {
                                    Color(.blue12)
                                }
                        }.padding(8)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            """

        let actual = try FileConverter.convert(source)
        XCTAssertEqual(converted, actual)
    }

    func testConvert_notModified() throws {
        let source = #"let foo = "bar""#
        let actual = try FileConverter.convert(source)
        XCTAssertEqual(source, actual)
    }
}
