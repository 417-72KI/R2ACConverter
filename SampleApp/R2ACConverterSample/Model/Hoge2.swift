import UIKit

struct Hoge2 {
    var resource: ImageResource
}

extension Hoge2 {
    var image: UIImage {
        UIImage(resource: resource.image)
    }

    var image2: UIImage {
        UIImage(resource: resource.image)
    }

    var image3: UIImage {
        UIImage(resource: resource.image)
    }
}

extension Hoge2 {
    enum ImageResource {
        case foo
        case bar
        case baz
    }
}

extension Hoge2.ImageResource {
    var image: ImageResource {
        switch self {
        case .foo:
            .fooBar1
        case .bar:
            .fooBar2
        case .baz:
            .fooBarBaz
        }
    }
}
