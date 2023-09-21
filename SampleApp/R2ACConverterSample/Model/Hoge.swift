import UIKit
import RswiftResources

struct Hoge {
    var imageType: ImageType
}

extension Hoge {
    var image: UIImage {
        UIImage(resource: imageType.image)!
    }

    var image2: UIImage {
        imageType.image.callAsFunction()!
    }

    var image3: UIImage {
        imageType.image()!
    }
}

extension Hoge {
    enum ImageType {
        case foo
        case bar
        case baz
    }
}

extension Hoge.ImageType {
    var image: RswiftResources.ImageResource {
        switch self {
        case .foo:
            R.image.foo_bar_1
        case .bar:
            R.image.foo_bar_2
        case .baz:
            R.image.fooBarBaz
        }
    }
}
