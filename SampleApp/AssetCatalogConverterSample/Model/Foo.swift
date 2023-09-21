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
