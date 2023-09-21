import UIKit

let globalImage_2 = UIImage(resource: .fooBar1)
let globalImage2_2 = UIImage(resource: .fooBar2)

let globalImages_2 = (UIImage(resource: .fooBarBaz), UIImage(resource: .fooBarBaz))

final class Foo2 {
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
extension Foo2.Bar {
    var image2: UIImage {
        switch self {
        case .hoge:
            return UIImage(resource: .fooBar1)
        case .fuga:
            return UIImage(resource: .fooBar2)
        }
    }
}
extension Foo2.Bar {
    struct Baz {
        var image = UIImage(resource: .fooBarBaz)
    }
}
